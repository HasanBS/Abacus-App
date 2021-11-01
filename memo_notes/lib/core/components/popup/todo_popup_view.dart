import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_notes/core/components/text/auto_locale_text.dart';
import 'package:memo_notes/core/constants/app/app_constants.dart';
import 'package:memo_notes/core/init/lang/locale_keys.g.dart';
import 'package:memo_notes/view/home/todo/model/todo_model.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../view/components/custom_rect_tween.dart';
import '../../../view/home/todo/cubit/todo_cubit.dart';
import '../../extension/context_extension.dart';

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
          child: Material(
            color: context.colorScheme.primary,
            elevation: 2,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: context.normalValueH, horizontal: context.mediumValueW),
                child: Form(
                    child: Column(
                  children: [
                    titleForm(
                      context,
                    ),
                    //descriptionForm(context),
                    Divider(
                      color: context.colorScheme.secondary,
                      thickness: 0.2,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BlocBuilder<TodoCubit, TodoState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: () async {
                              final model = TodoModel(
                                  title: _titleController.text,
                                  description: _descriptionController.text);
                              context.navigation.pop();
                              await context.read<TodoCubit>().insertTodo(model);
                            },
                            child: const AutoLocaleText(value: LocaleKeys.counter_pupup_add),
                          );
                        },
                      ),
                    )
                  ],
                )),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding descriptionForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.lowValueH),
      child: TextField(
        controller: _descriptionController,
        decoration: InputDecoration(
          labelText: LocaleKeys.counter_formDescription.tr(),
          contentPadding: EdgeInsets.only(left: context.mediumValueW, top: context.mediumValueH),
        ),
        maxLines: 4,
      ),
    );
  }

  Padding titleForm(BuildContext context) {
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
}
