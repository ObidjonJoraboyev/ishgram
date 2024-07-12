import 'dart:ui';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/auth/auth_event.dart';
import 'package:ish_top/blocs/auth/auth_state.dart';
import 'package:ish_top/blocs/image/formstatus.dart';
import 'package:ish_top/blocs/user_image/user_image_bloc.dart';
import 'package:ish_top/blocs/user_image/user_image_event.dart';
import 'package:ish_top/blocs/user_image/user_image_state.dart';
import 'package:ish_top/ui/admins_panel/tab/profile/my_announs/my_announcements.dart';
import 'package:ish_top/ui/admins_panel/tab/profile/my_profile/my_profile_screen.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:ish_top/utils/utility_functions.dart';

import 'widgets/list_tile_item.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key, required this.context});

  final BuildContext context;

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  final ImagePicker picker = ImagePicker();
  String imageUrl = "";
  String storagePath = "";
  String fcm = "";

  Future<void> init() async {
    setState(() {});
  }

  @override
  void initState() {
    context.read<AuthBloc>().add(GetCurrentUser());
    init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      home: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state1) {},
        builder: (context, state1) {
          return BlocConsumer<UserImageBloc, UserImageUploadState>(
            listener: (context, state) {
              if (state.formStatus == FormStatusImage.success) {
                context.read<AuthBloc>().add(UpdateUser(
                    userModel:
                        state1.userModel.copyWith(image: state.images.imageUrl),));
              }
            },
            builder: (context, state) {
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
                              title: Text(
                                state1.userModel.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.sp),
                              ),
                              background: Column(
                                children: [
                                  50.getH(),
                                  SizedBox(
                                    height: 140.h,
                                    width: 90.w,
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
                                              width: 90.w,
                                              height: 140.h,
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
                                                child: Image.network(
                                                  state1.userModel.image,
                                                  height: 80.w,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                    ),
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
                      expandedHeight: 180.h,
                      scrolledUnderElevation: 0,
                      floating: true,
                      leading: IconButton(
                        style:
                            IconButton.styleFrom(foregroundColor: Colors.white),
                        onPressed: () {},
                        icon: Icon(
                          CupertinoIcons.qrcode,
                          color: CupertinoColors.activeBlue,
                          size: 20.sp,
                        ),
                      ),
                      backgroundColor:
                          CupertinoColors.systemGrey5.withOpacity(.1),
                      actions: [
                        CupertinoButton(
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
                          child: Text(
                            state1.userModel.phone,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
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
                                        Navigator.pop(context);
                                        takeAnImage(context,
                                            limit: 1, images: []);
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
                                              context.read<UserImageBloc>().add(
                                                  UserImageRemoveEvent(context,
                                                      docId: state
                                                          .images.imageDocId));
                                              context.read<AuthBloc>().add(
                                                    UpdateUser(
                                                        userModel: state1
                                                            .userModel
                                                            .copyWith(
                                                                image: ""),),
                                                  );
                                            },
                                            child: const Text(
                                              "Delete",
                                              style: TextStyle(
                                                color: CupertinoColors
                                                    .destructiveRed,
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
                                    builder: (context) =>
                                        const MyAnnouncements()));
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
                                          await context.setLocale(
                                              const Locale("uz", "UZ"));
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
                                          await context.setLocale(
                                              const Locale("ru", "RU"));
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
          );
        },
      ),
    );
  }
}
