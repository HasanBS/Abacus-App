import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cool_alert/cool_alert.dart';
// ignore: unused_import
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/components/text/auto_locale_text.dart';
import '../../../../core/constants/app/app_constants.dart';
import '../../../../core/constants/image/image_constatns.dart';
import '../../../../core/extension/context_extension.dart';
import '../../../../core/extension/string_extension.dart';
import '../../../../core/init/lang/locale_keys.g.dart';
import '../cubit/counter_cubit.dart';
import '../model/counter_action_model.dart';
import '../model/counter_model.dart';

class CounterPageView extends StatefulWidget {
  final CounterModel model;
  const CounterPageView({Key? key, required this.model}) : super(key: key);

  @override
  _CounterPageViewState createState() => _CounterPageViewState();
}

class _CounterPageViewState extends State<CounterPageView> {
  bool isChange = false;

  bool onEdit = false;

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _countTotalController;
  late final TextEditingController _countRatioController;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.model.title);
    _descriptionController = TextEditingController(text: widget.model.description);
    _countTotalController =
        TextEditingController(text: context.doubleToString(widget.model.counterTotal));
    _countRatioController =
        TextEditingController(text: context.doubleToString(widget.model.counterRatio));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
            onPressed: () {
              if (!onEdit) {
                onEdit = true;
                setState(() {});
                return;
              }
              setState(() {
                onEdit = false;

                double ratio = double.tryParse(_countRatioController.text) ?? 1;
                if (ratio == 0) {
                  ratio = 1;
                }
                final updateModel = CounterModel(
                  id: widget.model.id,
                  title: _titleController.text,
                  description: _descriptionController.text,
                  counterTotal: double.tryParse(_countTotalController.text) ?? 0,
                  counterRatio: ratio,
                );

                context.read<CounterCubit>().updateCounter(updateModel.id!, updateModel);
              });
            },
            style: ElevatedButton.styleFrom(
                side: BorderSide.none,
                shadowColor: Colors.transparent,
                primary: context.colorScheme.primary),
            child: AutoSizeText(
              onEdit
                  ? LocaleKeys.counter_page_appBarSave.locale
                  : LocaleKeys.counter_page_appBarEdit.locale,
            ),
          ),
        ),
      ],
      title: AutoSizeText(
        _titleController.text,
      ),
    );
  }

  Column body(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            titleForm,
            descriptionForm,
          ],
        ),
        countTotalForm(context),
        Column(
          children: [
            AutoLocaleText(
              value: LocaleKeys.counter_page_ratio,
              style: context.textTheme.subtitle2,
            ),
            countRatioForm,
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(child: decreaseButtton(context)),
            SizedBox(
              height: context.dynamicHeight(0.2),
              child: VerticalDivider(
                color: context.colorScheme.secondary,
                thickness: 0.5,
                width: 0,
              ),
            ),
            Flexible(child: increaseButton(context)),
          ],
        ),
      ],
    );
  }

  Widget get titleForm {
    return _titleController.text == "" && !onEdit
        ? Container()
        : Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.mediumValueW,
              vertical: context.lowValueH,
            ),
            child: TextField(
              onChanged: (_) {
                isChange = true;
              },
              style: context.textTheme.headline4,
              enabled: onEdit,
              controller: _titleController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(
                    AppConstants.TITLE_CARACTER_LIMIT), //Caracter limit for popup
              ],
              decoration: InputDecoration(
                labelText: LocaleKeys.counter_formTitle.locale,
                disabledBorder: InputBorder.none,
              ),
            ),
          );
  }

  Widget get descriptionForm {
    return _descriptionController.text == "" && !onEdit
        ? Container()
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: context.normalValueH),
            child: TextField(
              onChanged: (_) {
                isChange = true;
              },
              enabled: onEdit,
              controller: _descriptionController,
              decoration: InputDecoration(
                disabledBorder: InputBorder.none,
                labelText: LocaleKeys.counter_formDescription.locale,
              ),
              maxLines: AppConstants.DESCRIPTION_LINE_LIMIT,
              minLines: 2,
            ),
          );
  }

  BlocListener countTotalForm(BuildContext context) {
    return BlocListener<CounterCubit, CounterState>(
      listener: (context, state) {
        if (state is CounterListLoadSuccess) {
          final updated =
              state.counterList.where((element) => element!.id == widget.model.id!).first!;

          _countTotalController.text = context.doubleToString(updated.counterTotal);
          _countRatioController.text = context.doubleToString(updated.counterRatio);

          setState(() {
            widget.model.title = updated.title;
            widget.model.description = updated.description;
            widget.model.counterTotal = updated.counterTotal;
            widget.model.counterRatio = updated.counterRatio;
          });
        }
      },
      child: onEdit
          ? TextField(
              onChanged: (_) {
                isChange = true;
              },
              textAlign: TextAlign.center,
              style: context.textTheme.headline1!.copyWith(
                fontSize: (500 / _countTotalController.text.length).sp >
                        context.textTheme.headline1!.fontSize!
                    ? context.textTheme.headline1!.fontSize
                    : (500 / _countTotalController.text.length).sp,
              ),
              controller: _countTotalController,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(
                  AppConstants.NUMBER_CARACTER_LIMIT,
                ),
                FilteringTextInputFormatter.allow(
                    RegExp(AppConstants.NUMBER_REGIEX)), //r'[\d+\-\.]'
              ],
              keyboardType: TextInputType.number,
              enabled: onEdit,
              decoration: const InputDecoration(
                disabledBorder: InputBorder.none,
              ),
            )
          : FittedBox(
              fit: BoxFit.fitWidth,
              child: Padding(
                padding: context.horizontalPaddingMedium,
                child: AnimatedFlipCounter(
                  duration: const Duration(milliseconds: 500),
                  value: widget.model.counterTotal,
                  textStyle: context.textTheme.headline1,
                ),
              ),
            ),
    );
  }

  Padding get countRatioForm {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.normalValueH),
      child: TextField(
        onChanged: (_) {
          isChange = true;
        },
        style: context.textTheme.subtitle2,
        textAlign: TextAlign.center,
        enabled: onEdit,
        controller: _countRatioController,
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(
            AppConstants.RATIO_CARACTER_LIMIT,
          ),
          FilteringTextInputFormatter.allow(RegExp(AppConstants.NUMBER_REGIEX)),
        ],
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(disabledBorder: InputBorder.none),
      ),
    );
  }

  ElevatedButton increaseButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        //_animationController.forward(from: 0);
        widget.model.counterTotal += widget.model.counterRatio;
        context.read<CounterCubit>().insertActionUpdateModel(
            CounterActionModel(
                counterId: widget.model.id!,
                isPositive: 1,
                actionTotal: widget.model.counterTotal,
                actionAmount: widget.model.counterRatio),
            widget.model);
      },
      style: ElevatedButton.styleFrom(
          onPrimary: Colors.transparent,
          fixedSize: Size(context.dynamicWidth(0.5), context.dynamicHeight(0.2)),
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
          side: BorderSide.none),
      child: Icon(
        ImageConstants.instance.plusIcon,
        size: 50,
        color: context.colorScheme.secondary,
      ),
    );
  }

  ElevatedButton decreaseButtton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // _animationController.forward(from: 0);

        widget.model.counterTotal -= widget.model.counterRatio;
        context.read<CounterCubit>().insertActionUpdateModel(
            CounterActionModel(
                counterId: widget.model.id!,
                isPositive: 0,
                actionTotal: widget.model.counterTotal,
                actionAmount: widget.model.counterRatio),
            widget.model);
      },
      style: ElevatedButton.styleFrom(
          onPrimary: Colors.transparent,
          fixedSize: Size(context.dynamicWidth(0.5), context.dynamicHeight(0.2)),
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
          side: BorderSide.none),
      child: Icon(
        ImageConstants.instance.minusIcon,
        size: 50,
        color: context.colorScheme.secondary,
      ),
    );
  }

  dynamic alertDialog(BuildContext context) {
    //?
    CoolAlert.show(
      onConfirmBtnTap: () async {
        double ratio = double.tryParse(_countRatioController.text) ?? 1;
        if (ratio == 0) {
          ratio = 1;
        }
        final updateModel = CounterModel(
          id: widget.model.id,
          title: _titleController.text,
          description: _descriptionController.text,
          counterTotal: double.tryParse(_countTotalController.text) ?? 0,
          counterRatio: ratio,
        );

        Navigator.of(context).pop();
        Navigator.of(context).pop();
        await context.read<CounterCubit>().updateCounter(updateModel.id!, updateModel);
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
      title: LocaleKeys.counter_save_alertDialog_questionText.locale,
      confirmBtnText: LocaleKeys.counter_save_alertDialog_confirmBtnText.locale,
      cancelBtnText: LocaleKeys.counter_save_alertDialog_cancelBtnText.locale,
      cancelBtnTextStyle: context.textTheme.bodyText1,
      confirmBtnTextStyle: context.textTheme.bodyText1,
      confirmBtnColor: context.colorScheme.primary,
      borderRadius: 0,
      backgroundColor: context.colorScheme.primary,
    );
  }
}
