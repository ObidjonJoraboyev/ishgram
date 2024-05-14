import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/auth/auth_event.dart';
import 'package:ish_top/data/local/local_storage.dart';
import 'package:ish_top/ui/history/history_screen.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;

  bool check = !StorageRepository.getBool(key: "language");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGrey5,
      appBar: AppBar(
        backgroundColor: CupertinoColors.systemGrey5,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text("profile").tr(),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    actions: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          10.getH(),
                          ZoomTapAnimation(
                            onTap: () async {
                              await context.setLocale(const Locale("uz", "UZ"));
                              if (!context.mounted) return;
                              Navigator.pop(context);
                            },
                            child: Text(
                              "uz".tr(),
                              style: TextStyle(
                                color: CupertinoColors.activeBlue,
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                          5.getH(),
                          const Divider(),
                          5.getH(),
                          ZoomTapAnimation(
                            onTap: () async {
                              await context.setLocale(const Locale("ru", "RU"));
                              if (!context.mounted) return;
                              Navigator.pop(context);
                            },
                            child: Text(
                              "ru".tr(),
                              style: TextStyle(
                                color: CupertinoColors.activeBlue,
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                          5.getH(),
                          const Divider(),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 5, bottom: 15),
                              child: ZoomTapAnimation(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "cancel".tr(),
                                  style: TextStyle(
                                      color: CupertinoColors.activeBlue,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.sp),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                },
              );
            },
            title: Text("language".tr()),
          ),
          Container(
            width: double.infinity,
            height: 0.66,
            color: Colors.black.withOpacity(.5),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text("history".tr()),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HistoryScreen()));
            },
          ),
          Container(
            width: double.infinity,
            height: 0.66,
            color: Colors.black.withOpacity(.5),
          ),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: Column(
              children: [
                Text(
                  StorageRepository.getString(key: "userNumber"),
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    context.read<AuthBloc>().add(LogOutEvent(context: context));
                  },
                  child: const Text(
                    "Log out",
                    style: TextStyle(color: Colors.red),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
