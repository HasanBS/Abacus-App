import 'package:bottom_picker/bottom_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../view/components/custom_rect_tween.dart';
import '../../../view/home/countdown/cubit/countdown_cubit.dart';
import '../../../view/home/countdown/model/countdown_model.dart';
import '../../constants/app/app_constants.dart';
import '../../extension/context_extension.dart';
import '../../extension/string_extension.dart';
import '../../init/lang/locale_keys.g.dart';
import '../text/auto_locale_text.dart';

class CountdownPopup extends StatefulWidget {
  const CountdownPopup({Key? key, required this.heroAddTodo}) : super(key: key);

  final String heroAddTodo;

  @override
  _CountdownPopupState createState() => _CountdownPopupState();
}

class _CountdownPopupState extends State<CountdownPopup> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? date;
  DateTime? time;
  String? mood;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.paddingMedium, //!
        child: Hero(
          tag: widget.heroAddTodo,
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
                child: Column(
                  children: [
                    titleForm,
                    descriptionForm,
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: context.lowValueH),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          dateButton(context),
                          timeButton(context),
                        ],
                      ),
                    ),
                    Divider(
                      color: context.colorScheme.secondary,
                      thickness: 0.2,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BlocBuilder<CountdownCubit, CountdownState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: () async {
                              date ??= DateTime.now();
                              time ??= DateTime.now();

                              final DateTime dateTime = DateTime(date!.year, date!.month, date!.day,
                                  time!.hour, time!.minute, time!.second);
                              final CountdownModel model = CountdownModel(
                                  title: _titleController.text,
                                  description: _descriptionController.text,
                                  goalDate: dateTime.toString());
                              context.navigation.pop();

                              await context.read<CountdownCubit>().insertCountdown(model);
                            },
                            child: AutoLocaleText(value: LocaleKeys.countdown_popup_add.locale),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding get titleForm {
    return Padding(
      padding: EdgeInsets.only(bottom: context.normalValueH, top: context.lowValueH),
      child: TextField(
        controller: _titleController,
        inputFormatters: [
          LengthLimitingTextInputFormatter(
              AppConstants.TITLE_CARACTER_LIMIT), //Caracter limit for popup
        ],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: context.mediumValueW, top: context.lowValueH),
          labelText: LocaleKeys.countdown_formTitle.locale,
        ),
      ),
    );
  }

  TextField get descriptionForm {
    return TextField(
      controller: _descriptionController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: context.mediumValueW, top: context.mediumValueH),
        labelText: LocaleKeys.countdown_formDescription.locale,
      ),
      minLines: 2,
      maxLines: AppConstants.DESCRIPTION_LINE_LIMIT,
    );
  }

  ElevatedButton dateButton(BuildContext context) {
    //TODO: Acording to the language change time and date format
    return ElevatedButton(
      onPressed: () {
        _openDatePicker(context);
      },
      child: Text(date == null
              ? LocaleKeys.countdown_popup_setDate.locale
              : LocaleKeys.countdown_popup_date.tr(args: [
                  date!.day.toString(),
                  date!.month.toString(),
                  date!.year.toString(),
                ])

          // date!.day.toString() +
          //     "/" +
          //     date!.month.toString() +
          //     "/" +
          //     date!.year.toString(),
          ),
    );
  }

  dynamic _openDatePicker(BuildContext context) {
    BottomPicker.date(
      textStyle: context.textTheme.headline6!,
      backgroundColor: context.colorScheme.primary,
      buttonColor: context.colorScheme.secondary,
      iconColor: context.colorScheme.primary,
      dismissable: true,
      title: LocaleKeys.countdown_pickerDateTitle.locale,
      titleStyle: context.textTheme.headline6!,
      onSubmit: (index) {
        date = index as DateTime;
        setState(() {});
      },
    ).show(context);
  }

  ElevatedButton timeButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _openTimePicker(context);
      },
      child: Text(time == null
              ? LocaleKeys.countdown_popup_setTime.locale
              : LocaleKeys.countdown_popup_time.tr(args: [
                  time!.hour.toString(),
                  time!.minute.toString(),
                ])
          // time!.hour.toString() + ":" + time!.minute.toString(),
          ),
    );
  }

  dynamic _openTimePicker(BuildContext context) {
    BottomPicker.time(
            textStyle: context.textTheme.headline6!,
            backgroundColor: context.colorScheme.primary,
            buttonColor: context.colorScheme.secondary,
            iconColor: context.colorScheme.primary,
            dismissable: true,
            title: LocaleKeys.countdown_pickerTimeTitle.locale,
            titleStyle: context.textTheme.headline6!,
            onSubmit: (index) {
              time = index as DateTime;
              setState(() {});
            },
            use24hFormat: true)
        .show(context);
  }
}
