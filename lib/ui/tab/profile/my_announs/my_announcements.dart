import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/announ_bloc/announ_bloc.dart';
import 'package:ish_top/blocs/announ_bloc/announ_state.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/auth/auth_state.dart';
import 'package:ish_top/data/models/announ_model.dart';
import 'package:ish_top/ui/tab/profile/my_announs/widgets/my_announs_item.dart';

class MyAnnouncements extends StatefulWidget {
  const MyAnnouncements({super.key, required this.statusAnnoun});

  final StatusAnnoun statusAnnoun;

  @override
  State<MyAnnouncements> createState() => _MyAnnouncementsState();
}

class _MyAnnouncementsState extends State<MyAnnouncements> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AnnounBloc, AnnounState>(
      listener: (context, announState) {},
      builder: (context, announState) {
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, authState) {},
          builder: (context, authState) {
            return Scaffold(
              backgroundColor: CupertinoColors.systemGrey5,
              appBar: AppBar(
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
                scrolledUnderElevation: 0,
                flexibleSpace: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                backgroundColor: Colors.white.withOpacity(.9),
                title: Text("my_announcements".tr()),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: ListView(
                        children: [
                          ...List.generate(
                              announState.myHires
                                  .where((test) =>
                                      test.status == widget.statusAnnoun)
                                  .toList()
                                  .length, (index) {
                            return MyAnnounItem(
                                hires: announState.myHires
                                    .where(
                                        (v) => v.status == widget.statusAnnoun)
                                    .toList()[index],
                                voidCallback: () {},
                                scrollController: ScrollController(),
                                context1: context);
                          })
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
