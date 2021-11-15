import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../product/widget/divider/custom_divider.dart';

import '../../../view/home/todo/cubit/todo_cubit.dart';
import '../../../view/home/todo/model/todo_model.dart';
import '../../../core/extension/context_extension.dart';

class TodoField extends StatefulWidget {
  final TodoModel model;

  const TodoField({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  _TodoFieldState createState() => _TodoFieldState();
}

class _TodoFieldState extends State<TodoField> {
  late bool _deleteVisibility;
  late AnimationController _animationControllerMark;
  late AnimationController _animationControllerDelete;

  @override
  void initState() {
    _deleteVisibility = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      controller: (controller) => _animationControllerDelete = controller,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Visibility(
                visible: _deleteVisibility,
                child: deleteButton,
              ),
              Expanded(child: _markButton),
            ],
          ),
          CustomDivider(context),
        ],
      ),
    );
  }

  Widget get deleteButton {
    return IconButton(
      onPressed: () async {
        await _animationControllerDelete.animateTo(0).whenComplete(() {
          context.read<TodoCubit>().removeTodo(widget.model.id!);
          _deleteVisibility = false;
        });
      },
      icon: Icon(
        Icons.delete_outline_sharp,
        color: context.colorScheme.secondary,
        size: context.mediumValueH,
      ),
    );
  }

  ElevatedButton get _markButton {
    return ElevatedButton(
        onLongPress: () {
          setState(() {
            _deleteVisibility = !_deleteVisibility;
          });
        },
        onPressed: () async {
          _animationControllerMark.forward(from: 0);
          context.read<TodoCubit>().updateTodo(
                widget.model.id!,
                TodoModel(
                  id: widget.model.id,
                  title: widget.model.title,
                  description: widget.model.description,
                  isDone: widget.model.isDone == 0 ? 1 : 0,
                  createDate: widget.model.createDate,
                  doneDate: DateTime.now().toString(),
                ),
              );
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.only(left: context.mediumValueW),
          side: BorderSide.none,
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 8,
              child: _titleText,
            ),
            Flexible(
              flex: 2,
              child: _animatedIcon,
            ),
          ],
        ));
  }

  AutoSizeText get _titleText {
    return AutoSizeText(
      widget.model.title,
      maxLines: 1,
    );
  }

  ZoomIn get _animatedIcon {
    return ZoomIn(
      controller: (controller) => _animationControllerMark = controller,
      manualTrigger: true,
      child: Container(
        alignment: Alignment.center,
        child: Icon(
          widget.model.isDone == 0 ? Icons.cancel_outlined : Icons.check_circle,
          size: context.mediumValueH,
        ),
      ),
    );
  }
}
