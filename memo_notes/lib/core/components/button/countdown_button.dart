import 'dart:async';

import 'package:age_calculator/age_calculator.dart';
import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../view/home/countdown/cubit/countdown_cubit.dart';
import '../../../view/home/countdown/model/countdown_model.dart';
import '../../constants/image/image_constatns.dart';
import '../../constants/navigation/navigation_constants.dart';
import '../../extension/context_extension.dart';
import '../../extension/duration_extension.dart';
import '../../extension/string_extension.dart';
import '../../init/lang/locale_keys.g.dart';
import '../../init/navigation/navigation_service.dart';

class CountdownField extends StatefulWidget {
  final CountdownModel model;

  const CountdownField({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  _CountdownFieldState createState() => _CountdownFieldState();
}

class _CountdownFieldState extends State<CountdownField> {
  late bool deleteVisibility;

  late bool isPast;
  late DateDuration dateDuration;

  late int remaningYears;
  late int remaningMonths;
  late int remaningDays;

  late int remaningHours;
  late int remaningMinutes;
  late int remaningSeconds;
  late Timer timer;

  late AnimationController _animationControllerDelete;

  AutoSizeGroup autoSizeGroup = AutoSizeGroup();

  Future<void> myAsyncMethod(BuildContext context, VoidCallback onSuccess) async {
    deleteVisibility = false;
    context.pop();
    await _animationControllerDelete.animateTo(0);
    onSuccess.call();
  }

  void durationTime() {
    if (mounted) {
      setState(() {
        final Duration duration = DateTime.parse(widget.model.goalDate).difference(DateTime.now());

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

  void durationDate() {
    final Duration duration = DateTime.parse(widget.model.goalDate).difference(DateTime.now());

    if (duration.inSeconds > 0) {
      dateDuration = AgeCalculator.dateDifference(
          fromDate: DateTime.now(), toDate: DateTime.parse(widget.model.goalDate));
      isPast = false;
      remaningYears = dateDuration.years;
      remaningMonths = dateDuration.months;
      remaningDays = dateDuration.days;
    } else {
      dateDuration = AgeCalculator.age(DateTime.parse(widget.model.goalDate));
      isPast = true;
      remaningYears = dateDuration.years;
      remaningMonths = dateDuration.months;
      remaningDays = dateDuration.days;
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    deleteVisibility = false;
    durationDate();
    durationTime();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => durationTime());
  }

  @override
  Widget build(BuildContext context) {
    return SlideInUp(
      controller: (controller) => _animationControllerDelete = controller,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Visibility(
                visible: deleteVisibility,
                child: deleteButton(context),
              ),
              Expanded(
                child: ElevatedButton(
                    onLongPress: () {
                      setState(() {
                        deleteVisibility = !deleteVisibility;
                      });
                    },
                    onPressed: () async {
                      await NavigationService.instance.navigateToPage(
                          path: NavigationConstants.COUNTDOWNPAGE, data: widget.model);
                    },
                    style: ElevatedButton.styleFrom(
                      side: BorderSide.none,
                      primary: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(flex: 6, child: titleText(context)),
                              Flexible(flex: 2, child: pastText(context)),
                            ],
                          ),
                        ),
                        Flexible(flex: 2, child: dateText(context)),
                      ],
                    )),
              ),
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

  Widget titleText(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: AutoSizeText(
        widget.model.title,
        maxLines: 1,
        //style: context.textTheme.headline4,
        group: autoSizeGroup,
      ),
    );
  }

  Container pastText(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: AutoSizeText(
        isPast
            ? LocaleKeys.countdown_buttonField_since.locale
            : LocaleKeys.countdown_buttonField_until.locale,
        //style: context.textTheme.headline4,
        maxLines: 1,
        group: autoSizeGroup,
      ),
    );
  }

  Widget dateText(BuildContext context) {
    return deleteVisibility
        ? Container()
        : Container(
            alignment: Alignment.bottomRight,
            child: Column(
              children: [
                AutoSizeText(
                  dateString(widget.model.goalDate).first!,
                  maxLines: 1,
                  //style: context.textTheme.headline4,
                  group: autoSizeGroup,
                ),
                AutoSizeText(
                  dateString(widget.model.goalDate).last!,
                  maxLines: 1,
                  //style: context.textTheme.headline4,
                  group: autoSizeGroup,
                ),
              ],
            ),
          );
  }

  List<String?> dateString(String date) {
    durationDate();
    String? firstPartOfDate;
    String? secondPartOfDate;

    if (remaningYears > 0) {
      firstPartOfDate = LocaleKeys.countdown_buttonField_year.tr(args: [remaningYears.dateString]);
    }
    if (remaningMonths > 0) {
      if (firstPartOfDate == null) {
        firstPartOfDate =
            LocaleKeys.countdown_buttonField_month.tr(args: [remaningMonths.dateString]);
      } else {
        secondPartOfDate =
            LocaleKeys.countdown_buttonField_month.tr(args: [remaningMonths.dateString]);
      }
    }
    if (secondPartOfDate == null && remaningDays > 0) {
      if (firstPartOfDate == null) {
        firstPartOfDate = LocaleKeys.countdown_buttonField_day.tr(args: [remaningDays.dateString]);
      } else {
        secondPartOfDate = LocaleKeys.countdown_buttonField_day.tr(args: [remaningDays.dateString]);
      }
    }

    if (secondPartOfDate == null && remaningHours > 0) {
      if (firstPartOfDate == null) {
        firstPartOfDate =
            LocaleKeys.countdown_buttonField_hour.tr(args: [remaningHours.dateString]);
      } else {
        secondPartOfDate =
            LocaleKeys.countdown_buttonField_hour.tr(args: [remaningHours.dateString]);
      }
    }

    if (secondPartOfDate == null && remaningMinutes > 0) {
      if (firstPartOfDate == null) {
        firstPartOfDate =
            LocaleKeys.countdown_buttonField_minute.tr(args: [remaningMinutes.dateString]);
      } else {
        secondPartOfDate =
            LocaleKeys.countdown_buttonField_minute.tr(args: [remaningMinutes.dateString]);
      }
    }
    if (secondPartOfDate == null && remaningSeconds > 0) {
      secondPartOfDate =
          LocaleKeys.countdown_buttonField_second.tr(args: [remaningSeconds.dateString]);
    }
    firstPartOfDate = firstPartOfDate ??
        LocaleKeys.countdown_buttonField_minute.tr(args: [remaningMinutes.dateString]);
    secondPartOfDate = secondPartOfDate ??
        LocaleKeys.countdown_buttonField_second.tr(args: [remaningSeconds.dateString]);

    return [firstPartOfDate, secondPartOfDate];
  }

  Widget deleteButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        alertDialog(context);
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
        context.read<CountdownCubit>().removeCountdown(widget.model.id!);
      }),
      // onConfirmBtnTap: ()  {
      //   context.pop();

      //    context.read<CountdownCubit>().removeCountdown(widget.model.id!);

      //   deleteVisibility = false;
      // },
      lottieAsset: context.isDarkTheme
          ? ImageConstants.instance.trashDark30Loti
          : ImageConstants.instance.trashLight30Loti,
      context: context,
      type: CoolAlertType.confirm,
      title: LocaleKeys.countdown_delete_alertDialog_questionText.locale,
      confirmBtnText: LocaleKeys.countdown_delete_alertDialog_confirmBtnText.locale,
      cancelBtnText: LocaleKeys.countdown_delete_alertDialog_cancelBtnText.locale,
      cancelBtnTextStyle: context.textTheme.headline6,
      confirmBtnTextStyle: context.textTheme.headline6,
      confirmBtnColor: context.colorScheme.primary,
      borderRadius: 0,
      backgroundColor: context.colorScheme.primary,
    );
  }
}
