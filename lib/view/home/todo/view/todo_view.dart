import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/components/card/error_widget.dart';
import '../../../../product/widget/buttonfields/todo_button.dart';
import '../../../../product/widget/buttonfields/todo_panel.dart';
import '../cubit/todo_cubit.dart';
import '../model/todo_model.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        if (state is TodoListLoadSuccess) {
          return TodoView(todoList: state.todoList);
        } else if (state is TodoLoadInProgress) {
          return const CircularProgressIndicator();
        } else if (state is TodoLoadFailure) {
          return ErrorCard(error: 'TodoLoadFailure  => ${state.e}');
        }
        return const SizedBox();
      },
    );
  }
}

class TodoView extends StatelessWidget {
  final List<TodoModel> todoList;
  const TodoView({
    Key? key,
    required this.todoList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TodoPanel(),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: todoList.length,
            itemBuilder: (context, index) {
              return TodoField(model: todoList[index]);
            },
          ),
        ),
      ],
    );
  }
}
