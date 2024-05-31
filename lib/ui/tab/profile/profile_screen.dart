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
import 'package:ish_top/blocs/user_image/user_image_event.dart';
import 'package:ish_top/blocs/user_image/user_image_state.dart';
import 'package:ish_top/ui/tab/profile/widgets/list_tile_item.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:ish_top/utils/utility_functions.dart';
import '../../../blocs/auth/auth_state.dart';
import '../../../blocs/image/formstatus.dart';
import '../../../blocs/user_image/user_image_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.context});

  final BuildContext context;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                context.read<AuthBloc>().add(RegisterUpdateEvent(
                    userModel:
                        state1.userModel.copyWith(image: state.images.imageUrl),
                    docId: ""));
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
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 24),
                              ),
                              background: Column(
                                children: [
                                  50.getH(),
                                  SizedBox(
                                    height: 90.w,
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
                                              height: 90.w,
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
                                  const SizedBox(
                                    height: 15,
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
                        style:
                            IconButton.styleFrom(foregroundColor: Colors.white),
                        onPressed: () {},
                        icon: const Icon(
                          CupertinoIcons.qrcode,
                          color: CupertinoColors.activeBlue,
                          size: 28,
                        ),
                      ),
                      backgroundColor:
                          CupertinoColors.systemGrey5.withOpacity(.1),
                      actions: [
                        TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white),
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
                              fontSize: 18,
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
                                                    RegisterUpdateEvent(
                                                        userModel: state1
                                                            .userModel
                                                            .copyWith(
                                                                image: ""),
                                                        docId: ""),
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
                          icon: Icon(
                            CupertinoIcons.camera,
                            color: CupertinoColors.activeBlue,
                          ),
                          color: CupertinoColors.white,
                          isPhoto: true,
                        ),
                        ListTileItem(
                            voidCallback: () {
                              context
                                  .read<AuthBloc>()
                                  .add(LogOutEvent(context: widget.context));
                            },
                            title: "My Profile",
                            icon: const Icon(
                              CupertinoIcons.profile_circled,
                              color: Colors.white,
                            ),
                            color: CupertinoColors.destructiveRed),
                        ListTileItem(
                            voidCallback: () {
                              context
                                  .read<AuthBloc>()
                                  .add(LogOutEvent(context: widget.context));
                            },
                            title: "Log Out",
                            icon: const Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                            color: CupertinoColors.destructiveRed),
                        ListTileItem(
                          isSwitch: true,
                          voidCallback: () {},
                          title: "Boshqalarga sizni ko'rsatish",
                          icon: const Icon(
                            Icons.visibility,
                            color: Colors.white,
                          ),
                          color: Colors.red,
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
