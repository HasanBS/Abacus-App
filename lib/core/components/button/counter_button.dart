import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../view/home/counter/cubit/counter_cubit.dart';
import '../../../view/home/counter/model/counter_action_model.dart';
import '../../../view/home/counter/model/counter_model.dart';
import '../../constants/image/image_constatns.dart';
import '../../constants/navigation/navigation_constants.dart';
import '../../extension/context_extension.dart';
import '../../extension/string_extension.dart';
import '../../init/lang/locale_keys.g.dart';
import '../../init/navigation/navigation_service.dart';

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

  Future<void> myAsyncMethod(BuildContext context, VoidCallback onSuccess) async {
    deleteVisibility = false;
    context.pop();
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
                child: deleteButton(context),
              ),
              Expanded(child: counterButton(context)),
              if (deleteVisibility)
                Container()
              else
                FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      decreaseButtton(context),
                      increaseButton(context),
                    ],
                  ),
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

  IconButton increaseButton(BuildContext context) {
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

  IconButton decreaseButtton(BuildContext context) {
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

  ElevatedButton counterButton(BuildContext context) {
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
              child: titleText(context),
            ),
            Flexible(
              flex: 3,
              child: ZoomIn(
                controller: (controller) => _animationController = controller,
                manualTrigger: true,
                //duration: Duration(milliseconds: 400),
                child: Container(
                  alignment: Alignment.centerRight,
                  child: counterText(context),
                ),
              ),
            ),
          ],
        ));
  }

  AutoSizeText titleText(BuildContext context) {
    return AutoSizeText(
      widget.model.title,
      maxLines: 1,
      // text: TextSpan(
      //     style: context.textTheme.headline2, text: widget.model.title),
      // overflow: TextOverflow.ellipsis,
    );
  }

  AutoSizeText counterText(BuildContext context) {
    return AutoSizeText(
      NumberFormat.compact().format(widget.model.counterTotal),
      maxLines: 1,
      // textAlign: TextAlign.end,
      // text: TextSpan(
      //     text: context.doubleToString(widget.model.counterTotal),
      //     style: context.textTheme.headline2),
      // overflow: TextOverflow.ellipsis,
    );
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
        context.read<CounterCubit>().removeCounter(widget.model.id!);
      }),
      // onConfirmBtnTap: () {
      //   context.read<CounterCubit>().removeCounter(widget.model.id!);
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
}
