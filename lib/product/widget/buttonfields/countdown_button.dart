import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../view/api/notification/service/notification_service.dart';
import '../../../core/extension/duration_extension.dart';
import '../../../product/widget/alertDialog/cool_alert_dialog.dart';
import '../../../product/widget/divider/custom_divider.dart';
import '../../../view/home/countdown/model/duration_model.dart';
import '../../../view/home/countdown/view/components/countdown_calculator.dart';

import '../../../view/home/countdown/cubit/countdown_cubit.dart';
import '../../../view/home/countdown/model/countdown_model.dart';
import '../../../core/constants/image/image_constatns.dart';
import '../../../core/constants/navigation/navigation_constants.dart';
import '../../../core/extension/context_extension.dart';
import '../../../core/extension/string_extension.dart';
import '../../../core/init/lang/locale_keys.g.dart';
import '../../../core/init/navigation/navigation_service.dart';

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
  final CountdownCalculator _calculator = const CountdownCalculator();
  final AutoSizeGroup autoSizeGroup = AutoSizeGroup();

  late bool deleteVisibility;
  late DateTime _date;
  late DurationModel _dateDuration;
  late Stream<DurationModel> _durationStream;
  late StreamSubscription _streamSubscription;
  late AnimationController _animationControllerDelete;

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
    deleteVisibility = false;

    super.initState();
  }

  void _subcriptionRefresh() {
    _date = DateTime.parse(widget.model.goalDate);
    setState(() {
      _dateDuration = _calculator.initCalculation(dateTime: _date);
    });
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
    return ZoomIn(
      controller: (controller) => _animationControllerDelete = controller,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Visibility(
                visible: deleteVisibility,
                child: _deleteButton(context),
              ),
              Expanded(
                child: _countdownButton,
              ),
            ],
          ),
          CustomDivider(context),
        ],
      ),
    );
  }

  Widget _deleteButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        _alertDialog;
      },
      icon: Icon(
        Icons.delete_outline_sharp,
        color: context.colorScheme.secondary,
        size: context.mediumValueH,
      ),
    );
  }

  dynamic get _alertDialog {
    CoolAlertDialog(
      context: context,
      title: LocaleKeys.countdown_delete_alertDialog_questionText.locale,
      confirmBtnText: LocaleKeys.countdown_delete_alertDialog_confirmBtnText.locale,
      cancelBtnText: LocaleKeys.countdown_delete_alertDialog_cancelBtnText.locale,
      lottieAssetDark: ImageConstants.instance.trashDark30Loti,
      lottieAssetLight: ImageConstants.instance.trashLight30Loti,
      onConfirmBtnTap: () async {
        context.pop();
        await _animationControllerDelete.animateTo(0).whenComplete(() {
          deleteVisibility = false;
          context.read<CountdownCubit>().removeCountdown(widget.model.id!);
        });
        final _notificationProvider = NotificationService.instance;
        await _notificationProvider.cancelAllNotification(widget.model.id!);
      },
      onCancelBtnTap: () => context.navigation.pop(),
    );
  }

  ElevatedButton get _countdownButton {
    return ElevatedButton(
        onLongPress: () {
          setState(() {
            deleteVisibility = !deleteVisibility;
          });
        },
        onPressed: () async {
          await NavigationService.instance
              .navigateToPage(path: NavigationConstants.COUNTDOWNPAGE, data: widget.model);

          _subcriptionRefresh();
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
                  Flexible(flex: 6, child: _titleText),
                  Flexible(flex: 2, child: _pastText),
                ],
              ),
            ),
            Flexible(flex: 2, child: _dateText),
          ],
        ));
  }

  Widget get _titleText {
    return Container(
      alignment: Alignment.centerLeft,
      child: AutoSizeText(
        widget.model.title,
        maxLines: 1,
        group: autoSizeGroup,
      ),
    );
  }

  Container get _pastText {
    return Container(
      alignment: Alignment.center,
      child: AutoSizeText(
        _dateDuration.isPast
            ? LocaleKeys.countdown_buttonField_since.locale
            : LocaleKeys.countdown_buttonField_until.locale,
        maxLines: 1,
        group: autoSizeGroup,
      ),
    );
  }

  Widget get _dateText {
    return deleteVisibility
        ? Container()
        : Container(
            alignment: Alignment.bottomRight,
            child: Column(
              children: [
                AutoSizeText(
                  _dateDuration.filledTwo.first,
                  maxLines: 1,
                  group: autoSizeGroup,
                ),
                AutoSizeText(
                  _dateDuration.filledTwo.last,
                  maxLines: 1,
                  group: autoSizeGroup,
                ),
              ],
            ),
          );
  }
}
