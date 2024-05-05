import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ish_top/ui/auth/auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;

  bool check = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CupertinoColors.systemGrey5,
        appBar: AppBar(
          backgroundColor: CupertinoColors.systemGrey5,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text("profile").tr(),
        ),
        body: Column(
          children: [
            ListTile(
              trailing: CupertinoSwitch(
                value: check,
                onChanged: (v) {
                  !v
                      ? context.setLocale(const Locale(
                          "ru",
                          "RU",
                        ))
                      : context.setLocale(const Locale(
                          "uz",
                          "UZ",
                        ));
                  check = v;
                  setState(() {});
                },
              ),
              title: const Text("Uzbek tili"),
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
                              CupertinoPageRoute(
                                  builder: (context) => const AuthScreen()));
                        },
                        child: const Text("Login")),
                  )
                : Center(
                    child: Text(
                        user?.email ?? "Email topilmadi lekin login qilingan"),
                  ),
          ],
        ));
  }
}
