import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_notes/core/components/button/todo_panel.dart';
import 'package:memo_notes/view/home/todo/model/todo_model.dart';

import '../../../../core/components/button/todo_button.dart';
import '../cubit/todo_cubit.dart';

class TodoView extends StatelessWidget {
  const TodoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TodoModel?> todoList = [];

    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        if (state is TodoListLoadSuccess) {
          print("TodoListItemListLoadSuccess");
          todoList = state.todoList;
        } else if (state is TodoLoadInProgress)
          print("TodoLoadInProgress");
        else if (state is TodoLoadFailure) print("TodoLoadFailure  => ${state.e}");
        return ListView(
          children: [
            const TodoPanel(),
            for (var i = 0; i < todoList.length; i++) TodoField(model: todoList[i]!),
          ],
        );
      },
    );
  }
}
