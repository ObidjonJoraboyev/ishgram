import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ish_top/blocs/announ_bloc/announ_bloc.dart';
import 'package:ish_top/blocs/announ_bloc/announ_event.dart';
import 'package:ish_top/blocs/announ_bloc/announ_state.dart';
import 'package:ish_top/blocs/user/user_bloc.dart';
import 'package:ish_top/blocs/user/user_state.dart';
import 'package:ish_top/data/forms/form_status.dart';
import 'package:ish_top/data/models/announ_model.dart';
import 'package:ish_top/data/models/user_model.dart';
import 'package:ish_top/ui/auth/widgets/button.dart';
import 'package:ish_top/ui/tab/announ/widgets/zoom_tap.dart';
import 'package:ish_top/ui/tab/profile/scan/qr_user_announs.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:ish_top/utils/utility_functions.dart';

class StartChatScreen extends StatefulWidget {
  const StartChatScreen({
    super.key,
    required this.userModel,
  });

  final UserModel userModel;

  @override
  State<StartChatScreen> createState() => _StartChatScreenState();
}

class _StartChatScreenState extends State<StartChatScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    context
        .read<AnnounBloc>()
        .add(AnnounGetQREvent(userIdQr: widget.userModel.docId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AnnounBloc, AnnounState>(
      listener: (context, state) {},
      builder: (context, announState) {
        return BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {},
          builder: (context, state) {
            return widget.userModel.name.isNotEmpty
                ? Container(
                    color: CupertinoColors.systemGrey6,
                    child: SafeArea(
                      child: PopScope(
                        canPop: state.formStatus == FormStatus.successQr,
                        child: Scaffold(
                          backgroundColor: CupertinoColors.systemGrey6,
                          body: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CupertinoButton(
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.arrow_back_ios,
                                        color: CupertinoColors.activeBlue,
                                      ),
                                      Text(
                                        "cancel".tr(),
                                        style: TextStyle(
                                            height: 0,
                                            color: CupertinoColors.activeBlue,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              Expanded(
                                child: ListView(
                                  shrinkWrap: true,
                                  controller: scrollController,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: [
                                    ScaleOnPress(
                                      onTap: () {
                                        widget.userModel.image.isNotEmpty
                                            ? showImageViewer(
                                                useSafeArea: false,
                                                backgroundColor: Colors.black,
                                                doubleTapZoomable: true,
                                                swipeDismissible: true,
                                                context,
                                                NetworkImage(
                                                    widget.userModel.image),
                                              )
                                            : null;
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          widget.userModel.image.isNotEmpty
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10000.r),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        widget.userModel.image,
                                                    width: 80.sp,
                                                    fit: BoxFit.cover,
                                                    height: 80.sp,
                                                  ),
                                                )
                                              : Container(
                                                  width: 80.sp,
                                                  height: 80.sp,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Color(
                                                          int.tryParse(widget.userModel
                                                                      .color) !=
                                                                  null
                                                              ? int.parse(widget
                                                                  .userModel
                                                                  .color)
                                                              : CupertinoColors
                                                                  .activeBlue
                                                                  .value,
                                                        ).withOpacity(.6),
                                                        Color(
                                                          int.tryParse(widget.userModel
                                                                      .color) !=
                                                                  null
                                                              ? int.parse(widget
                                                                  .userModel
                                                                  .color)
                                                              : CupertinoColors
                                                                  .activeBlue
                                                                  .value,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  child: widget.userModel.name
                                                          .isNotEmpty
                                                      ? Center(
                                                          child: Text(
                                                            returnCenterText(
                                                                widget
                                                                    .userModel),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 32.sp,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30.w),
                                      child: Column(
                                        children: [
                                          10.getH(),
                                          Text(
                                            "${widget.userModel.name} ${widget.userModel.lastName}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 21.sp,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    20.getH(),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 14.w),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        child: Column(
                                          children: [
                                            widget.userModel.username.isNotEmpty
                                                ? CupertinoListTile(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 14.w,
                                                            vertical: 10.h),
                                                    subtitle:
                                                        Text("username".tr()),
                                                    onTap: () {},
                                                    title: Text(
                                                      "@${widget.userModel.username}",
                                                      style: const TextStyle(
                                                          color: CupertinoColors
                                                              .activeBlue),
                                                    ),
                                                    backgroundColor:
                                                        Colors.white,
                                                  )
                                                : const SizedBox(),
                                            ((widget.userModel.bio.isNotEmpty ||
                                                        widget.userModel.phone
                                                            .isNotEmpty) &&
                                                    widget.userModel.username
                                                        .isNotEmpty)
                                                ? Container(
                                                    width: double.infinity,
                                                    height: 0.30,
                                                    color: Colors.black
                                                        .withOpacity(.6),
                                                  )
                                                : const SizedBox(),
                                            widget.userModel.phone.isNotEmpty
                                                ? CupertinoListTile(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 14.w,
                                                            vertical: 10.h),
                                                    subtitle: Text(
                                                        "phone_number".tr()),
                                                    onTap: () {
                                                      showCupertinoModalPopup(
                                                          context: context,
                                                          builder: (context) {
                                                            return CupertinoActionSheet(
                                                              actions: [
                                                                CupertinoActionSheetAction(
                                                                  child: Text(
                                                                      "make_call"
                                                                          .tr(),
                                                                      style: TextStyle(
                                                                          color: CupertinoColors
                                                                              .activeBlue,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              16.sp)),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    launchCaller(widget
                                                                        .userModel
                                                                        .phone);
                                                                  },
                                                                ),
                                                                CupertinoActionSheetAction(
                                                                  child: Text(
                                                                      "send_sms"
                                                                          .tr(),
                                                                      style: TextStyle(
                                                                          color: CupertinoColors
                                                                              .activeBlue,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              16.sp)),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    launchSms(widget
                                                                        .userModel
                                                                        .phone);
                                                                  },
                                                                ),
                                                                CupertinoActionSheetAction(
                                                                  child: Text(
                                                                      "to_copy"
                                                                          .tr(),
                                                                      style: TextStyle(
                                                                          color: CupertinoColors
                                                                              .activeBlue,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              16.sp)),
                                                                  onPressed:
                                                                      () {
                                                                    Clipboard.setData(ClipboardData(
                                                                        text: widget
                                                                            .userModel
                                                                            .phone));
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                "copy".tr());
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ],
                                                              cancelButton:
                                                                  CupertinoActionSheetAction(
                                                                isDestructiveAction:
                                                                    true,
                                                                isDefaultAction:
                                                                    true,
                                                                child: Text(
                                                                    "cancel"
                                                                        .tr(),
                                                                    style: TextStyle(
                                                                        color: CupertinoColors
                                                                            .activeBlue,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            16.sp)),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                            );
                                                          });
                                                    },
                                                    title: Text(
                                                        widget.userModel.phone),
                                                    backgroundColor:
                                                        Colors.white,
                                                  )
                                                : const SizedBox(),
                                            widget.userModel.bio.isNotEmpty
                                                ? Container(
                                                    width: double.infinity,
                                                    height: 0.30,
                                                    color: Colors.black
                                                        .withOpacity(.6),
                                                  )
                                                : const SizedBox(),
                                            widget.userModel.bio.isNotEmpty
                                                ? CupertinoListTile(
                                                    subtitle:
                                                        Text("about_user".tr()),
                                                    onTap: () {},
                                                    title: Text(
                                                        widget.userModel.bio),
                                                    backgroundColor:
                                                        Colors.white,
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    20.getH(),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 14.w),
                                      child: Text(
                                        "hires".tr(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 22.sp),
                                      ),
                                    ),
                                    5.getH(),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 6.w),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: CupertinoButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              announState.qrHires
                                                      .where((v) =>
                                                          v.status ==
                                                          StatusAnnoun.active)
                                                      .toList()
                                                      .isNotEmpty
                                                  ? Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const QrUserAnnounsScree(
                                                          statusAnnoun:
                                                              StatusAnnoun
                                                                  .active,
                                                        ),
                                                      ),
                                                    )
                                                  : null;
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.only(
                                                  left: 15.w,
                                                  bottom: 8.h,
                                                  top: 8.h),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 8.w),
                                              decoration: BoxDecoration(
                                                  color: CupertinoColors
                                                      .activeBlue,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  announState.status ==
                                                          FormStatus.successQr
                                                      ? Text(
                                                          announState.qrHires
                                                              .where((toElement) =>
                                                                  toElement
                                                                      .status ==
                                                                  StatusAnnoun
                                                                      .active)
                                                              .toList()
                                                              .length
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 30.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        )
                                                      : announState.status ==
                                                              FormStatus
                                                                  .loadingQrGet
                                                          ? const CircularProgressIndicator(
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          : Text(
                                                              "error".tr(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      22.sp),
                                                            ),
                                                  10.getH(),
                                                  Text(
                                                    "Active",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.sp,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )),
                                          Expanded(
                                              child: CupertinoButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              announState.qrHires
                                                      .where((v) =>
                                                          v.status ==
                                                          StatusAnnoun.done)
                                                      .toList()
                                                      .isNotEmpty
                                                  ? Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const QrUserAnnounsScree(
                                                          statusAnnoun:
                                                              StatusAnnoun.done,
                                                        ),
                                                      ),
                                                    )
                                                  : null;
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.only(
                                                  left: 15.w,
                                                  bottom: 8.h,
                                                  top: 8.h),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 8.w),
                                              decoration: BoxDecoration(
                                                  color: CupertinoColors
                                                      .systemGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  announState.status ==
                                                          FormStatus.successQr
                                                      ? Text(
                                                          announState.qrHires
                                                              .where((toElement) =>
                                                                  toElement
                                                                      .status ==
                                                                  StatusAnnoun
                                                                      .done)
                                                              .toList()
                                                              .length
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 30.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        )
                                                      : announState.status ==
                                                              FormStatus
                                                                  .loadingQrGet
                                                          ? const CircularProgressIndicator(
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          : Text(
                                                              "error".tr(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      22.sp),
                                                            ),
                                                  10.getH(),
                                                  Text(
                                                    "Finished",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.sp,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              state.userModel.phone != widget.userModel.phone
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 14.w),
                                      child: LoginButtonItems(
                                        onTap: () {},
                                        isLoading: false,
                                        active: true,
                                        title: "start_chat".tr(),
                                      ),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : const Scaffold(
                    backgroundColor: CupertinoColors.systemGrey6,
                  );
          },
        );
      },
    );
  }
}
