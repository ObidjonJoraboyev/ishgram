import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/user/user_bloc.dart';
import 'package:ish_top/blocs/user/user_event.dart';
import 'package:ish_top/blocs/user/user_state.dart';
import 'package:ish_top/data/forms/form_status.dart';
import 'package:ish_top/ui/auth/widgets/button.dart';
import 'package:ish_top/ui/tab/profile/widgets/list_tile_item.dart';
import 'package:ish_top/utils/formatters/formatters.dart';
import 'package:ish_top/utils/size/size_utils.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  TextEditingController oldPasswordCtrl = TextEditingController();
  TextEditingController newPasswordCtrl = TextEditingController();

  onDone() async {
    setState(() {});
    context.read<UserBloc>().add(UserChangePassword(
        newPassword: newPasswordCtrl.text, oldPassword: oldPasswordCtrl.text));
  }

  FocusNode oldFocusNode = FocusNode();
  FocusNode newFocusNode = FocusNode();

  bool validateTrue() {
    if (PasswordValidator.validatePassword(newPasswordCtrl.text) == null &&
        PasswordValidator.validatePassword(oldPasswordCtrl.text) == null &&
        newPasswordCtrl.text != oldPasswordCtrl.text &&
        context.read<UserBloc>().state.formStatus != FormStatus.updating) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: CupertinoColors.systemGrey6,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            title: Text(
              "security_privacy".tr(),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 18.sp,
              ),
            ),
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
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            backgroundColor: Colors.white.withOpacity(.9),
          ),
          body: ListView(
            children: [
              ListTileItem(
                voidCallback: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    enableDrag: true,
                    builder: (context) {
                      return GestureDetector(
                        onVerticalDragEnd: (details) {
                          if (details.primaryVelocity! > 20) {}
                        },
                        child: StatefulBuilder(builder: (context, setState) {
                          return Container(
                            decoration: BoxDecoration(
                                color: CupertinoColors.systemGrey6,
                                borderRadius: BorderRadius.circular(24.r)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14.w),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      children: [
                                        10.getH(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CupertinoButton(
                                                padding: EdgeInsets.zero,
                                                child: Text(
                                                  "cancel".tr(),
                                                  style: TextStyle(
                                                      color: CupertinoColors
                                                          .activeBlue,
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  oldPasswordCtrl.clear();
                                                  newPasswordCtrl.clear();
                                                }),
                                            Text(
                                              "password".tr(),
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            CupertinoButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: validateTrue()
                                                  ? onDone
                                                  : () {},
                                              child: Text(
                                                "done".tr(),
                                                style: TextStyle(
                                                    color: validateTrue()
                                                        ? CupertinoColors
                                                            .activeBlue
                                                        : CupertinoColors
                                                            .activeBlue
                                                            .withOpacity(.6),
                                                    fontSize: 15.sp,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                        20.getH(),
                                        CupertinoFormSection.insetGrouped(
                                          margin: EdgeInsets.zero,
                                          backgroundColor:
                                              CupertinoColors.systemGrey6,
                                          children: [
                                            CupertinoTextFormFieldRow(
                                              cursorColor:
                                                  CupertinoColors.activeBlue,
                                              focusNode: oldFocusNode,
                                              textInputAction:
                                                  TextInputAction.next,
                                              controller: oldPasswordCtrl,
                                              onChanged: (v) {
                                                validateTrue();
                                                setState(() {});
                                              },
                                              maxLength: 30,
                                              maxLines: 1,
                                              minLines: 1,
                                              prefix: GestureDetector(
                                                  onTap: () {
                                                    oldFocusNode.requestFocus();
                                                  },
                                                  child: Text(
                                                      "previous_password"
                                                          .tr())),
                                              placeholder: 'enter'.tr(),
                                              validator: (String? value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a value';
                                                }
                                                return null;
                                              },
                                            ),
                                            CupertinoTextFormFieldRow(
                                              cursorColor:
                                                  CupertinoColors.activeBlue,
                                              focusNode: newFocusNode,
                                              textInputAction:
                                                  TextInputAction.done,
                                              controller: newPasswordCtrl,
                                              onChanged: (v) {
                                                setState(() {});
                                                validateTrue();
                                              },
                                              maxLength: 30,
                                              maxLines: 1,
                                              minLines: 1,
                                              prefix: GestureDetector(
                                                  onTap: () {
                                                    newFocusNode.requestFocus();
                                                  },
                                                  child: Text("new_pass".tr())),
                                              placeholder: 'enter'.tr(),
                                              validator: (String? value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a value';
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: LoginButtonItems(
                                        title: "done".tr(),
                                        onTap: onDone,
                                        isLoading: state.formStatus ==
                                            FormStatus.updating,
                                        active: validateTrue()),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  );
                },
                title: "Change password",
                icon: const Icon(
                  CupertinoIcons.lock_shield,
                  color: Colors.white,
                ),
                color: CupertinoColors.activeGreen,
              ),
              ListTileItem(
                isSwitch: true,
                voidCallback: () {},
                title: "as_worker".tr(),
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: state.userModel.isPrivate
                      ? const Icon(
                          CupertinoIcons.eye,
                          key: ValueKey<int>(1),
                          color: Colors.white,
                        )
                      : const Icon(
                          CupertinoIcons.eye_slash,
                          key: ValueKey<int>(2),
                          color: Colors.white,
                        ),
                ),
                color: CupertinoColors.systemGrey,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  "enable_to_visible".tr(),
                  style: TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.start,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
