import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ish_top/ui/auth/auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: const Text("Profil"),
      ),
      body: user == null
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
              child:
                  Text(user?.email ?? "Email topilmadi lekin login qilingan"),
            ),
    );
  }
}
