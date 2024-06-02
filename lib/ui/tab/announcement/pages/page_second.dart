import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../blocs/auth/auth_bloc.dart';
import '../../../../blocs/auth/auth_state.dart';
import '../../../../data/models/user_model.dart';

class PageSecond extends StatefulWidget {
  const PageSecond({super.key});

  @override
  State<PageSecond> createState() => _PageSecondState();
}

class _PageSecondState extends State<PageSecond> {
  List<UserModel> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGrey5,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          users = state.users.where((v) => v.isPrivate == false).toList();
          return ListView(
            children: [
              ...List.generate(users.length, (index) {
                return ListTile(
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
                        ),
                  title: Text(users[index].name),
                  subtitle: Text(users[index].phone),
                );
              })
            ],
          );
        },
      ),
    );
  }
}
