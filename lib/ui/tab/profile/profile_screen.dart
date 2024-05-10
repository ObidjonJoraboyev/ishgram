import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/auth/auth_event.dart';
import 'package:ish_top/data/local/local_storage.dart';
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
