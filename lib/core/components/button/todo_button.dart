import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_notes/core/constants/image/image_constatns.dart';
import 'package:memo_notes/core/init/lang/locale_keys.g.dart';

import '../../../view/home/todo/cubit/todo_cubit.dart';
import '../../../view/home/todo/model/todo_model.dart';
import '../../extension/context_extension.dart';
import '../../extension/string_extension.dart';

class TodoField extends StatefulWidget {
  final TodoModel model;
  //final List<TodoModel?> todoModelList;

  const TodoField({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  _TodoFieldState createState() => _TodoFieldState();
}

class _TodoFieldState extends State<TodoField> {
  late bool deleteVisibility;

  late AnimationController _animationControllerMark;

  late AnimationController _animationControllerDelete;

  Future<void> myAsyncMethod(BuildContext context, VoidCallback onSuccess) async {
    deleteVisibility = false;
    await _animationControllerDelete.animateTo(0);
    onSuccess.call();
  }

  @override
  void initState() {
    deleteVisibility = false;
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
                visible: deleteVisibility,
                child: deleteButton,
              ),
              Expanded(child: counterButton),
            ],
          ),
          Divider(
            indent: context.dynamicWidth(0.04),
            endIndent: context.dynamicWidth(0.04),
            color: context.colorScheme.secondary,
            thickness: 0.5,
          ),
        ],
      ),
    );
  }

  Widget get deleteButton {
    return IconButton(
      onPressed: () async {
        await _animationControllerDelete.animateTo(0);
        context.read<TodoCubit>().removeTodo(widget.model.id!);
        deleteVisibility = false;
        // alertDialog(context);
      },
      icon: Icon(
        Icons.delete_outline_sharp,
        color: context.colorScheme.secondary,
        size: context.mediumValueH,
      ),
    );
  }

  dynamic alertDialog(BuildContext context) {
    CoolAlert.show(
      onConfirmBtnTap: () => myAsyncMethod(context, () {
        context.read<TodoCubit>().removeTodo(widget.model.id!);
      }),
      // onConfirmBtnTap: () {
      //   context.read<TodoCubit>().removeTodo(widget.model.id!);
      //   deleteVisibility = false;
      //   context.pop();
      // },
      lottieAsset: context.isDarkTheme
          ? ImageConstants.instance.trashDark30Loti
          : ImageConstants.instance.trashLight30Loti,
      context: context,
      type: CoolAlertType.confirm,
      title: LocaleKeys.counter_delete_alertDialog_questionText.locale,
      confirmBtnText: LocaleKeys.counter_delete_alertDialog_confirmBtnText.locale,
      cancelBtnText: LocaleKeys.counter_delete_alertDialog_cancelBtnText.locale,
      cancelBtnTextStyle: context.textTheme.headline6,
      confirmBtnTextStyle: context.textTheme.headline6,
      confirmBtnColor: context.colorScheme.primary,
      borderRadius: 0,
      backgroundColor: context.colorScheme.primary,
    );
  }

  ElevatedButton get counterButton {
    return ElevatedButton(
        onLongPress: () {
          setState(() {
            deleteVisibility = !deleteVisibility;
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
              child: titleText,
            ),
            Flexible(
              flex: 2,
              child: ZoomIn(
                controller: (controller) => _animationControllerMark = controller,
                manualTrigger: true,
                child: Container(
                  alignment: Alignment.center,
                  child: Icon(
                    widget.model.isDone == 0 ? Icons.cancel_outlined : Icons.check_circle,
                    size: context.mediumValueH,
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  AutoSizeText get titleText {
    return AutoSizeText(
      widget.model.title,
      maxLines: 1,
    );
  }
}

// height: context.highValueH,
//       padding: context.paddingLow,
//       color: Colors.amber,
//       child: Column(
//         children: [
//           Text(todoListModel.title),
//           ListView.builder(
//               shrinkWrap: true,
//               itemCount: todoListModel.todos!.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return ListTile(
//                   onTap: () {},
//                   leading: Checkbox(
//                     value: todoListModel.todos![index]!.isDone == 1 || false,
//                     onChanged: (value) {
//                       value = !value!;

//                       context.read<TodoCubit>().updateTodoItem(
//                           todoListModel.todos![index]!.id!,
//                           TodoModel(
//                               todoListId: todoListModel.todos![index]!.todoListId,
//                               title: todoListModel.todos![index]!.title,
//                               isDone: value ? 1 : 0));
//                     },
//                   ),
//                   title: Text(
//                     todoListModel.todos![index]!.title,
//                     style: Theme.of(context).textTheme.headline6,
//                   ),
//                   subtitle: IconButton(onPressed: () {}, icon: const Icon(Icons.add)),

//                   // todo.note.isNotEmpty
//                   //     ? Text(
//                   //         todo.note,
//                   //         key: ArchSampleKeys.todoItemNote(todo.id),
//                   //         maxLines: 1,
//                   //         overflow: TextOverflow.ellipsis,
//                   //         style: Theme.of(context).textTheme.subtitle1,
//                   //       )
//                   //     : null,
//                 );
//               }),
//           IconButton(
//               onPressed: () {
//                 context
//                     .read<TodoCubit>()
//                     .insertTodoItem(TodoModel(todoListId: todoListModel.id!, title: "selam"));
//               },
//               icon: const Icon(Icons.add)),
//         ],
//       ),

// return Container(
//   height: context.highValue * 2,
//   padding: context.paddingLow,
//   child: ClipRRect(
//     borderRadius: BorderRadius.circular(15),
//     child: Stack(
//       children: [
//         GradientBackground(
//           colorRight: Color(0xff53B8BB),
//           colorLeft: Color(0xffF3F2C9),
//         ),
//         ElevatedButton(
//             onPressed: widget.onPressed,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   widget.title,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black),
//                 ),
//                 Text(
//                   widget.dateTime,
//                   overflow: TextOverflow.ellipsis,
//                   style: Theme.of(context).textTheme.bodyText1,
//                 ),
//               ],
//             ),
//             style: ElevatedButton.styleFrom(
//               // shape: RoundedRectangleBorder(
//               //     borderRadius:
//               //         BorderRadius.horizontal(right: Radius.circular(50))),
//               fixedSize: Size(210, 75),
//               primary: Colors.transparent,
//               shadowColor: Colors.transparent,
//               padding: EdgeInsets.all(20), //button kalinlik
//             )),
//       ],
//     ),
//   ),
// );
