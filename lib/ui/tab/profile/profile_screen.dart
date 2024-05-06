import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ish_top/data/local/local_storage.dart';
import 'package:ish_top/ui/auth/auth_screen.dart';
import 'package:ish_top/ui/history/history_screen.dart';

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
            trailing: CupertinoSwitch(
              value: check,
              onChanged: (v) async {
                !v
                    ? await context.setLocale(const Locale("ru", "RU"))
                    : await context.setLocale(const Locale("uz", "UZ"));
                setState(() {});
                check = v;
                await StorageRepository.setBool(
                  key: "language",
                  value: check,
                );
              },
            ),
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
          user == null
              ? Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AuthScreen()));
                      },
                      child: const Text("Login")),
                )
              : Center(
                  child: Column(
                    children: [
                      Text(user?.email ??
                          "Email topilmadi lekin login qilingan"),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AuthScreen(),
                              ),
                              (r) => false);
                        },
                        child: const Text(
                          "LOG OUT",
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
