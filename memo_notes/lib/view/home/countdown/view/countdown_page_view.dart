import 'dart:async';

import 'package:age_calculator/age_calculator.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app/app_constants.dart';
import '../../../../core/constants/image/image_constatns.dart';
import '../../../../core/extension/context_extension.dart';
import '../../../../core/extension/duration_extension.dart';
import '../../../../core/extension/string_extension.dart';
import '../../../../core/init/lang/locale_keys.g.dart';
import '../cubit/countdown_cubit.dart';
import '../model/countdown_model.dart';

class CountdownPageView extends StatefulWidget {
  final CountdownModel model;
  const CountdownPageView({Key? key, required this.model}) : super(key: key);

  @override
  _CountdownPageViewState createState() => _CountdownPageViewState();
}

class _CountdownPageViewState extends State<CountdownPageView> {
  final autoSizeGroup = AutoSizeGroup();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  late DateTime date;

  DateTime? reminder;

  bool isChange = false;
  bool onEdit = false;
  late bool isPast;

  late int remaningYears;
  late int remaningMonths;
  late int remaningDays;

  late int remaningHours;
  late int remaningMinutes;
  late int remaningSeconds;

  late Timer timer;

  void durationTime() {
    if (mounted) {
      setState(() {
        final duration = date.difference(DateTime.now());
        if (duration.inSeconds > 0) {
          remaningHours = duration.hours;
          remaningMinutes = duration.minutes;
          remaningSeconds = duration.seconds;
        } else {
          remaningHours = duration.pastHours;
          remaningMinutes = duration.pastMinutes;
          remaningSeconds = duration.pastSeconds;
        }
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    timer.cancel();
    super.dispose();
  }

  void durationDate() {
    setState(() {
      final duration = date.difference(DateTime.now());
      if (duration.inSeconds > 0) {
        final dateDuration = AgeCalculator.dateDifference(fromDate: DateTime.now(), toDate: date);
        isPast = false;
        remaningYears = dateDuration.years;
        remaningMonths = dateDuration.months;
        remaningDays = dateDuration.days;
      } else {
        final dateDuration = AgeCalculator.age(date);
        isPast = true;
        remaningYears = dateDuration.years;
        remaningMonths = dateDuration.months;
        remaningDays = dateDuration.days;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.model.title);
    _descriptionController = TextEditingController(text: widget.model.description);
    date = DateTime.parse(widget.model.goalDate);

    durationDate();
    durationTime();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => durationTime());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (onEdit && isChange) {
          alertDialog(context);
          return false;
        }
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appBar(context),
        body: body(context),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          ImageConstants.instance.backArrow,
          color: context.colorScheme.secondary,
        ),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: () {
          Navigator.maybePop(context);
        },
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.5),
        child: Container(
          width: context.dynamicWidth(0.9),
          color: context.colorScheme.secondary,
          height: 0.5,
        ),
      ),
      actions: [
        Padding(
          padding: context.horizontalPaddingMedium,
          child: ElevatedButton(
            onPressed: () async {
              if (!onEdit) {
                onEdit = true;
                return;
              }
              onEdit = false;

              final updatedModel = CountdownModel(
                  id: widget.model.id,
                  title: _titleController.text,
                  description: _descriptionController.text,
                  goalDate: date.toString());

              widget.model.title = updatedModel.title;

              await context.read<CountdownCubit>().updateCountdown(updatedModel.id!, updatedModel);
            },
            style: ElevatedButton.styleFrom(
                side: BorderSide.none,
                shadowColor: Colors.transparent,
                primary: context.colorScheme.primary),
            child: AutoSizeText(
              onEdit
                  ? LocaleKeys.countdown_page_appBarSave.locale
                  : LocaleKeys.countdown_page_appBarEdit.locale,
              style: context.textTheme.headline6,
            ),
          ),
        ),
        //icon timer for saving
      ],
      title: AutoSizeText(
        widget.model.title,
        style: context.textTheme.headline6,
      ),
    );
  }

  Column body(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            _titleForm,
            dateText(context),
            descriptionForm,
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                  left: context.mediumValueW, top: context.lowValueH, right: context.mediumValueW),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: _reminderButton(context),
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isPastText(context),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: _dateButton(context),
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: _timeButton(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget isPastText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isPast)
          Icon(
            ImageConstants.instance.leftChevron,
            color: context.colorScheme.secondary,
            size: 25,
          )
        else
          Container(),
        AutoSizeText(
          isPast ? LocaleKeys.countdown_page_since.locale : LocaleKeys.countdown_page_until.locale,
          style: context.textTheme.subtitle2,
        ),
        if (!isPast)
          Icon(
            ImageConstants.instance.rightChevron,
            color: context.colorScheme.secondary,
            size: 25,
          )
        else
          Container(),
      ],
    );
  }

  Widget get _titleForm {
    return _titleController.text == "" && !onEdit
        ? Container()
        : Padding(
            padding: EdgeInsets.only(
                left: context.mediumValueW, top: context.lowValueH, right: context.mediumValueW),
            child: TextField(
              onChanged: (_) {
                isChange = true;
              },
              style: context.textTheme.headline4,
              //textAlign: TextAlign.center,
              enabled: onEdit,
              controller: _titleController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(
                    AppConstants.TITLE_CARACTER_LIMIT), //Caracter limit for popup
              ],
              decoration: InputDecoration(
                labelText: LocaleKeys.counter_formTitle.locale,
              ),
            ),
          );
  }

  Container dateText(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: context.mediumValueW, bottom: context.lowValueH, top: context.lowValueH),
      alignment: Alignment.centerLeft,
      child: AutoSizeText(
        dateString,
        style: context.textTheme.headline6, //headline6
      ),
    );
  }

  String get dateString {
    //?
    final dateForm =
        "${date.day < 10 ? "0${date.day}" : date.day.toString()}.${date.month < 10 ? "0${date.month}" : date.month.toString()}.${date.year}";
    return dateForm;
  }

  Widget get descriptionForm {
    return _descriptionController.text == "" && !onEdit
        ? Container()
        : Padding(
            padding: EdgeInsets.only(left: context.mediumValueW, right: context.mediumValueW),
            child: TextField(
              onChanged: (_) {
                isChange = true;
              },
              // style: context.textTheme.headline6,
              enabled: onEdit,
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: LocaleKeys.countdown_formDescription.locale,
              ),
              maxLines: AppConstants.DESCRIPTION_LINE_LIMIT,
              minLines: 2,
            ),
          );
  }

  ElevatedButton _dateButton(BuildContext context) {
    return ElevatedButton(
      onPressed: onEdit
          ? () {
              _openDatePicker(context);
            }
          : null,
      style: ElevatedButton.styleFrom(
        side: onEdit
            ? BorderSide(
                color: context.colorScheme.secondary,
                width: 2.0,
              )
            : BorderSide.none,
        onPrimary: Colors.transparent,
        primary: Colors.transparent,
        shadowColor: Colors.transparent,
        onSurface: context.colorScheme.primary,
      ),
      child: dateButtonText,
    );
  }

  ElevatedButton _reminderButton(BuildContext context) {
    return ElevatedButton(
      onPressed: !isPast
          ? () {
              _openRemainderPicker(context);
            }
          : null,
      style: ElevatedButton.styleFrom(
        side: !isPast
            ? BorderSide(
                color: context.colorScheme.secondary,
                width: 2.0,
              )
            : BorderSide.none,
        onPrimary: context.colorScheme.secondary,
        primary: Colors.transparent,
        shadowColor: Colors.transparent,
        onSurface: context.colorScheme.primary,
      ),
      child: reminderText,
    );
  }

  AutoSizeText get reminderText {
    return AutoSizeText(
      reminder != null
          ? ('Remainder ${reminder!.hour.dateString}:${reminder!.minute.dateString}')
          : 'Remainder',
      maxLines: 1,
    );
  }
  //!

  Widget get dateButtonText {
    return SizedBox(
      height: context.dynamicHeight(0.1),
      child: AutoSizeText(
        (remaningYears == 0
                ? ""
                : LocaleKeys.countdown_page_year.tr(args: [remaningYears.toString()])) +
            (remaningMonths == 0
                ? ""
                : LocaleKeys.countdown_page_month.tr(args: [remaningMonths.toString()])) +
            (remaningDays == 0
                ? ""
                : LocaleKeys.countdown_page_day.tr(args: [remaningDays.toString()])),
        style: context.textTheme.headline1,
        maxLines: 1,
        group: autoSizeGroup,
        //.copyWith(fontSize: context.dynamicWidth(0.15)), //headline2
      ),
    );
  }

  Padding _timeButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: context.highValueH,
      ),
      child: ElevatedButton(
        onPressed: onEdit
            ? () {
                _openTimePicker(context);
              }
            : null,
        style: ElevatedButton.styleFrom(
          side: onEdit
              ? BorderSide(
                  color: context.colorScheme.secondary,
                  width: 2.0,
                )
              : BorderSide.none,
          onPrimary: Colors.transparent,
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
          onSurface: context.colorScheme.primary,
        ),
        child: timeButtonText,
      ),
    );
  }

  Widget get timeButtonText {
    return SizedBox(
      height: context.dynamicHeight(0.11),
      child: AutoSizeText(
        (remaningHours == 0
                ? ""
                : LocaleKeys.countdown_page_hour.tr(args: [remaningHours.toString()])) +
            (remaningMinutes == 0
                ? ""
                : LocaleKeys.countdown_page_minute.tr(args: [remaningMinutes.toString()])) +
            LocaleKeys.countdown_page_second.tr(args: [remaningSeconds.toString()]),

        style: context.textTheme.headline1,
        maxLines: 1,
        group: autoSizeGroup,
        // .copyWith(fontSize: context.dynamicWidth(0.15)), //headline 2
      ),
    );
  }

  dynamic _openRemainderPicker(BuildContext context) {
    BottomPicker.time(
      textStyle: context.textTheme.headline6!,
      backgroundColor: context.colorScheme.primary,
      buttonColor: context.colorScheme.secondary,
      iconColor: context.colorScheme.primary,
      use24hFormat: true,
      initialDateTime: DateTime.utc(0),
      dismissable: true,
      title: 'Choose a hour to remind before',
      titleStyle: context.textTheme.headline6!,
      onSubmit: (index) {
        setState(() {
          final newDate = index as DateTime;
          reminder = DateTime(
            newDate.year,
            newDate.month,
            newDate.day,
            newDate.hour,
            newDate.minute,
            newDate.second,
            newDate.millisecond,
            newDate.microsecond,
          );
        });
      },
    ).show(context);
  }

  dynamic _openDatePicker(BuildContext context) {
    BottomPicker.date(
      onChange: (_) {
        isChange = true;
      },
      textStyle: context.textTheme.headline6!, //headline 6
      backgroundColor: context.colorScheme.primary,
      buttonColor: context.colorScheme.secondary,
      iconColor: context.colorScheme.primary,
      initialDateTime: date,
      dismissable: true,
      title: LocaleKeys.countdown_pickerDateTitle.locale,
      titleStyle: context.textTheme.headline6!,
      onSubmit: (index) {
        setState(() {
          final newDate = index as DateTime;
          date = DateTime(
            newDate.year,
            newDate.month,
            newDate.day,
            date.hour,
            date.minute,
            date.second,
            date.millisecond,
            date.microsecond,
          );
          durationDate();
        });
      },
    ).show(context);
  }

  dynamic _openTimePicker(BuildContext context) {
    BottomPicker.time(
            onChange: (_) {
              isChange = true;
            },
            textStyle: context.textTheme.headline6!,
            backgroundColor: context.colorScheme.primary,
            buttonColor: context.colorScheme.secondary,
            iconColor: context.colorScheme.primary,
            initialDateTime: date,
            dismissable: true,
            title: LocaleKeys.countdown_pickerTimeTitle.locale,
            titleStyle: context.textTheme.headline6!,
            onSubmit: (index) {
              setState(() {
                final newTime = index as DateTime;
                date = DateTime(date.year, date.month, date.day, newTime.hour, newTime.minute,
                    date.second, date.millisecond, date.microsecond);

                // time!.hour, time!.minute, time!.second
                // date = index as DateTime;
              });
            },
            use24hFormat: true)
        .show(context);
  }

  dynamic alertDialog(BuildContext context) {
    //?
    CoolAlert.show(
      onConfirmBtnTap: () async {
        final updatedModel = CountdownModel(
            id: widget.model.id,
            title: _titleController.text,
            description: _descriptionController.text,
            goalDate: date.toString());

        Navigator.of(context).pop();
        Navigator.of(context).pop();
        await context.read<CountdownCubit>().updateCountdown(updatedModel.id!, updatedModel);
      },
      onCancelBtnTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
      lottieAsset: context.isDarkTheme
          ? ImageConstants.instance.shieldDarkLoti
          : ImageConstants.instance.shieldLightLoti,
      context: context,
      type: CoolAlertType.confirm,
      title: LocaleKeys.countdown_save_alertDialog_questionText.locale,
      confirmBtnText: LocaleKeys.countdown_save_alertDialog_confirmBtnText.locale,
      cancelBtnText: LocaleKeys.countdown_save_alertDialog_cancelBtnText.locale,
      cancelBtnTextStyle: context.textTheme.bodyText1,
      confirmBtnTextStyle: context.textTheme.bodyText1,
      confirmBtnColor: context.colorScheme.primary,
      borderRadius: 0,
      backgroundColor: context.colorScheme.primary,
    );
  }
}
