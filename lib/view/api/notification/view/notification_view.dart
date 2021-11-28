import 'package:auto_size_text/auto_size_text.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/extension/duration_extension.dart';
import '../../../../core/init/lang/locale_keys.g.dart';
import '../../../../product/widget/divider/custom_divider.dart';
import '../cubit/notification_cubit.dart';
import '../../../home/countdown/model/countdown_model.dart';
import '../../../../core/extension/context_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

import '/core/extension/string_extension.dart';

class NotificationView extends StatelessWidget {
  final CountdownModel model;
  const NotificationView({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationCubit()..emit(NotificationInitial()),
      child: NotificationButtons(model: model),
    );
  }
}

class NotificationButtons extends StatelessWidget {
  const NotificationButtons({Key? key, required this.model}) : super(key: key);

  final CountdownModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 6.h,
          child: ElevatedButton(
            onPressed: context.watch<NotificationCubit>().notificationLengt() < 3
                ? () {
                    _openNotificationPicker(context, (index) async {
                      final newTime = index as DateTime;
                      await context.read<NotificationCubit>().insertNotification(
                          model.id!,
                          LocaleKeys.countdown_notification_reminderTitle.tr(args: [(model.title)]),
                          newTime.stringDate,
                          newTime);
                    });
                  }
                : () {},
            style: ElevatedButton.styleFrom(
              side: BorderSide.none,
              primary: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: SizedBox(
              width: context.dynamicWidth(0.9),
              child: AutoSizeText(
                context.watch<NotificationCubit>().notificationLengt() >= 3
                    ? LocaleKeys.countdown_notification_maxReminder.locale
                    : LocaleKeys.countdown_notification_addReminder.locale,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        CustomDivider(context),
        SizedBox(
          height: 17.h,
          child: BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              context.watch<NotificationCubit>().getNotifications(model.id!);

              if (state is NotificationLoadSucces) {
                return ListView.builder(
                    //physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.notificationList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _openNotificationPicker(
                                context,
                                (date) async {
                                  final newTime = date as DateTime;
                                  final temp = state.notificationList[index]!;
                                  await context.read<NotificationCubit>().updateNotification(
                                      temp.id, temp.title!, temp.body!, newTime);
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              side: BorderSide.none,
                              primary: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            child: AutoSizeText(state.notificationList[index]!.payload!),
                          ),
                          IconButton(
                              onPressed: () {
                                context
                                    .read<NotificationCubit>()
                                    .cancelNotification(state.notificationList[index]!.id);
                              },
                              icon: const Icon(Icons.cancel_outlined))
                        ],
                      );
                    });
              } else {
                return Container();
              }
            },
          ),
        ),
      ],
    );
  }

  dynamic _openNotificationPicker(
    BuildContext context,
    Function(dynamic)? onSubmit,
  ) {
    BottomPicker.dateTime(
      title: LocaleKeys.countdown_notification_reminderDate.locale,
      onSubmit: onSubmit,
      minDateTime: DateTime.now(),
      maxDateTime: DateTime.parse(model.goalDate),
      initialDateTime: DateTime.parse(model.goalDate),
      textStyle: context.textTheme.headline6!, //headline 6
      backgroundColor: context.colorScheme.primary,
      buttonColor: context.colorScheme.secondary,
      iconColor: context.colorScheme.primary,
      titleStyle: context.textTheme.headline6!,
      dismissable: true,
      use24hFormat: true,
    ).show(context);
  }
}
