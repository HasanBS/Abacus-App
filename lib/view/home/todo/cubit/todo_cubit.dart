import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../model/todo_model.dart';
import '../provider/todo_database_provider.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoDatabaseProvider provider;
  TodoCubit(
    this.provider,
  ) : super(TodoLoadInProgress());

  Future<void> insertTodo(TodoModel model) async {
    await provider.insertItem(model);
    getTodoList();
  }

  Future<void> getTodo(int id) async {
    try {
      final todo = await provider.getItem(id);
      emit(TodoLoadSuccess(todo!));
    } on Exception catch (e) {
      emit(TodoLoadFailure(e));
    }
  }

  Future<void> getTodoList() async {
    try {
      final todoListItemList = await provider.getList();
      emit(TodoListLoadSuccess(todoListItemList));
    } on Exception catch (e) {
      emit(TodoLoadFailure(e));
    }
  }

  Future<void> updateTodo(int id, TodoModel model) async {
    if (state is TodoListLoadSuccess) {
      final todolistItemList = (state as TodoListLoadSuccess).todoList;

      final updatedTodoListItems = todolistItemList.map((todoListItem) {
        return todoListItem.id == model.id ? model : todoListItem;
      }).toList();

      emit(TodoListLoadSuccess(updatedTodoListItems));
    }
    await provider.updateItem(id, model);
  }

  Future<void> checkDoneAllTodos() async {
    if (state is TodoListLoadSuccess) {
      final todolistItemList = (state as TodoListLoadSuccess).todoList;

      final todoUnDoneList =
          todolistItemList.where((todoListItem) => todoListItem.isDone == 0).toList();

      final updatedTodoListItems = todolistItemList.map((todoListItem) {
        return todoListItem..isDone = 1;
      }).toList();

      emit(TodoListLoadSuccess(updatedTodoListItems));

      for (var i = 0; i < todoUnDoneList.length; i++) {
        await provider.updateItem(todoUnDoneList[i].id!, todoUnDoneList[i]);
      }
    }
  }

  Future<void> removeTodo(int id) async {
    if (state is TodoListLoadSuccess) {
      final updatedTodoListItems = (state as TodoListLoadSuccess)
          .todoList
          .where((todoListItem) => todoListItem.id != id)
          .toList();

      emit(TodoListLoadSuccess(updatedTodoListItems));
      await provider.removeItem(id);
    }
  }

  Future<void> removeDoneTodos() async {
    if (state is TodoListLoadSuccess) {
      final updatedTodoList = (state as TodoListLoadSuccess)
          .todoList
          .where((todoListItem) => todoListItem.isDone == 0)
          .toList();

      final removedTodoList = (state as TodoListLoadSuccess)
          .todoList
          .where((todoListItem) => todoListItem.isDone == 1)
          .toList();

      emit(TodoListLoadSuccess(updatedTodoList));

      for (var i = 0; i < removedTodoList.length; i++) {
        await provider.removeItem(removedTodoList[i].id!);
      }
    }
  }
}
