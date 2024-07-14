import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/auth/auth_event.dart';
import 'package:ish_top/blocs/auth/auth_state.dart';
import 'package:ish_top/ui/tab/profile/my_announs/my_announcements.dart';
import 'package:ish_top/ui/tab/profile/my_profile/my_profile_screen.dart';
import 'package:ish_top/ui/tab/profile/widgets/list_tile_item.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:ish_top/utils/utility_functions.dart';
import 'package:shimmer/shimmer.dart';

import '../../../data/forms/form_status.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.context});

  final BuildContext context;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final ImagePicker picker = ImagePicker();
  String imageUrl = "";
  String storagePath = "";
  String fcm = "";

  Future<void> init() async {
    setState(() {});
  }

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    context.read<AuthBloc>().add(GetCurrentUser());
    init();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateProgress(double progress) {
    _controller.animateTo(progress);
  }

  void resetAnimation() async {
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      home: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state1) {
          if (state1.formStatus == FormStatus.uploadingImage) {
            _updateProgress(state1.progress);
          }
          if (state1.formStatus == FormStatus.successImage) {
            resetAnimation();
          }
        },
        builder: (context, state1) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: CupertinoColors.systemGrey5,
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  flexibleSpace: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        color: Colors.transparent,
                        child: FlexibleSpaceBar(
                          centerTitle: true,
                          background: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).padding.top,
                              ),
                              Stack(
                                children: [
                                  SizedBox(
                                    height: 90.sp,
                                    width: 90.sp,
                                    child: GestureDetector(
                                      onTap: () async {
                                        state1.userModel.image.isEmpty
                                            ? takeAnImage(
                                                context,
                                                limit: 1,
                                                images: [],
                                                isProfile: true,
                                              )
                                            : showImageViewer(
                                                doubleTapZoomable: true,
                                                swipeDismissible: true,
                                                context,
                                                NetworkImage(
                                                    state1.userModel.image),
                                              );
                                        setState(() {});
                                      },
                                      child: state1.userModel.image.isEmpty
                                          ? Container(
                                              width: 90.sp,
                                              height: 90.sp,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Color(
                                                      int.tryParse(
                                                                  state1.userModel
                                                                      .color) !=
                                                              null
                                                          ? int.parse(state1
                                                              .userModel.color)
                                                          : CupertinoColors
                                                              .activeBlue.value,
                                                    ).withOpacity(.6),
                                                    Color(
                                                      int.tryParse(
                                                                  state1.userModel
                                                                      .color) !=
                                                              null
                                                          ? int.parse(state1
                                                              .userModel.color)
                                                          : CupertinoColors
                                                              .activeBlue.value,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              child: state1
                                                      .userModel.name.isNotEmpty
                                                  ? Center(
                                                      child: Text(
                                                        state1.userModel.name[0]
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 36.sp,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                            )
                                          : Padding(
                                              padding: EdgeInsets.zero,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      state1.userModel.image,
                                                  height: 80.w,
                                                  width: 80.w,
                                                  fit: BoxFit.cover,
                                                  placeholder: (b, w) {
                                                    return Shimmer.fromColors(
                                                      baseColor: Colors.white,
                                                      highlightColor: Colors
                                                          .grey
                                                          .withOpacity(.3),
                                                      child: Container(
                                                        height: 80.h,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                  if (state1.formStatus ==
                                      FormStatus.uploadingImage)
                                    Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        top: 0,
                                        child: AnimatedBuilder(
                                          animation: _controller,
                                          builder: (context, child) {
                                            return CircularProgressIndicator(
                                              strokeWidth: 4.sp,
                                              value: _animation.value,
                                              strokeCap: StrokeCap.round,
                                              color:
                                                  CupertinoColors.activeGreen,
                                            );
                                          },
                                        )),
                                ],
                              ),
                              10.getH(),
                              Text(
                                state1.userModel.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  primary: true,
                  pinned: true,
                  snap: true,
                  stretch: true,
                  expandedHeight: 150.h,
                  scrolledUnderElevation: 0,
                  floating: true,
                  leading: IconButton(
                    style: IconButton.styleFrom(foregroundColor: Colors.white),
                    onPressed: () {
                    },
                    icon: Icon(
                      CupertinoIcons.qrcode,
                      color: CupertinoColors.activeBlue,
                      size: 20.sp,
                    ),
                  ),
                  backgroundColor: CupertinoColors.systemGrey5.withOpacity(.1),
                  actions: [
                    TextButton(
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.white),
                      child: const Text(
                        "Edit",
                        style: TextStyle(
                            color: CupertinoColors.activeBlue,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                      onPressed: () {
                        context.read<AuthBloc>().add(GetCurrentUser());
                        setState(() {});
                      },
                    )
                  ],
                ),
                SliverList.list(
                  children: [
                    Center(
                      child: SelectableText(
                        cursorColor: CupertinoColors.activeBlue,
                        showCursor: false,
                        onTap: () {
                          Clipboard.setData(
                              ClipboardData(text: state1.userModel.phone));
                          Fluttertoast.showToast(
                              backgroundColor: CupertinoColors.systemGrey,
                              gravity: ToastGravity.BOTTOM,
                              msg: "copy".tr());
                        },
                        state1.userModel.phone,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: Colors.black.withOpacity(.4),
                        ),
                      ),
                    ),
                    ListTileItem(
                      voidCallback: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (context) {
                            return CupertinoActionSheet(
                              cancelButton: CupertinoActionSheetAction(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: CupertinoColors.activeBlue),
                                ),
                              ),
                              actions: [
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    takeAnImage(context,
                                        limit: 1, images: [], isProfile: true);
                                  },
                                  child: const Text(
                                    "Set new image",
                                    style: TextStyle(
                                        color: CupertinoColors.activeBlue,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                state1.userModel.image.length > 20
                                    ? CupertinoActionSheetAction(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(
                                            color:
                                                CupertinoColors.destructiveRed,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            );
                          },
                        );
                      },
                      title: "Change Profile Photo",
                      icon: const Icon(
                        CupertinoIcons.camera,
                        color: CupertinoColors.activeBlue,
                      ),
                      color: CupertinoColors.white,
                      isPhoto: true,
                    ),
                    ListTileItem(
                        voidCallback: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MyProfileScreen()));
                        },
                        title: "my_profile".tr(),
                        icon: const Icon(
                          CupertinoIcons.profile_circled,
                          color: Colors.white,
                        ),
                        color: CupertinoColors.destructiveRed),
                    ListTileItem(
                      isSwitch: true,
                      voidCallback: () {},
                      title: "hidden_acc".tr(),
                      icon: const Icon(
                        Icons.visibility,
                        color: Colors.white,
                      ),
                      color: CupertinoColors.systemOrange,
                    ),
                    ListTileItem(
                      voidCallback: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyAnnouncements()));
                      },
                      title: "my_announcements".tr(),
                      icon: const Icon(
                        CupertinoIcons.list_bullet_indent,
                        color: Colors.white,
                      ),
                      color: CupertinoColors.systemOrange,
                    ),
                    ListTileItem(
                        voidCallback: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (context) {
                              return CupertinoActionSheet(
                                cancelButton: CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "cancel".tr(),
                                    style: TextStyle(
                                        color: CupertinoColors.activeBlue,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                actions: [
                                  CupertinoActionSheetAction(
                                    onPressed: () async {
                                      await context
                                          .setLocale(const Locale("uz", "UZ"));
                                      if (!context.mounted) return;
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "uz".tr(),
                                      style: TextStyle(
                                          color: CupertinoColors.activeBlue,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15.sp),
                                    ),
                                  ),
                                  CupertinoActionSheetAction(
                                    onPressed: () async {
                                      await context
                                          .setLocale(const Locale("ru", "RU"));
                                      if (!context.mounted) return;
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "ru".tr(),
                                      style: TextStyle(
                                          color: CupertinoColors.activeBlue,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15.sp),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        title: "language".tr(),
                        icon: const Icon(
                          Icons.language,
                          color: CupertinoColors.white,
                        ),
                        color: CupertinoColors.activeBlue),
                    ListTileItem(
                        voidCallback: () {
                          context
                              .read<AuthBloc>()
                              .add(LogOutEvent(context: widget.context));
                        },
                        title: "log_out".tr(),
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        color: CupertinoColors.destructiveRed),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
