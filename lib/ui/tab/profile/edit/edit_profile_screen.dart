import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/user_bloc.dart';
import 'package:ish_top/blocs/user_event.dart';
import 'package:ish_top/blocs/user_state.dart';
import 'package:ish_top/data/forms/form_status.dart';
import 'package:ish_top/data/models/user_model.dart';
import 'package:ish_top/ui/tab/profile/edit_username_screen.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:ish_top/utils/utility_functions.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.context});

  final BuildContext context;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController userName = TextEditingController();
  final TextEditingController bioCtrl = TextEditingController();
  UserModel userModel = UserModel.initial;
  bool isWorker = false;

  @override
  void initState() {
    userModel = context.read<UserBloc>().state.userModel;
    nameCtrl.text = userModel.name;
    lastName.text = userModel.lastName;
    selectedFruit = userModel.age;
    userName.text = userModel.username;
    isWorker = userModel.isPrivate;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    super.initState();
  }

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void dispose() {
    _controller.dispose();

    userName.dispose();
    super.dispose();
  }

  int selectedFruit = 0;

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: MediaQuery.of(context).size.height / 3.5,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: CupertinoColors.white,
        ),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  String errorText = "";

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        color: CupertinoColors.systemGrey5,
        child: SafeArea(
          child: BlocConsumer<UserBloc, UserState>(
            listener: (context, state1) {
              if (state1.formStatus == FormStatus.uploadingImage) {
                _controller.animateTo(state1.progress);
              }
              if (state1.formStatus == FormStatus.successImage) {
                _controller.reset();
              }
            },
            builder: (context, state1) {
              return Scaffold(
                backgroundColor: CupertinoColors.systemGrey5,
                extendBodyBehindAppBar: true,
                body: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: Text(
                                "cancel".tr(),
                                style: TextStyle(
                                    color: CupertinoColors.activeBlue,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                              onPressed: () {
                                if (state1.userModel.username !=
                                        userName.text ||
                                    state1.userModel.name != nameCtrl.text ||
                                    state1.userModel.lastName !=
                                        lastName.text ||
                                    state1.userModel.age != selectedFruit ||
                                    state1.userModel.isPrivate != isWorker ||
                                    state1.userModel.bio != bioCtrl.text) {
                                  showDialogCustom(
                                      context: context,
                                      content: "click_discard",
                                      actionFirst: "cancel",
                                      onAction: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      isRed: true,
                                      actionSecond: "Discard");
                                } else {
                                  Navigator.pop(context);
                                }
                              }),
                          CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: Text(
                                "done".tr(),
                                style: TextStyle(
                                    color: CupertinoColors.activeBlue,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              onPressed: () {
                                widget.context.read<UserBloc>().add(
                                      UpdateUser(
                                        userModel: state1.userModel.copyWith(
                                            name: nameCtrl.text,
                                            lastName: lastName.text,
                                            age: selectedFruit,
                                            username: userName.text,
                                            bio: bioCtrl.text,
                                            isPrivate: isWorker),
                                      ),
                                    );

                                setState(() {});
                                widget.context
                                    .read<UserBloc>()
                                    .add(GetCurrentUser());
                                if (state1.formStatus == FormStatus.success &&
                                    state1.formStatus != FormStatus.loading) {
                                  Navigator.pop(context);
                                }
                              }),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                                                useSafeArea: false,
                                                backgroundColor: Colors.black,
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
                                                  color: CupertinoColors
                                                      .activeBlue
                                                      .withOpacity(.2)),
                                              child: Center(
                                                  child: Icon(
                                                Icons.add_a_photo,
                                                color:
                                                    CupertinoColors.activeBlue,
                                                size: 24.sp,
                                              )))
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    state1.userModel.image,
                                                height: 90.sp,
                                                width: 90.sp,
                                                fit: BoxFit.cover,
                                                placeholder: (b, w) {
                                                  return Shimmer.fromColors(
                                                    baseColor:
                                                        CupertinoColors.white,
                                                    highlightColor:
                                                        CupertinoColors
                                                            .systemGrey6,
                                                    enabled: true,
                                                    period: const Duration(
                                                        seconds: 1),
                                                    child: Container(
                                                      height: 90.sp,
                                                      width: 90.sp,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(1006),
                                                      ),
                                                    ),
                                                  );
                                                },
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
                            ],
                          ),
                          CupertinoButton(
                              child: Text(
                                "upload_image".tr(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp,
                                    color: CupertinoColors.activeBlue),
                              ),
                              onPressed: () {
                                takeAnImage(
                                  isThereDelete:
                                      state1.userModel.image.isNotEmpty
                                          ? true
                                          : null,
                                  onDelete: () {
                                    Navigator.of(context).pop();
                                    context
                                        .read<UserBloc>()
                                        .add(AuthDeleteImage());
                                  },
                                  context,
                                  limit: 1,
                                  images: [],
                                  isProfile: true,
                                );
                              }),
                          10.getH(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            child: Column(
                              children: [
                                CupertinoTextField(
                                  maxLength: 30,
                                  placeholder: "name".tr(),
                                  cursorColor: CupertinoColors.activeBlue,
                                  padding: EdgeInsets.all(10.sp),
                                  controller: nameCtrl,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12.r),
                                          topRight: Radius.circular(12.r)),
                                      color: Colors.white),
                                ),
                                Container(
                                    width: double.infinity,
                                    height: 0.30.h,
                                    color: Colors.grey),
                                CupertinoTextField(
                                  cursorColor: CupertinoColors.activeBlue,
                                  placeholder: "last_name".tr(),
                                  padding: EdgeInsets.all(10.sp),
                                  controller: lastName,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12.r),
                                        bottomRight: Radius.circular(12.r)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          10.getH(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            child: CupertinoTextField(
                              maxLength: 200,
                              maxLines: null,
                              cursorColor: CupertinoColors.activeBlue,
                              placeholder: "bio".tr(),
                              padding: EdgeInsets.all(10.sp),
                              controller: bioCtrl,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(12.r),
                                      topLeft: Radius.circular(12.r)),
                                  color: Colors.white),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 14.w),
                            width: double.infinity,
                            height: 0.30.h,
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            child: CupertinoTextField(
                              cursorColor: CupertinoColors.activeBlue,
                              placeholder: "username".tr(),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: const EditUsernameScreen(),
                                        type: PageTransitionType.bottomToTop));
                              },
                              readOnly: true,
                              padding: EdgeInsets.all(10.sp),
                              controller: userName,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(12.r),
                                      bottomLeft: Radius.circular(12.r)),
                                  color: Colors.white),
                            ),
                          ),
                          10.getH(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12.r),
                                  topRight: Radius.circular(12.r)),
                              child: CupertinoListTile(
                                onTap: () => _showDialog(
                                  CupertinoPicker(
                                      magnification: 1.22,
                                      squeeze: 1.2,
                                      useMagnifier: true,
                                      itemExtent: 32,
                                      scrollController:
                                          FixedExtentScrollController(
                                        initialItem: selectedFruit,
                                      ),
                                      onSelectedItemChanged:
                                          (int selectedItem) {
                                        setState(() {
                                          selectedFruit = selectedItem;
                                        });
                                      },
                                      children: [
                                        const Text("-"),
                                        ...List<Widget>.generate(82,
                                            (int index) {
                                          return Center(
                                              child: Text(
                                                  (index + 18).toString()));
                                        }),
                                      ]),
                                ),
                                backgroundColorActivated:
                                    CupertinoColors.systemGrey6,
                                trailing: selectedFruit != 0
                                    ? Text(
                                        (selectedFruit + 17).toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13.0.sp,
                                        ),
                                      )
                                    : Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 14.sp,
                                        color: Colors.black,
                                      ),
                                title: Text(
                                  selectedFruit == 0
                                      ? "enter_your_age".tr()
                                      : "your_age_this".tr(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontSize: 13.sp),
                                ),
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 14.w),
                            width: double.infinity,
                            height: 0.30.h,
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12.r),
                                  bottomRight: Radius.circular(12.r)),
                              child: CupertinoListTile(
                                onTap: () {},
                                backgroundColorActivated:
                                    CupertinoColors.systemGrey6,
                                trailing: CupertinoSwitch(
                                  value: isWorker,
                                  onChanged: (v) {
                                    isWorker = v;
                                    setState(() {});
                                  },
                                ),
                                title: Text("as_worker".tr()),
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ),
                          10.getH(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
