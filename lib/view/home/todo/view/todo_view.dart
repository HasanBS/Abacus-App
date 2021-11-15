import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../product/widget/buttonfields/todo_button.dart';
import '../../../../product/widget/buttonfields/todo_panel.dart';

import '../../../../core/components/card/error_widget.dart';
import '../cubit/todo_cubit.dart';
import '../model/todo_model.dart';

class TodoView extends StatelessWidget {
  const TodoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TodoModel?> todoList = [];

    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        if (state is TodoListLoadSuccess) {
          todoList = state.todoList;
        } else if (state is TodoLoadInProgress) {
          const CircularProgressIndicator();
        } else if (state is TodoLoadFailure) {
          ErrorCard(error: 'TodoLoadFailure  => ${state.e}');
        }
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
