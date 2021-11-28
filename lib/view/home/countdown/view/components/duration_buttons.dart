import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/image/image_constatns.dart';
import '../../../../../core/extension/context_extension.dart';
import '../../../../../core/extension/string_extension.dart';
import '../../../../../core/init/lang/locale_keys.g.dart';
import '../../../../../product/widget/bottomPicker/date_picker.dart';
import '../../../../../product/widget/bottomPicker/time_picker.dart';
import '../../model/countdown_model.dart';
import '../../model/duration_model.dart';
import 'countdown_calculator.dart';
import 'package:sizer/sizer.dart';

class DurationButtons extends StatefulWidget {
  final CountdownModel model;
  final ValueChanged<bool> onValueChange;
  final ValueChanged<DateTime> onDateChange;
  final bool onEdit;

  const DurationButtons({
    Key? key,
    required this.model,
    required this.onValueChange,
    required this.onEdit,
    required this.onDateChange,
  }) : super(key: key);

  @override
  _DurationButtonsState createState() => _DurationButtonsState();
}

class _DurationButtonsState extends State<DurationButtons> {
  final autoSizeGroup = AutoSizeGroup();
  final CountdownCalculator _calculator = const CountdownCalculator();

  late DateTime _date;
  late Stream<DurationModel> _durationStream;
  late StreamSubscription _streamSubscription;
  late DurationModel _dateDuration;

  @override
  void initState() {
    _date = DateTime.parse(widget.model.goalDate);
    _durationStream = _calculator.calculator(dateTime: _date);
    _streamSubscription = _durationStream.listen((event) {
      setState(() {
        _dateDuration = event;
      });
    });
    _dateDuration = _calculator.initCalculation(dateTime: _date);
    super.initState();
  }

  void _subcriptionRefresh() {
    _streamSubscription.cancel();
    _streamSubscription = _calculator.calculator(dateTime: _date).listen((event) {
      setState(() {
        _dateDuration = event;
      });
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25.h,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 5.h,
            child: isPastText(context),
          ),
          SizedBox(
            height: 10.h,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: _dateButton(context),
            ),
          ),
          SizedBox(
            height: 10.h,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: _timeButton(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget isPastText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_dateDuration.isPast)
          Icon(
            ImageConstants.instance.leftChevron,
            color: context.colorScheme.secondary,
            size: 25,
          )
        else
          Container(),
        AutoSizeText(
          _dateDuration.isPast
              ? LocaleKeys.countdown_page_since.locale
              : LocaleKeys.countdown_page_until.locale,
          style: context.textTheme.subtitle2,
        ),
        if (!_dateDuration.isPast)
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

  ElevatedButton _dateButton(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onEdit
          ? () {
              _openDatePicker(context);
            }
          : null,
      style: ElevatedButton.styleFrom(
        side: widget.onEdit
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
      child: _dateText(_dateDuration, context),
    );
  }

  AutoSizeText _dateText(DurationModel duration, BuildContext context) {
    return AutoSizeText(
      (duration.year == 0
              ? ''
              : LocaleKeys.countdown_page_year.tr(args: [duration.year.toString()])) +
          (duration.month == 0
              ? ''
              : LocaleKeys.countdown_page_month.tr(args: [duration.month.toString()])) +
          (duration.day == 0
              ? ''
              : LocaleKeys.countdown_page_day.tr(args: [duration.day.toString()])),
      style: context.textTheme.headline1,
      maxLines: 1,
      group: autoSizeGroup,
    );
  }

  ElevatedButton _timeButton(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onEdit
          ? () {
              _openTimePicker(context);
            }
          : null,
      style: ElevatedButton.styleFrom(
        side: widget.onEdit
            ? BorderSide(color: context.colorScheme.secondary, width: 2.0)
            : BorderSide.none,
        onPrimary: Colors.transparent,
        primary: Colors.transparent,
        shadowColor: Colors.transparent,
        onSurface: context.colorScheme.primary,
      ),
      child: timeText(context, _dateDuration),
    );
  }

  AutoSizeText timeText(BuildContext context, DurationModel duration) {
    return AutoSizeText(
      (duration.hour == 0
              ? ''
              : LocaleKeys.countdown_page_hour.tr(args: [duration.hour.toString()])) +
          (duration.minute == 0
              ? ''
              : LocaleKeys.countdown_page_minute.tr(args: [duration.minute.toString()])) +
          LocaleKeys.countdown_page_second.tr(args: [duration.second.toString()]),
      style: context.textTheme.headline1,
      maxLines: 1,
      group: autoSizeGroup,
    );
  }

  dynamic _openDatePicker(BuildContext context) {
    DateBottomPicker.date(
      context: context,
      title: LocaleKeys.countdown_pickerDateTitle.locale,
      onChange: (_) {
        widget.onValueChange(true);
      },
      initialDateTime: _date,
      onSubmit: (index) {
        setState(() {
          final newDate = index as DateTime;
          _date = DateTime(newDate.year, newDate.month, newDate.day, _date.hour, _date.minute,
              _date.second, _date.millisecond, _date.microsecond);
          widget.onDateChange(_date);
          _dateDuration = _calculator.initCalculation(dateTime: _date);
          _subcriptionRefresh();
        });
      },
    ).show(context);
  }

  dynamic _openTimePicker(BuildContext context) {
    TimeBottomPicker.time(
      context: context,
      title: LocaleKeys.countdown_pickerTimeTitle.locale,
      initialDateTime: _date,
      onChange: (_) {
        widget.onValueChange(true);
      },
      onSubmit: (index) {
        setState(() {
          final newTime = index as DateTime;
          _date = DateTime(_date.year, _date.month, _date.day, newTime.hour, newTime.minute);
          widget.onDateChange(_date);
          _dateDuration = _calculator.initCalculation(dateTime: _date);
          _subcriptionRefresh();
        });
      },
    ).show(context);
  }
}
