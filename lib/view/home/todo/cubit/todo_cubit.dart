import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../model/todo_model.dart';
import '../provider/todo_database_provider.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(TodoLoadInProgress());

  Future<void> insertTodo(TodoModel model) async {
    await TodoDatabaseProvider.instance.insertItem(model);
    getTodoList();
  }

  Future<void> getTodo(int id) async {
    try {
      final todo = await TodoDatabaseProvider.instance.getItem(id);
      emit(TodoLoadSuccess(todo!));
    } on Exception catch (e) {
      emit(TodoLoadFailure(e));
    }
  }

  Future<void> getTodoList() async {
    try {
      final todoListItemList = await TodoDatabaseProvider.instance.getList();
      emit(TodoListLoadSuccess(todoListItemList));
    } on Exception catch (e) {
      emit(TodoLoadFailure(e));
    }
  }

  Future<void> updateTodo(int id, TodoModel model) async {
    if (state is TodoListLoadSuccess) {
      final todolistItemList = (state as TodoListLoadSuccess).todoList;

      final updatedTodoListItems = todolistItemList.map((todoListItem) {
        return todoListItem!.id == model.id ? model : todoListItem;
      }).toList();

      emit(TodoListLoadSuccess(updatedTodoListItems));
    }
    await TodoDatabaseProvider.instance.updateItem(id, model); //?Stady
  }

  Future<void> checkDoneAllTodos() async {
    if (state is TodoListLoadSuccess) {
      final todolistItemList = (state as TodoListLoadSuccess).todoList;

      final todoUnDoneList =
          todolistItemList.where((todoListItem) => todoListItem!.isDone == 0).toList();

      final updatedTodoListItems = todolistItemList.map((todoListItem) {
        return todoListItem!..isDone = 1;
      }).toList();

      emit(TodoListLoadSuccess(updatedTodoListItems));

      for (var i = 0; i < todoUnDoneList.length; i++) {
        await TodoDatabaseProvider.instance
            .updateItem(todoUnDoneList[i]!.id!, todoUnDoneList[i]!); //?Stady
      }
    }
  }

  Future<void> removeTodo(int id) async {
    if (state is TodoListLoadSuccess) {
      final updatedTodoListItems = (state as TodoListLoadSuccess)
          .todoList
          .where((todoListItem) => todoListItem!.id != id)
          .toList();

      emit(TodoListLoadSuccess(updatedTodoListItems));
      await TodoDatabaseProvider.instance.removeItem(id); //?is Stady
    }
  }

  Future<void> removeDoneTodos() async {
    if (state is TodoListLoadSuccess) {
      final updatedTodoList = (state as TodoListLoadSuccess)
          .todoList
          .where((todoListItem) => todoListItem!.isDone == 0)
          .toList();

      final removedTodoList = (state as TodoListLoadSuccess)
          .todoList
          .where((todoListItem) => todoListItem!.isDone == 1)
          .toList();

      emit(TodoListLoadSuccess(updatedTodoList));

      for (var i = 0; i < removedTodoList.length; i++) {
        await TodoDatabaseProvider.instance.removeItem(removedTodoList[i]!.id!);
      }
    }
  }
}
