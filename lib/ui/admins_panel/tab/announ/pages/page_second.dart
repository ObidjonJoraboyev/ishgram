import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/auth/auth_state.dart';
import 'package:ish_top/data/models/user_model.dart';

class AdminPageSecond extends StatefulWidget {
  const AdminPageSecond({super.key});

  @override
  State<AdminPageSecond> createState() => _AdminPageSecondState();
}

class _AdminPageSecondState extends State<AdminPageSecond> {
  List<UserModel> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGrey5,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          users = state.users
              .where((v) => v.isPrivate == false && v.who == 4)
              .toList();
          return ListView(
            children: [
              ...List.generate(users.length, (index) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () {},
                      leading: users[index].image.isNotEmpty
                          ? Image.network(users[index].image)
                          : Container(
                              width: 40.w,
                              height: 40.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(int.parse(users[index].color))
                                        .withOpacity(.7),
                                    Color(int.parse(users[index].color)),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  users[index].name[0].toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                      title: Text(
                        users[index].name,
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      subtitle: Text(users[index].phone),
                    ),
                    Container(
                      width: double.infinity,
                      height: 0.2,
                      color: Colors.black.withOpacity(.9),
                    )
                  ],
                );
              })
            ],
          );
        },
      ),
    );
  }
}
