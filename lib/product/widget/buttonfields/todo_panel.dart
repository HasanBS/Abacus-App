import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/init/lang/locale_keys.g.dart';
import '../../../core/extension/string_extension.dart';

import '../../../product/widget/divider/custom_divider.dart';
import '../../../view/home/todo/cubit/todo_cubit.dart';
import '../../../core/extension/context_extension.dart';

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
            Expanded(child: _deleteButton),
            Expanded(child: _markButton),
          ],
        ),
        CustomDivider(context),
      ],
    );
  }

  ElevatedButton get _markButton {
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
        children: [
          Flexible(
            flex: 4,
            child: _markText,
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

  ElevatedButton get _deleteButton {
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
        children: [
          Flexible(
            flex: 4,
            child: _deleteText,
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

  AutoSizeText get _deleteText {
    return AutoSizeText(
      LocaleKeys.todo_clearCompleted.locale,
      maxLines: 1,
      group: myGroup,
    );
  }

  AutoSizeText get _markText {
    return AutoSizeText(
      LocaleKeys.todo_markAll.locale,
      maxLines: 1,
      group: myGroup,
    );
  }
}
