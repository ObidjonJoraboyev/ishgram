import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/notification/notification_bloc.dart';
import 'package:ish_top/blocs/notification/notification_event.dart';
import 'package:ish_top/blocs/notification/notification_state.dart';
import 'package:ish_top/data/models/notification_model.dart';
import 'package:ish_top/ui/admins_panel/tab/announ/widgets/zoom_tap.dart';
import 'package:ish_top/ui/tab/announ/notification/notification_detail.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:timeago/timeago.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    context
        .read<NotificationBloc>()
        .add(NotificationGetEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationBloc, NotificationState>(
      listener: (context, state) {},
      builder: (context, state) {
        List<NotificationModel> notifs = state.notifications
            .where((v) =>
                v.userToDoc == context.read<AuthBloc>().state.userModel.docId)
            .toList();

        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: CupertinoColors.systemGrey5,
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    context.read<NotificationBloc>().add(
                        NotificationReadAllEvent(
                            uuId:
                                context.read<AuthBloc>().state.userModel.docId,
                            context: context));
                  },
                  icon: const Icon(Icons.done_all))
            ],
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: Size(
                MediaQuery.sizeOf(context).width,
                0.6.h,
              ),
              child: Container(
                height: 0.6.h,
                width: double.infinity,
                color: CupertinoColors.systemGrey,
              ),
            ),
            scrolledUnderElevation: 0,
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            backgroundColor: Colors.white.withOpacity(.8),
            title: Text(
              "notifications".tr(),
            ),
          ),
          body: state.status == StatusOfNotif.success
              ? ListView(
                  children: [
                    ...List.generate(notifs.length, (index) {
                      return ScaleOnPress(
                        scaleValue: 0.99,
                        onTap: () {
                          if (notifs[index].type ==
                                  NotificationType.activated &&
                              notifs[index].isRead == false) {
                            context.read<NotificationBloc>().add(
                                  NotificationUpdateEvent(
                                    notificationModel:
                                        notifs[index].copyWith(isRead: true),
                                  ),
                                );
                          }
                          if (notifs[index].type == NotificationType.rejected) {
                            context.read<NotificationBloc>().add(
                                  NotificationUpdateEvent(
                                    notificationModel:
                                        notifs[index].copyWith(isRead: true),
                                  ),
                                );
                            setState(() {});
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NotificationDetailScreen(
                                  notificationModel: notifs[index],
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              right: 14.w, top: 14.h, bottom: 14.h, left: 14.w),
                          margin: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                              color: CupertinoColors.systemGrey3,
                              borderRadius: BorderRadius.circular(12.r)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  notifs[index].isRead
                                      ? const SizedBox()
                                      : Container(
                                          margin: EdgeInsets.only(
                                            right: 5.w,
                                          ),
                                          width: 8.sp,
                                          height: 8.sp,
                                          decoration: const BoxDecoration(
                                              color: CupertinoColors.activeBlue,
                                              shape: BoxShape.circle),
                                        ),
                                  Text(
                                    notifs[index].title,
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              5.getH(),
                              Text(
                                notifs[index].subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp),
                              ),
                              10.getH(),
                              Text(
                                format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                      notifs[index].dateTime,
                                    ),
                                    locale: "uz"),
                                style: TextStyle(
                                    color:
                                        CupertinoColors.black.withOpacity(.6),
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                  ],
                )
              : state.status == StatusOfNotif.loading
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : const Center(
                      child: Text("Error"),
                    ),
        );
      },
    );
  }
}
