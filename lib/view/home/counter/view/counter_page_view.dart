import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/image/image_constatns.dart';
import '../../../../core/extension/context_extension.dart';
import '../../../../core/extension/string_extension.dart';
import '../../../../core/init/lang/locale_keys.g.dart';
import '../../../../product/widget/alertDialog/cool_alert_dialog.dart';
import '../../../../product/widget/appbar/edit_appbar.dart';
import '../cubit/counter_cubit.dart';
import '../model/counter_model.dart';
import 'components/bottom_buttons.dart';
import 'components/counter_forms.dart';

class CounterPageView extends StatefulWidget {
  final CounterModel model;
  const CounterPageView({Key? key, required this.model}) : super(key: key);

  @override
  _CounterPageViewState createState() => _CounterPageViewState();
}

class _CounterPageViewState extends State<CounterPageView> {
  bool isChange = false;
  // ignore: prefer_function_declarations_over_variables
  ValueChanged<bool> onValueChange = (value) {
    value = false;
  };
  bool onEdit = false;

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _countTotalController;
  late final TextEditingController _countRatioController;

  @override
  void initState() {
    onValueChange = (value) {
      setState(() {
        isChange = value;
      });
    };

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
          _alertDialog(context);
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
    return EditAppBar(
      context: context,
      title: widget.model.title,
      onEdit: onEdit,
      editTitle: LocaleKeys.counter_page_appBarEdit.locale,
      saveTitle: LocaleKeys.counter_page_appBarSave.locale,
      onPressed: () async {
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
    );
  }

  Column body(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CounterForms(
            model: widget.model,
            onValueChange: onValueChange,
            onEdit: onEdit,
            titleController: _titleController,
            descriptionController: _descriptionController,
            countTotalController: _countTotalController,
            countRatioController: _countRatioController),
        BottomButtons(
          model: widget.model,
        ),
      ],
    );
  }

  dynamic _alertDialog(BuildContext context) {
    CoolAlertDialog(
      context: context,
      title: LocaleKeys.counter_save_alertDialog_questionText.locale,
      confirmBtnText: LocaleKeys.counter_save_alertDialog_confirmBtnText.locale,
      cancelBtnText: LocaleKeys.counter_save_alertDialog_cancelBtnText.locale,
      lottieAssetLight: ImageConstants.instance.shieldLightLoti,
      lottieAssetDark: ImageConstants.instance.shieldDarkLoti,
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
        context.navigation.pop();
        context.navigation.pop();

        await context.read<CounterCubit>().updateCounter(updateModel.id!, updateModel);
      },
      onCancelBtnTap: () async {
        context.navigation.pop();
        context.navigation.pop();
      },
    );
  }
}
