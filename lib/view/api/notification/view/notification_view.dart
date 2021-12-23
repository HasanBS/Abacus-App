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
import '/core/extension/string_extension.dart';

class NotificationPage extends StatefulWidget {
  final CountdownModel model;
  final DateTime goaldate;
  const NotificationPage({Key? key, required this.model, required this.goaldate}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationCubit()..getNotifications(widget.model.id!),
      child: NotificationView(model: widget.model, goalDate: widget.goaldate),
    );
  }
}

class NotificationView extends StatelessWidget {
  final CountdownModel model;
  final DateTime goalDate;
  const NotificationView({Key? key, required this.model, required this.goalDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return context.watch<NotificationCubit>().isAfter(goalDate)
        ? Column(
            children: [
              Flexible(
                child: ElevatedButton(
                  onPressed: context.watch<NotificationCubit>().notificationLengt() < 3
                      ? () {
                          _openNotificationPicker(context, (index) async {
                            final newTime = index as DateTime;
                            await context.read<NotificationCubit>().insertNotification(
                                model.id!,
                                LocaleKeys.countdown_notification_reminderTitle
                                    .tr(args: [(model.title)]),
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
                    width: context.dynamicWidth(0.84),
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
              Flexible(
                flex: 3,
                child: BlocBuilder<NotificationCubit, NotificationState>(
                  builder: (context, state) {
                    context.watch<NotificationCubit>().getNotifications(model.id!);
                    if (state is NotificationLoadSucces) {
                      return ListView.builder(
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
                                  child: AutoSizeText(
                                      DateTime.parse(state.notificationList[index]!.payload!)
                                          .stringDate),
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
          )
        : const SizedBox();
  }

  dynamic _openNotificationPicker(
    BuildContext context,
    Function(dynamic)? onSubmit,
  ) {
    BottomPicker.dateTime(
      title: LocaleKeys.countdown_notification_reminderDate.locale,
      onSubmit: onSubmit,
      minDateTime: DateTime.now(),
      maxDateTime: goalDate,
      initialDateTime: goalDate,

      // textStyle: context.textTheme.headline6!, //headline 6
      // backgroundColor: context.colorScheme.primary,
      // buttonColor: context.colorScheme.secondary,
      iconColor: context.colorScheme.primary,
      titleStyle: context.textTheme.headline6!,
      dismissable: true,
      use24hFormat: true,
    ).show(context);
  }
}
