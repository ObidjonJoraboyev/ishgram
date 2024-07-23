import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
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
import 'package:ish_top/ui/tab/profile/edit/edit_profile_screen.dart';
import 'package:ish_top/ui/tab/profile/my_announs/my_announcements.dart';
import 'package:ish_top/ui/tab/profile/my_profile/my_profile_screen.dart';
import 'package:ish_top/ui/tab/profile/scan/scanner_screen.dart';
import 'package:ish_top/ui/tab/profile/widgets/list_tile_item.dart';
import 'package:ish_top/utils/constants/app_constants.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:ish_top/utils/utility_functions.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qr_flutter/qr_flutter.dart';
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

  bool isOpen = false;
  String errorText = "";
  TextEditingController userName = TextEditingController();

  Future<void> init() async {
    setState(() {});
  }

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    context.read<AuthBloc>().add(GetCurrentUser());
    userName.text = context.read<AuthBloc>().state.userModel.username;
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

  void _onTextChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _sendRequest(query);
    });
  }

  Timer? _debounce;

  Future<void> _sendRequest(String query) async {
    try {
      await dio.get(
        "https://ishgram-production.up.railway.app/api/v1/check-username",
        queryParameters: {"username": userName.text},
      );
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  onDone() async {
    if (userName.text.isNotEmpty) {
      Response response = await dio.patch(
        "https://ishgram-production.up.railway.app/api/v1/change-username",
        queryParameters: {
          "username": userName.text,
          "user_id": context.read<AuthBloc>().state.userModel.docId
        },
      );
      if (response.statusCode == 200) {
        return;
      }
    } else {
      Response response = await dio.patch(
        "https://ishgram-production.up.railway.app/api/v1/user-remove-username/${context.read<AuthBloc>().state.userModel.docId}",
      );
      if (response.statusCode == 200) {
        return;
      }
    }
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
        builder: (contextState, state1) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: CupertinoColors.systemGrey5,
            body: Stack(
              children: [
                CustomScrollView(
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
                                    height:
                                        MediaQuery.of(contextState).padding.top,
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
                                                    contextState,
                                                    limit: 1,
                                                    images: [],
                                                    isProfile: true,
                                                  )
                                                : showImageViewer(
                                                    useSafeArea: false,
                                                    backgroundColor:
                                                        Colors.black,
                                                    doubleTapZoomable: true,
                                                    swipeDismissible: true,
                                                    contextState,
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
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Color(
                                                          int.tryParse(state1.userModel
                                                                      .color) !=
                                                                  null
                                                              ? int.parse(state1
                                                                  .userModel
                                                                  .color)
                                                              : CupertinoColors
                                                                  .activeBlue
                                                                  .value,
                                                        ).withOpacity(.6),
                                                        Color(
                                                          int.tryParse(state1.userModel
                                                                      .color) !=
                                                                  null
                                                              ? int.parse(state1
                                                                  .userModel
                                                                  .color)
                                                              : CupertinoColors
                                                                  .activeBlue
                                                                  .value,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  child: state1.userModel.name
                                                          .isNotEmpty
                                                      ? Center(
                                                          child: Text(
                                                            state1.userModel
                                                                .name[0]
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 36.sp,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                )
                                              : Padding(
                                                  padding: EdgeInsets.zero,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: CachedNetworkImage(
                                                      imageUrl: state1
                                                          .userModel.image,
                                                      height: 80.w,
                                                      width: 80.w,
                                                      fit: BoxFit.cover,
                                                      placeholder: (b, w) {
                                                        return Shimmer
                                                            .fromColors(
                                                          baseColor:
                                                              Colors.white,
                                                          highlightColor: Colors
                                                              .grey
                                                              .withOpacity(.3),
                                                          child: Container(
                                                            height: 80.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16),
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
                                                  color: CupertinoColors
                                                      .activeGreen,
                                                );
                                              },
                                            )),
                                    ],
                                  ),
                                  10.getH(),
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30.w),
                                      child: Text(
                                        "${state1.userModel.name} ${state1.userModel.lastName}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 21.sp,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
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
                      expandedHeight: 140.h,
                      scrolledUnderElevation: 0,
                      floating: true,
                      leading: IconButton(
                        style:
                            IconButton.styleFrom(foregroundColor: Colors.white),
                        onPressed: () {
                          isOpen = true;
                          setState(() {});
                        },
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
                          onPressed: () async {
                            await Navigator.push(
                                    widget.context,
                                    PageTransition(
                                        child: EditProfileScreen(
                                          context: contextState,
                                        ),
                                        type: PageTransitionType.fade))
                                .then((b) {
                              contextState
                                  .read<AuthBloc>()
                                  .add(GetCurrentUser());
                              setState(() {});
                            });
                            setState(() {});
                          },
                        )
                      ],
                    ),
                    SliverList.list(
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.end,
                              alignment: WrapAlignment.center,
                              children: [
                                SelectableText(
                                  cursorColor: CupertinoColors.activeBlue,
                                  showCursor: false,
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(
                                        text: state1.userModel.phone));
                                    Fluttertoast.showToast(
                                        backgroundColor:
                                            CupertinoColors.systemGrey,
                                        gravity: ToastGravity.BOTTOM,
                                        msg: "copy".tr());
                                  },
                                  state1.userModel.phone,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp,
                                      color: Colors.black.withOpacity(.4),
                                      overflow: TextOverflow.ellipsis),
                                ),
                                state1.userModel.username.isNotEmpty
                                    ? 5.getW()
                                    : const SizedBox(),
                                state1.userModel.username.isNotEmpty
                                    ? SelectableText(
                                        cursorColor: CupertinoColors.activeBlue,
                                        showCursor: false,
                                        onTap: () {
                                          userName.text = context
                                              .read<AuthBloc>()
                                              .state
                                              .userModel
                                              .username;

                                          showModalBottomSheet(
                                            useSafeArea: true,
                                            backgroundColor:
                                                CupertinoColors.systemGrey5,
                                            barrierColor: Colors.transparent,
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) {
                                              return StatefulBuilder(
                                                  builder: (context, setState) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                      color: CupertinoColors
                                                          .systemGrey5,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      24.r),
                                                              topRight: Radius
                                                                  .circular(
                                                                      24.r))),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    0.w),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            CupertinoButton(
                                                                child: Text(
                                                                  "cancel".tr(),
                                                                  style: TextStyle(
                                                                      color: CupertinoColors
                                                                          .activeBlue,
                                                                      fontSize:
                                                                          15.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                onPressed: () {
                                                                  userName.text = state1
                                                                      .userModel
                                                                      .username;
                                                                  Navigator.pop(
                                                                      context);
                                                                }),
                                                            Text(
                                                              "username".tr(),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      15.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            CupertinoButton(
                                                                child: Text(
                                                                  "done".tr(),
                                                                  style: TextStyle(
                                                                      color: CupertinoColors
                                                                          .activeBlue,
                                                                      fontSize:
                                                                          15.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  await onDone();
                                                                  if (!context.mounted) return;
                                                                  Navigator.pop(
                                                                      context);
                                                                  context
                                                                      .read<
                                                                          AuthBloc>()
                                                                      .add(
                                                                          GetCurrentUser());
                                                                }),
                                                          ],
                                                        ),
                                                      ),
                                                      20.getH(),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    14.w),
                                                        child:
                                                            CupertinoTextField(
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .allow(RegExp(
                                                                    r'^[a-zA-Z][a-zA-Z0-9_]{0,31}$')),
                                                          ],
                                                          maxLength: 29,
                                                          onTapOutside: (v) {
                                                            setState(() {});
                                                          },
                                                          onChanged: (v) async {
                                                            setState(() {});
                                                            errorText =
                                                                validateUsername(
                                                                    v);
                                                            if (v.isNotEmpty) {
                                                              if (validateUsername(
                                                                      v)
                                                                  .isEmpty) {
                                                                _onTextChanged(
                                                                    v);
                                                              }
                                                            }
                                                            setState(() {});
                                                          },
                                                          cursorColor:
                                                              CupertinoColors
                                                                  .activeBlue,
                                                          placeholder:
                                                              "username".tr(),
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10.sp),
                                                          controller: userName,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.r),
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      errorText.isNotEmpty
                                                          ? Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          24.w,
                                                                      vertical:
                                                                          5.h),
                                                              child: Text(
                                                                errorText,
                                                                style: const TextStyle(
                                                                    color: CupertinoColors
                                                                        .destructiveRed,
                                                                    fontSize:
                                                                        12),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            )
                                                          : SizedBox(
                                                              height: 10.h,
                                                            ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    24.w),
                                                        child: Text(
                                                          "username_description"
                                                              .tr(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 12.sp,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              });
                                            },
                                          );
                                        },
                                        "@${state1.userModel.username}",
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.sp,
                                          color: CupertinoColors.activeBlue
                                              .withOpacity(.8),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                        ListTileItem(
                          voidCallback: () {
                            showCupertinoModalPopup(
                              context: contextState,
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
                                            limit: 1,
                                            images: [],
                                            isProfile: true);
                                      },
                                      child: Text(
                                        "upload_image".tr(),
                                        style: const TextStyle(
                                            color: CupertinoColors.activeBlue,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    state1.userModel.image.length > 20
                                        ? CupertinoActionSheetAction(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              context
                                                  .read<AuthBloc>()
                                                  .add(AuthDeleteImage());
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
                                  contextState,
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
                            Navigator.push(contextState,
                                MaterialPageRoute(builder: (context) {
                              return ScanScreen(barcode: (v) {});
                            }));
                          },
                          title: "scan".tr(),
                          icon: const Icon(
                            CupertinoIcons.qrcode_viewfinder,
                            color: Colors.white,
                          ),
                          color: CupertinoColors.systemRed,
                        ),
                        ListTileItem(
                          voidCallback: () {
                            Navigator.push(
                                contextState,
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
                                context: contextState,
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
                              contextState
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
                if (isOpen)
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isOpen = false;
                          });
                        },
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: Colors.white,
                          ),
                          child: QrImageView(
                            data: state1.userModel.phone,
                            size: 200,
                          ),
                        ),
                      ),
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
