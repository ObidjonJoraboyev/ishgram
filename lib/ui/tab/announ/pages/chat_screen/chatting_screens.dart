import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/data/models/user_model.dart';

class ChattingScreens extends StatefulWidget {
  const ChattingScreens({super.key, required this.userModel});

  final UserModel userModel;

  @override
  State<ChattingScreens> createState() => _ChattingScreensState();
}

class _ChattingScreensState extends State<ChattingScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: CupertinoColors.systemGrey5,
      appBar: AppBar(
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
        backgroundColor: Colors.white.withOpacity(.8),
        title: Text(widget.userModel.name),
        actions: [
          if (widget.userModel.image.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                imageUrl: widget.userModel.image,
              ),
            )
          else
            Container(
              width: 40.w,
              height: 40.w,
              margin: EdgeInsets.only(right: 5.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(int.parse(widget.userModel.color)).withOpacity(.7),
                    Color(int.parse(widget.userModel.color)),
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  widget.userModel.name[0].toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
        ],
      ),
      body: BlocConsumer(
        listener: (c, r) {},
        builder: (context, state) {
          return const Column(
            children: [Text("context")],
          );
        },
      ),
    );
  }
}
