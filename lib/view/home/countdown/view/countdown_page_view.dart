import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../api/notification/view/notification_view.dart';
import '../../../../product/widget/alertDialog/cool_alert_dialog.dart';
import 'components/duration_buttons.dart';
import '../../../../product/widget/appbar/edit_appbar.dart';

import '../../../../core/constants/app/app_constants.dart';
import '../../../../core/constants/image/image_constatns.dart';
import '../../../../core/extension/context_extension.dart';
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

  late DateTime _date;

  bool isChange = false;
  bool onEdit = false;

  ValueChanged<bool> onValueChange = (value) {
    value = false;
  };

  late ValueChanged<DateTime> onDateChange;

  @override
  void initState() {
    _date = DateTime.parse(widget.model.goalDate);
    _titleController = TextEditingController(text: widget.model.title);
    _descriptionController = TextEditingController(text: widget.model.description);
    onValueChange = (value) {
      setState(() {
        isChange = value;
      });
    };
    onDateChange = (value) {
      setState(() {
        _date = value;
      });
    };
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
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
        appBar: _appBar(context),
        body: _body(context),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return EditAppBar(
      context: context,
      title: widget.model.title,
      onEdit: onEdit,
      editTitle: LocaleKeys.countdown_page_appBarEdit.locale,
      saveTitle: LocaleKeys.countdown_page_appBarSave.locale,
      onPressed: () async {
        if (!onEdit) {
          setState(() {
            onEdit = true;
          });
          return;
        }
        onEdit = false;
        final updatedModel = CountdownModel(
            id: widget.model.id,
            title: _titleController.text,
            description: _descriptionController.text,
            goalDate: _date.toString());
        widget.model.title = updatedModel.title;
        await context.read<CountdownCubit>().updateCountdown(updatedModel);
        setState(() {});
      },
    );
  }

  Column _body(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (onEdit) const Spacer(),
        Flexible(
          flex: 24,
          child: Column(
            children: [
              if (_titleController.text.isNotEmpty || onEdit) Flexible(flex: 4, child: _titleForm),
              Flexible(flex: 2, child: _dateText),
              if (onEdit) const Spacer(),
              if (_descriptionController.text.isNotEmpty || onEdit)
                Flexible(flex: 8, child: _descriptionForm),
              Expanded(
                flex: 14,
                child: NotificationPage(
                  model: widget.model,
                  goaldate: _date,
                ),
              )
            ],
          ),
        ),
        Flexible(
          flex: 15,
          child: Padding(
            padding: EdgeInsets.only(top: context.lowValueH),
            child: DurationButtons(
              model: widget.model,
              onEdit: onEdit,
              onValueChange: onValueChange,
              onDateChange: onDateChange,
            ),
          ),
        ),
      ],
    );
  }

  Widget get _titleForm {
    return Padding(
      padding: EdgeInsets.only(left: context.mediumValueW, right: context.mediumValueW),
      child: TextField(
        onChanged: (_) {
          isChange = true;
        },
        enabled: onEdit,
        controller: _titleController,
        inputFormatters: [
          LengthLimitingTextInputFormatter(AppConstants.TITLE_CARACTER_LIMIT),
        ],
        decoration: InputDecoration(
          labelText: LocaleKeys.counter_formTitle.locale,
        ),
      ),
    );
  }

  Container get _dateText {
    return Container(
      padding: EdgeInsets.only(left: context.mediumValueW, top: context.lowValueH),
      alignment: Alignment.centerLeft,
      child: AutoSizeText(
        '${_date.day.timeString}.${_date.month.timeString}.${_date.year}',
        style: context.textTheme.headline6,
      ),
    );
  }

  Widget get _descriptionForm {
    return Padding(
      padding: EdgeInsets.only(left: context.mediumValueW, right: context.mediumValueW),
      child: TextField(
        onChanged: (_) {
          isChange = true;
        },
        enabled: onEdit,
        controller: _descriptionController,
        decoration: InputDecoration(
          labelText: LocaleKeys.countdown_formDescription.locale,
        ),
        maxLines: AppConstants.DESCRIPTION_LINE_LIMIT,
        minLines: AppConstants.DESCRIPTION_LINE_MIN,
      ),
    );
  }

  dynamic _alertDialog(BuildContext context) {
    CoolAlertDialog(
      context: context,
      title: LocaleKeys.countdown_save_alertDialog_questionText.locale,
      confirmBtnText: LocaleKeys.countdown_save_alertDialog_confirmBtnText.locale,
      cancelBtnText: LocaleKeys.countdown_save_alertDialog_cancelBtnText.locale,
      lottieAssetLight: ImageConstants.instance.shieldLightLoti,
      lottieAssetDark: ImageConstants.instance.shieldDarkLoti,
      onConfirmBtnTap: () async {
        final updatedModel = CountdownModel(
            id: widget.model.id,
            title: _titleController.text,
            description: _descriptionController.text,
            goalDate: _date.toString());

        Navigator.of(context).pop();
        Navigator.of(context).pop();
        await context.read<CountdownCubit>().updateCountdown(updatedModel);
      },
      onCancelBtnTap: () async {
        context.navigation.pop();
        context.navigation.pop();
      },
    );
  }
}
