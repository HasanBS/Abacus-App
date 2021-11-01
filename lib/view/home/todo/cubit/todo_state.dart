part of 'todo_cubit.dart';

@immutable
abstract class TodoState {
  const TodoState();
}

class TodoLoadInProgress extends TodoState {}

class TodoLoadSuccess extends TodoState {
  final TodoModel todo;
  const TodoLoadSuccess(this.todo);
}

class TodoListLoadSuccess extends TodoState {
  final List<TodoModel?> todoList;
  const TodoListLoadSuccess(this.todoList);
}

class TodoLoadFailure extends TodoState {
  final Object e;
  const TodoLoadFailure(this.e);
}
