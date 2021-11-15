import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/components/text/auto_locale_text.dart';
import '../../../../../core/constants/app/app_constants.dart';
import '../../../../../core/extension/context_extension.dart';
import '../../../../../core/extension/string_extension.dart';
import '../../../../../core/init/lang/locale_keys.g.dart';
import '../../cubit/counter_cubit.dart';
import '../../model/counter_model.dart';

class CounterForms extends StatefulWidget {
  final CounterModel model;
  final ValueChanged<bool> onValueChange;
  final bool onEdit;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController countTotalController;
  final TextEditingController countRatioController;
  const CounterForms({
    Key? key,
    required this.model,
    required this.onValueChange,
    required this.onEdit,
    required this.titleController,
    required this.descriptionController,
    required this.countTotalController,
    required this.countRatioController,
  }) : super(key: key);

  @override
  _CounterFormsState createState() => _CounterFormsState();
}

class _CounterFormsState extends State<CounterForms> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.dynamicHeight(0.62),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              titleForm,
              descriptionForm,
            ],
          ),
          countTotalForm,
          Column(
            children: [
              AutoLocaleText(
                value: LocaleKeys.counter_page_ratio,
                style: context.textTheme.subtitle2,
              ),
              countRatioForm,
            ],
          ),
        ],
      ),
    );
  }

  Widget get titleForm {
    return widget.titleController.text == "" && !widget.onEdit
        ? Container()
        : Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.mediumValueW,
              vertical: context.lowValueH,
            ),
            child: TextField(
              onChanged: (_) {
                widget.onValueChange(true);
              },
              style: context.textTheme.headline4,
              enabled: widget.onEdit,
              controller: widget.titleController,
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
    return widget.descriptionController.text == "" && !widget.onEdit
        ? Container()
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: context.normalValueH),
            child: TextField(
              onChanged: (_) {
                widget.onValueChange(true);
              },
              enabled: widget.onEdit,
              controller: widget.descriptionController,
              decoration: InputDecoration(
                disabledBorder: InputBorder.none,
                labelText: LocaleKeys.counter_formDescription.locale,
              ),
              maxLines: AppConstants.DESCRIPTION_LINE_LIMIT,
              minLines: 2,
            ),
          );
  }

  BlocListener get countTotalForm {
    return BlocListener<CounterCubit, CounterState>(
      listener: (context, state) {
        if (state is CounterListLoadSuccess) {
          final updated =
              state.counterList.where((element) => element!.id == widget.model.id!).first!;

          widget.countTotalController.text = context.doubleToString(updated.counterTotal);
          widget.countRatioController.text = context.doubleToString(updated.counterRatio);

          setState(() {
            widget.model.title = updated.title;
            widget.model.description = updated.description;
            widget.model.counterTotal = updated.counterTotal;
            widget.model.counterRatio = updated.counterRatio;
          });
        }
      },
      child: widget.onEdit
          ? TextField(
              onChanged: (_) {
                widget.onValueChange(true);
              },
              textAlign: TextAlign.center,
              style: context.textTheme.headline1!.copyWith(
                fontSize: (500 / widget.countTotalController.text.length).sp >
                        context.textTheme.headline1!.fontSize!
                    ? context.textTheme.headline1!.fontSize
                    : (500 / widget.countTotalController.text.length).sp,
              ),
              controller: widget.countTotalController,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(
                  AppConstants.NUMBER_CARACTER_LIMIT,
                ),
                FilteringTextInputFormatter.allow(
                    RegExp(AppConstants.NUMBER_REGIEX)), //r'[\d+\-\.]'
              ],
              keyboardType: TextInputType.number,
              enabled: widget.onEdit,
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
          widget.onValueChange(true);
        },
        style: context.textTheme.subtitle2,
        textAlign: TextAlign.center,
        enabled: widget.onEdit,
        controller: widget.countRatioController,
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
}
