import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/components/text/auto_locale_text.dart';

import '../../../view/components/custom_rect_tween.dart';
import '../../../view/home/counter/cubit/counter_cubit.dart';
import '../../../view/home/counter/model/counter_model.dart';
import '../../../core/constants/app/app_constants.dart';
import '../../../core/extension/context_extension.dart';
import '../../../core/extension/string_extension.dart';
import '../../../core/init/lang/locale_keys.g.dart';

class CounterPopup extends StatelessWidget {
  CounterPopup({Key? key, required this.heroAddTodo}) : super(key: key);

  final String heroAddTodo;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _countTotalController = TextEditingController(text: '0');
  final TextEditingController _countRatioController = TextEditingController(text: '1');

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
          child: _popupBody(context),
        ),
      ),
    );
  }

  Material _popupBody(BuildContext context) {
    return Material(
      color: context.colorScheme.primary,
      elevation: 2,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: context.normalValueH, horizontal: context.mediumValueW),
          child: Column(
            children: [
              _titleForm(context),
              _descriptionForm(context),
              _countStartingForm(context),
              _countRatioForm(context),
              Divider(
                color: context.colorScheme.secondary,
                thickness: 0.2,
              ),
              _insertButton
            ],
          ),
        ),
      ),
    );
  }

  Padding _titleForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.lowValueH),
      child: TextField(
        controller: _titleController,
        inputFormatters: [
          LengthLimitingTextInputFormatter(
            AppConstants.TITLE_CARACTER_LIMIT,
          ), //Caracter limit for popup
        ],
        decoration: InputDecoration(
          labelText: LocaleKeys.counter_formTitle.locale,
          contentPadding: EdgeInsets.only(left: context.mediumValueW, top: context.mediumValueH),
        ),
      ),
    );
  }

  Padding _descriptionForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.lowValueH),
      child: TextField(
        controller: _descriptionController,
        decoration: InputDecoration(
          labelText: LocaleKeys.counter_formDescription.locale,
          contentPadding: EdgeInsets.only(left: context.mediumValueW, top: context.mediumValueH),
        ),
        minLines: 2,
        maxLines: AppConstants.DESCRIPTION_LINE_LIMIT,
      ),
    );
  }

  Padding _countStartingForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.lowValueH),
      child: TextFormField(
        controller: _countTotalController,
        validator: (value) => (value ?? '').isNotEmpty ? value : value = '0',
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(
            AppConstants.NUMBER_CARACTER_LIMIT,
          ),
          FilteringTextInputFormatter.allow(
            RegExp(
              AppConstants.NUMBER_REGIEX,
            ),
          ),
        ],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: LocaleKeys.counter_pupup_startingAmount.tr(),
          contentPadding: EdgeInsets.only(left: context.mediumValueW, top: context.mediumValueH),
        ),
      ),
    );
  }

  Padding _countRatioForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.lowValueH),
      child: TextFormField(
        controller: _countRatioController,
        validator: (value) => (value ?? '').isNotEmpty ? value : value = '0',
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(
            AppConstants.RATIO_CARACTER_LIMIT,
          ),
          FilteringTextInputFormatter.allow(
            RegExp(
              AppConstants.NUMBER_REGIEX,
            ),
          ),
        ],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: LocaleKeys.counter_pupup_formRatio.locale,
          contentPadding: EdgeInsets.only(left: context.mediumValueW, top: context.mediumValueH),
        ),
      ),
    );
  }

  BlocBuilder<CounterCubit, CounterState> get _insertButton {
    return BlocBuilder<CounterCubit, CounterState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () async {
            final model = CounterModel(
                title: _titleController.text,
                description: _descriptionController.text,
                counterTotal: double.parse(_countTotalController.text),
                counterRatio: double.parse(_countRatioController.text));
            await context.read<CounterCubit>().insertCounter(model);
            context.navigation.pop();
          },
          child: const AutoLocaleText(value: LocaleKeys.counter_pupup_add),
        );
      },
    );
  }
}
