import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/components/text/auto_locale_text.dart';

import '../../../view/components/custom_rect_tween.dart';
import '../../../view/home/todo/cubit/todo_cubit.dart';
import '../../../view/home/todo/model/todo_model.dart';
import '../../../core/constants/app/app_constants.dart';
import '../../../core/extension/context_extension.dart';
import '../../../core/init/lang/locale_keys.g.dart';

class TodoPopup extends StatelessWidget {
  TodoPopup({Key? key, required this.heroAddTodo}) : super(key: key);

  final String heroAddTodo;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.paddingMedium,
        child: Hero(
          tag: heroAddTodo,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin!, end: end!);
          },
          child: _popupBody(context),
        ),
      ),
    );
  }

  Material _popupBody(BuildContext context) {
    return Material(
      color: context.colorScheme.primary,
      elevation: 2,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: context.normalValueH, horizontal: context.mediumValueW),
          child: Column(
            children: [
              _titleForm(context),
              Divider(
                color: context.colorScheme.secondary,
                thickness: 0.2,
              ),
              _insertButton
            ],
          ),
        ),
      ),
    );
  }

  Padding _titleForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.lowValueH),
      child: TextField(
        controller: _titleController,
        inputFormatters: [
          LengthLimitingTextInputFormatter(
            AppConstants.TODO_CARACTER_LIMIT,
          ),
        ],
        decoration: InputDecoration(
          labelText: LocaleKeys.counter_formTitle.tr(),
          contentPadding: EdgeInsets.only(left: context.mediumValueW, top: context.mediumValueH),
        ),
      ),
    );
  }

  BlocBuilder<TodoCubit, TodoState> get _insertButton {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () async {
            final model =
                TodoModel(title: _titleController.text, description: _descriptionController.text);
            context.navigation.pop();
            await context.read<TodoCubit>().insertTodo(model);
          },
          child: const AutoLocaleText(value: LocaleKeys.counter_pupup_add),
        );
      },
    );
  }
}
