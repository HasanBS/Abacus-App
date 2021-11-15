import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../product/widget/alertDialog/cool_alert_dialog.dart';
import '../../../product/widget/divider/custom_divider.dart';

import '../../../view/home/counter/cubit/counter_cubit.dart';
import '../../../view/home/counter/model/counter_action_model.dart';
import '../../../view/home/counter/model/counter_model.dart';
import '../../../core/constants/image/image_constatns.dart';
import '../../../core/constants/navigation/navigation_constants.dart';
import '../../../core/extension/context_extension.dart';
import '../../../core/extension/string_extension.dart';
import '../../../core/init/lang/locale_keys.g.dart';
import '../../../core/init/navigation/navigation_service.dart';

class CounterField extends StatefulWidget {
  final CounterModel model;

  const CounterField({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  _CounterFieldState createState() => _CounterFieldState();
}

class _CounterFieldState extends State<CounterField> {
  late bool deleteVisibility;

  late AnimationController _animationController;
  late AnimationController _animationControllerDelete;

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
                child: _deleteButton,
              ),
              Expanded(child: _counterButton),
              if (deleteVisibility)
                Container()
              else
                FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _decreaseButtton,
                      _increaseButton,
                    ],
                  ),
                ),
            ],
          ),
          CustomDivider(context),
        ],
      ),
    );
  }

  Widget get _deleteButton {
    return IconButton(
      onPressed: () {
        _alertDialog(context);
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
      title: LocaleKeys.counter_delete_alertDialog_questionText.locale,
      lottieAssetDark: ImageConstants.instance.trashDark30Loti,
      lottieAssetLight: ImageConstants.instance.trashLight30Loti,
      confirmBtnText: LocaleKeys.counter_delete_alertDialog_confirmBtnText.locale,
      cancelBtnText: LocaleKeys.counter_delete_alertDialog_cancelBtnText.locale,
      onConfirmBtnTap: () async {
        context.pop();
        await _animationControllerDelete.animateTo(0).whenComplete(() {
          deleteVisibility = false;
          context.read<CounterCubit>().removeCounter(widget.model.id!);
        });
      },
      onCancelBtnTap: () {
        context.navigation.pop();
      },
    );
  }

  ElevatedButton get _counterButton {
    return ElevatedButton(
        onLongPress: () {
          setState(() {
            deleteVisibility = !deleteVisibility;
          });
        },
        onPressed: () async {
          await NavigationService.instance
              .navigateToPage(path: NavigationConstants.COUNTERPAGE, data: widget.model);
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
              flex: 7,
              child: _titleText(context),
            ),
            Flexible(
              flex: 3,
              child: ZoomIn(
                controller: (controller) => _animationController = controller,
                manualTrigger: true,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: _counterText(context),
                ),
              ),
            ),
          ],
        ));
  }

  AutoSizeText _titleText(BuildContext context) {
    return AutoSizeText(
      widget.model.title,
      maxLines: 1,
    );
  }

  AutoSizeText _counterText(BuildContext context) {
    return AutoSizeText(
      NumberFormat.compact().format(widget.model.counterTotal),
      maxLines: 1,
    );
  }

  IconButton get _decreaseButtton {
    return IconButton(
        onPressed: () {
          _animationController.forward(from: 0);

          widget.model.counterTotal -= widget.model.counterRatio;
          context.read<CounterCubit>().insertActionUpdateModel(
              CounterActionModel(
                  counterId: widget.model.id!,
                  isPositive: 0,
                  actionTotal: widget.model.counterTotal,
                  actionAmount: widget.model.counterRatio),
              widget.model);
        },
        icon: Icon(ImageConstants.instance.minusIcon));
  }

  IconButton get _increaseButton {
    return IconButton(
      onPressed: () {
        widget.model.counterTotal += widget.model.counterRatio;
        _animationController.forward(from: 0);
        context.read<CounterCubit>().insertActionUpdateModel(
            CounterActionModel(
                counterId: widget.model.id!,
                isPositive: 1,
                actionTotal: widget.model.counterTotal,
                actionAmount: widget.model.counterRatio),
            widget.model);
      },
      icon: Icon(ImageConstants.instance.plusIcon),
    );
  }
}
