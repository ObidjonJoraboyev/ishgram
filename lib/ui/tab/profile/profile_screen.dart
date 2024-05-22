import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ish_top/utils/utility_functions.dart';
import '../../../data/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker picker = ImagePicker();
  String imageUrl = "";
  String storagePath = "";
  String fcm = "";

  UserModel thisUser = UserModel.initial;

  Future<void> init() async {
    setState(() {});
    if (!context.mounted) return;
  }

  @override
  void initState() {
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
      home: Scaffold(
        backgroundColor: Colors.grey.withOpacity(.06),
        appBar: AppBar(
          backgroundColor: Colors.grey.withOpacity(.02),
          leading: IconButton(
            style: IconButton.styleFrom(foregroundColor: Colors.white),
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.qrcode,
              color: CupertinoColors.activeBlue,
              size: 28,
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: const Text(
                "Edit",
                style: TextStyle(
                    color: CupertinoColors.activeBlue,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
              onPressed: () {},
            )
          ],
          bottom: PreferredSize(
            preferredSize: const Size(100, 70),
            child: GestureDetector(
              onTap: () async {
                takeAnImage(context, limit: 1, images: []);

                setState(
                  () {},
                );
              },
              child: Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Center(
                  child: Text(
                    thisUser.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(
                  thisUser.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 24),
                ),
                Text(
                  thisUser.number,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Colors.black.withOpacity(.4),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CupertinoListTile(
                        leadingSize: 35,
                        onTap: () {},
                        backgroundColorActivated: Colors.white,
                        backgroundColor: Colors.white,
                        leading: const Icon(
                          CupertinoIcons.camera,
                          color: CupertinoColors.activeBlue,
                        ),
                        title: const Text(
                          "Change Profile Photo",
                          style: TextStyle(color: CupertinoColors.activeBlue),
                        )),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CupertinoListTile(
                        trailing: const Icon(
                          CupertinoIcons.right_chevron,
                          size: 22,
                          color: Colors.grey,
                        ),
                        onTap: () {},
                        backgroundColorActivated: Colors.white,
                        backgroundColor: Colors.white,
                        leadingSize: 35,
                        leading: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.red,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(
                              CupertinoIcons.person_circle_fill,
                              color: CupertinoColors.white,
                            ),
                          ),
                        ),
                        title: const Text(
                          "My Profile",
                          style: TextStyle(color: CupertinoColors.black),
                        )),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CupertinoListTile(
                      trailing: const Icon(
                        CupertinoIcons.right_chevron,
                        size: 22,
                        color: Colors.grey,
                      ),
                      onTap: () {},
                      backgroundColorActivated: Colors.white,
                      backgroundColor: Colors.white,
                      leadingSize: 35,
                      leading: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: CupertinoColors.activeBlue,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(
                            CupertinoIcons.creditcard_fill,
                            color: CupertinoColors.white,
                          ),
                        ),
                      ),
                      title: const Text(
                        "Wallet",
                        style: TextStyle(
                          color: CupertinoColors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CupertinoListTile(
                      trailing: const Icon(
                        CupertinoIcons.right_chevron,
                        size: 22,
                        color: Colors.grey,
                      ),
                      onTap: () {
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
                      backgroundColorActivated: Colors.white,
                      backgroundColor: Colors.white,
                      leadingSize: 35,
                      leading: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: CupertinoColors.activeBlue,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(
                            Icons.language,
                            color: CupertinoColors.white,
                          ),
                        ),
                      ),
                      title: Text(
                        "language".tr(),
                        style: const TextStyle(
                          color: CupertinoColors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
