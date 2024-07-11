import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/announ_bloc/announ_bloc.dart';
import 'package:ish_top/blocs/announ_bloc/announ_event.dart';
import 'package:ish_top/blocs/announ_bloc/announ_state.dart';
import 'package:ish_top/blocs/notification/notification_bloc.dart';
import 'package:ish_top/blocs/notification/notification_event.dart';
import 'package:ish_top/data/local/local_storage.dart';
import 'package:ish_top/data/models/announ_model.dart';
import 'package:ish_top/data/models/notification_model.dart';
import 'package:ish_top/ui/admins_panel/tab/announ/comment_screen/comment_screen.dart';
import 'package:ish_top/ui/admins_panel/tab/announ/detail/detail_screen.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'zoom_tap.dart';

class AdminHiringItem extends StatefulWidget {
  const AdminHiringItem({
    super.key,
    required this.hires,
    required this.voidCallback,
    required this.scrollController,
    required this.context1,
  });

  final AnnounModel hires;
  final ScrollController scrollController;
  final VoidCallback voidCallback;
  final BuildContext context1;

  @override
  State<AdminHiringItem> createState() => _AdminHiringItemState();
}

class _AdminHiringItemState extends State<AdminHiringItem> {
  String userNum = StorageRepository.getString(key: "userNumber");

  final TextEditingController controller = TextEditingController();
  int activeIndex = 0;

  String getTime({required String time}) {
    return "${DateFormat('dd MMM HH:mm').format(
      DateTime.fromMillisecondsSinceEpoch(
        int.parse(time.split(":")[0]),
      ),
    )}  -  ${DateFormat('dd MMM HH:mm').format(
      DateTime.fromMillisecondsSinceEpoch(
        int.parse(time.split(":")[1]),
      ),
    )}";
  }

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AnnounBloc, AnnounState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          children: [
            GestureDetector(
              onTap: () async {
                Navigator.push(
                  widget.context1,
                  MaterialPageRoute(
                    builder: (c) => AdminDetailScreen(
                      hireModel: widget.hires,
                      defaultImageIndex: pageController.positions.isNotEmpty
                          ? pageController.page!.round()
                          : 0,
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(top: 20.h, left: 5.w, right: 5.w),
                padding: EdgeInsets.all(7.sp),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16.r),
                      topLeft: Radius.circular(16.r)),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 8),
                      spreadRadius: 1,
                      blurRadius: 10,
                      color: CupertinoColors.systemGrey.withOpacity(.01),
                    )
                  ],
                  color: CupertinoColors.white.withOpacity(.9),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => CupertinoAlertDialog(
                                  title: Text(
                                    "ACCEPT?",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18.sp,
                                        color: CupertinoColors.activeGreen,
                                        shadows: const [
                                          BoxShadow(
                                              color: Colors.white,
                                              blurRadius: 10,
                                              spreadRadius: 3)
                                        ]),
                                  ),
                                  content: const Column(
                                    children: [
                                      Text(
                                        "Are you sure you want to accept this announcement?",
                                        style: TextStyle(
                                            color: CupertinoColors.activeBlue,
                                            shadows: [
                                              BoxShadow(
                                                  blurRadius: 10,
                                                  color: Colors.white,
                                                  spreadRadius: 3)
                                            ]),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(
                                            color: CupertinoColors.systemBlue),
                                      ),
                                    ),
                                    CupertinoDialogAction(
                                      onPressed: () {
                                        context.read<AnnounBloc>().add(
                                              AnnounUpdateEvent(
                                                hireModel: widget.hires
                                                    .copyWith(
                                                        status: StatusAnnoun
                                                            .active),
                                              ),
                                            );
                                        context.read<NotificationBloc>().add(
                                              NotificationAddEvent(
                                                notificationModel:
                                                    NotificationModel(
                                                  subtitle:
                                                      "hiring_published".tr(),
                                                  title: "your_hires".tr(),
                                                  type: NotificationType
                                                      .activated,
                                                  docId: "",
                                                  isRead: false,
                                                  userToDoc:
                                                      widget.hires.userId,
                                                  dateTime: 0,
                                                ),
                                              ),
                                            );

                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Accept",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: CupertinoColors.activeBlue),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r))),
                            child: Text(
                              "Active",
                              style: TextStyle(
                                color: CupertinoColors.activeGreen,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        10.getW(),
                        widget.hires.status != StatusAnnoun.returned
                            ? Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: const Text("Are you sure?"),
                                            content: Column(
                                              children: [
                                                const Text(
                                                    "Are you sure you want to reject this announcement?"),
                                                CupertinoTextField(
                                                  controller: controller,
                                                  cursorColor: CupertinoColors
                                                      .destructiveRed,
                                                )
                                              ],
                                            ),
                                            actions: [
                                              CupertinoDialogAction(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      color: CupertinoColors
                                                          .systemBlue),
                                                ),
                                              ),
                                              CupertinoDialogAction(
                                                onPressed: () {
                                                  context
                                                      .read<AnnounBloc>()
                                                      .add(
                                                        AnnounUpdateEvent(
                                                          hireModel: widget
                                                              .hires
                                                              .copyWith(
                                                                  status: StatusAnnoun
                                                                      .returned),
                                                        ),
                                                      );
                                                  context
                                                      .read<NotificationBloc>()
                                                      .add(
                                                        NotificationAddEvent(
                                                          notificationModel:
                                                              NotificationModel(
                                                            subtitle:
                                                                "${"hiring_not_published".tr()}\n${controller.text}",
                                                            title: "your_hires"
                                                                .tr(),
                                                            type:
                                                                NotificationType
                                                                    .rejected,
                                                            docId: "",
                                                            isRead: false,
                                                            userToDoc: widget
                                                                .hires.userId,
                                                            dateTime: 0,
                                                          ),
                                                        ),
                                                      );

                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  "Reject",
                                                  style: TextStyle(
                                                      color: CupertinoColors
                                                          .destructiveRed,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              )
                                            ],
                                          );
                                        });
                                  },
                                  style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.r))),
                                  child: Text(
                                    "Reject",
                                    style: TextStyle(
                                        color: CupertinoColors.destructiveRed,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                    Stack(
                      children: [
                        SizedBox(
                          height: 200.h,
                          child: (widget.hires.images.isNotEmpty)
                              ? PageView(
                                  controller: pageController,
                                  onPageChanged: (index) {
                                    setState(() {
                                      activeIndex = index;
                                    });
                                  },
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    ...List.generate(
                                      widget.hires.images.length,
                                      (index) => Padding(
                                        padding: EdgeInsets.all(8.sp),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: CachedNetworkImage(
                                            placeholder: (context, st) {
                                              return Shimmer.fromColors(
                                                baseColor: Colors.white,
                                                highlightColor: Colors.grey,
                                                child: Container(
                                                  height: 80.h,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                ),
                                              );
                                            },
                                            errorWidget: (BuildContext context,
                                                String st, a) {
                                              return Shimmer.fromColors(
                                                baseColor: Colors.white,
                                                highlightColor: Colors.grey,
                                                child: Container(
                                                  height: 80.h,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                ),
                                              );
                                            },
                                            imageUrl: widget
                                                .hires.images[index].imageUrl,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Center(
                                  child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  margin: EdgeInsets.all(8.sp),
                                  decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        colors: [
                                          CupertinoColors.activeOrange,
                                          CupertinoColors.activeBlue,
                                          CupertinoColors.activeGreen,
                                        ],
                                      ),
                                      color: CupertinoColors.activeBlue,
                                      borderRadius:
                                          BorderRadius.circular(12.r)),
                                  child: Center(
                                    child: Text(
                                      "No Image",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                )),
                        ),
                        widget.hires.images.length > 1
                            ? Positioned(
                                bottom: 15.h,
                                right: 15.w,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 2.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: CupertinoColors.systemGrey6,
                                  ),
                                  child: Row(
                                    children: [
                                      ...List.generate(
                                        widget.hires.images.length,
                                        (index) {
                                          return AnimatedContainer(
                                            curve: Curves.linear,
                                            duration: const Duration(
                                                milliseconds: 200),
                                            margin: EdgeInsets.all(1.sp),
                                            width: activeIndex != index
                                                ? 6.sp
                                                : 7.sp,
                                            height: activeIndex != index
                                                ? 6.sp
                                                : 7.sp,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: activeIndex != index
                                                    ? Colors.grey
                                                    : CupertinoColors
                                                        .activeBlue),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: Text(
                        widget.hires.title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.w, top: 3.h),
                      child: Text(
                        widget.hires.money,
                        style: TextStyle(
                          fontSize: 19.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          widget.hires.viewedUsers.length.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 10.sp,
                            color: CupertinoColors.black.withOpacity(.6),
                          ),
                        ),
                        5.getW(),
                        Icon(
                          CupertinoIcons.eye_solid,
                          size: 13.sp,
                          color: CupertinoColors.black.withOpacity(.6),
                        ),
                        12.getW(),
                        Text(
                          timeago.format(
                              DateTime.fromMillisecondsSinceEpoch(
                                int.parse(widget.hires.createdAt.toString()),
                              ),
                              locale: "uz"),
                          style: TextStyle(
                              color: CupertinoColors.black.withOpacity(.6),
                              fontWeight: FontWeight.w500,
                              fontSize: 10.sp),
                        ),
                        8.getW()
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 0.h, horizontal: 5.w),
              width: double.infinity,
              height: 0.4,
              color: Colors.grey,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 0.h, horizontal: 5.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.r),
                    bottomRight: Radius.circular(16.r)),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 8),
                    spreadRadius: 1,
                    blurRadius: 10,
                    color: CupertinoColors.systemGrey.withOpacity(.01),
                  )
                ],
                color: CupertinoColors.white.withOpacity(.9),
              ),
              child: ScaleOnPress(
                onTap: () {
                  Navigator.push(
                    widget.context1,
                    CupertinoPageRoute(
                      builder: (context) => AdminCommentScreen(
                        announcementModel: widget.hires,
                      ),
                    ),
                  );
                },
                scaleValue: 0.98,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: Text(
                        "${widget.hires.comments.length}  ${widget.hires.comments.isNotEmpty ? "comments".tr() : "comment".tr()}",
                        style: TextStyle(
                            color: CupertinoColors.activeBlue,
                            fontWeight: FontWeight.w400,
                            fontSize: 18.sp),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: CupertinoColors.activeBlue,
                      weight: 1,
                    )
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
