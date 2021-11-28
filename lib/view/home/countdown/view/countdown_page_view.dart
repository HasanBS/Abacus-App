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
import 'package:sizer/sizer.dart';

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

  // ignore: prefer_function_declarations_over_variables
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
        await context.read<CountdownCubit>().updateCountdown(updatedModel.id!, updatedModel);
        setState(() {});
      },
    );
  }

  Column body(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            SizedBox(
              height: 10.h,
              child: _titleForm,
            ),
            SizedBox(
              height: 5.h,
              child: _dateText,
            ),
            SizedBox(
              height: 15.h,
              child: _descriptionForm,
            ),
            if (_date.isAfter(DateTime.now()))
              SizedBox(
                height: 26.h,
                child: NotificationView(model: widget.model),
              ),
          ],
        ),
        SizedBox(
          height: 26.h,
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
    return _titleController.text == "" && !onEdit
        ? Container()
        : Padding(
            padding: EdgeInsets.only(left: context.mediumValueW, right: context.mediumValueW),
            child: TextField(
              onChanged: (_) {
                isChange = true;
              },
              enabled: onEdit,
              controller: _titleController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(
                    AppConstants.TITLE_CARACTER_LIMIT), //Caracter limit for popup
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
        style: context.textTheme.headline6, //headline6
      ),
    );
  }

  Widget get _descriptionForm {
    return _descriptionController.text == '' && !onEdit
        ? Container()
        : Padding(
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
              minLines: 2,
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
        await context.read<CountdownCubit>().updateCountdown(updatedModel.id!, updatedModel);
      },
      onCancelBtnTap: () async {
        context.navigation.pop();
        context.navigation.pop();
      },
    );
  }
}


  // Column body(BuildContext context) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Column(
  //         children: [
  //           Flexible(
  //             flex: 0,
  //             fit: FlexFit.tight,
  //             child: _titleForm,
  //           ),
  //           Flexible(
  //             fit: FlexFit.tight,
  //             flex: 0,
  //             child: _dateText,
  //           ),
  //           Flexible(
  //             flex: 0,
  //             fit: FlexFit.tight,
  //             child: _descriptionForm,
  //           ),
  //           if (_date.isAfter(DateTime.now()))
  //             Flexible(
  //               flex: 0,
  //               fit: FlexFit.tight,
  //               child: NotificationView(model: widget.model),
  //             ),
  //         ],
  //       ),
  //       Padding(
  //         padding: EdgeInsets.only(top: context.mediumValueH),
  //         child: DurationButtons(
  //           model: widget.model,
  //           onEdit: onEdit,
  //           onValueChange: onValueChange,
  //           onDateChange: onDateChange,
  //         ),
  //       ),
  //     ],
  //   );
  // }