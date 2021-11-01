import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:memo_notes/view/home/todo/cubit/todo_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../extension/context_extension.dart';
import '../../extension/string_extension.dart';

class TodoPanel extends StatefulWidget {
  const TodoPanel({Key? key}) : super(key: key);

  @override
  _TodoPanelState createState() => _TodoPanelState();
}

class _TodoPanelState extends State<TodoPanel> {
  late AnimationController _animationControllerDelete;
  late AnimationController _animationControllerMark;
  final myGroup = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: deleteButton),
            Expanded(child: markButton),
          ],
        ),
        Divider(
          indent: context.dynamicWidth(0.04),
          endIndent: context.dynamicWidth(0.04),
          color: context.colorScheme.secondary,
          thickness: 0.5,
        ),
      ],
    );
  }

  ElevatedButton get markButton {
    return ElevatedButton(
      onPressed: () {
        _animationControllerMark.forward(from: 0.2);
        context.read<TodoCubit>().checkDoneAllTodos();
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.only(left: context.mediumValueW),
        side: BorderSide.none,
        primary: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        // ignore: prefer_const_literals_to_create_immutables

        children: [
          Flexible(
            flex: 4,
            child: markText,
          ),
          Flexible(
            child: Pulse(
              controller: (controller) => _animationControllerMark = controller,
              manualTrigger: true,
              child: Icon(
                Icons.check_circle,
                color: context.colorScheme.secondary,
                size: context.mediumValueH,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton get deleteButton {
    return ElevatedButton(
      onPressed: () {
        _animationControllerDelete.forward(from: 0);
        context.read<TodoCubit>().removeDoneTodos();
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.only(left: context.mediumValueW),
        side: BorderSide.none,
        primary: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Flexible(
            flex: 4,
            child: deleteText,
          ),
          Flexible(
            child: Spin(
              controller: (controller) => _animationControllerDelete = controller,
              manualTrigger: true,
              child: Icon(
                Icons.delete_outline_sharp,
                color: context.colorScheme.secondary,
                size: context.mediumValueH,
              ),
            ),
          ),
        ],
      ),
    );
  }

  AutoSizeText get deleteText {
    return AutoSizeText(
      "Clear Completed",
      maxLines: 1,
      group: myGroup,
    );
  }

  AutoSizeText get markText {
    return AutoSizeText(
      "Mark All",
      maxLines: 1,
      group: myGroup,
    );
  }
}
