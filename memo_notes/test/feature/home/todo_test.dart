// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:memo_notes/view/home/todo/cubit/todo_cubit.dart';
// import 'package:memo_notes/view/home/todo/model/todo_model.dart';
// import 'package:memo_notes/view/home/todo/model/todolist_model.dart';

// class MockTodoCubit extends MockCubit<TodoState> implements TodoCubit {}

// void main() {
//   TodoCubit todoCubit = TodoCubit();

//   group('Todo Cubit Get Operations Test', () {
//     blocTest(
//       'get TodoListItem List',
//       build: () => TodoCubit()..getTodoListItemList(),
//       expect: () => [isA<TodoListItemListLoadSuccess>()],
//     );

//     blocTest(
//       'get TodoItem List',
//       build: () => TodoCubit()..getTodoItemList(),
//       expect: () => [isA<TodoItemListLoadSuccess>()],
//     );

//     blocTest(
//       'get getTodoList Item ',
//       build: () => TodoCubit()..getTodoListItem(1),
//       expect: () => [isA<TodoItemListLoadSuccess>()],
//     );
//   });

//   group('Todo Cubit Insert,Remove and Update Operations Test', () {
//     TodoListModel todoListModel = TodoListModel(title: "test");

//     TodoModel todoModel = TodoModel(todoListId: 0, title: "testTitle");

//     blocTest(
//       'insert TodoListItem',
//       build: () => TodoCubit()..insertTodoListItem(todoListModel),
//       expect: () => [isA<TodoListItemListLoadSuccess>()],
//     );

//     blocTest(
//       'insert todo',
//       build: () => TodoCubit()..insertTodoItem(todoModel),
//       expect: () => [isA<TodoItemListLoadSuccess>()],
//     );

//     // blocTest(
//     //   'update TodoListItem ',
//     //   build: () => TodoCubit()..updateTodoListItem(id, model),
//     //   expect: () => [isA<TodoListItemListLoadSuccess>()],
//     // );

//     // blocTest(
//     //   'update TodoItem ',
//     //   build: () => TodoCubit()..updateTodoItem(id, model),
//     //   expect: () => [isA<TodoItemListLoadSuccess>()],
//     // );

//     blocTest(
//       'remove TodoItem ',
//       build: () => TodoCubit()..removeTodoItem(1),
//       expect: () => [isA<TodoItemListLoadSuccess>()],
//     );

//     blocTest(
//       'remove TodoListItem ',
//       build: () => TodoCubit()..removeTodoListItem(1),
//       expect: () => [isA<TodoListItemListLoadSuccess>()],
//     );
//   });
// }
