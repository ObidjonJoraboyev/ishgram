import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/comment/comment_bloc.dart';
import 'package:ish_top/blocs/comment/comment_state.dart';
import 'package:ish_top/data/models/message_model.dart';
import 'package:ish_top/data/models/user_model.dart';

class AdminFeedbackScreen extends StatefulWidget {
  const AdminFeedbackScreen({super.key, required this.userModel});

  final UserModel userModel;

  @override
  State<AdminFeedbackScreen> createState() => _AdminFeedbackScreenState();
}

class _AdminFeedbackScreenState extends State<AdminFeedbackScreen> {
  final FocusNode focus = FocusNode();

  final TextEditingController controller = TextEditingController();

  final ScrollController scrollController = ScrollController();
  String imageUrl = "";
  String storagePath = "";
  bool bottomVisibility = false;
  MessageModel messageModel = MessageModel.initialValue;

  init() async {}

  @override
  void initState() {
    if (!context.mounted) return;
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >
            scrollController.position.minScrollExtent + 50) {
          if (bottomVisibility == false) {
            setState(() {});
            bottomVisibility = true;
          }
        } else {
          if (bottomVisibility == true) {
            bottomVisibility = false;
            setState(() {});
          }
        }
      },
    );

    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: CupertinoColors.systemGrey5,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 56.h),
        child: Container(
          decoration: const BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(width: 0.5, color: Colors.black),
            ),
          ),
          child: AppBar(
            scrolledUnderElevation: 0,
            title: Text(
              "support".tr(),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 18.sp),
            ),
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: Size(
                MediaQuery.sizeOf(context).width,
                0.1.h,
              ),
              child: Container(
                height: 0.1.h,
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
          ),
        ),
      ),
      body: BlocBuilder<MessageBloc, MessageState>(
        builder: (context, state) {
          if (state.messages.isEmpty) {
            bottomVisibility = false;
          }

          return SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: bottomVisibility
          ? Padding(
              padding: EdgeInsets.only(bottom: Platform.isAndroid ? 50 : 35),
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                    style: IconButton.styleFrom(
                        padding: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black),
                    onPressed: () {
                      scrollController.position.animateTo(
                          scrollController.position.minScrollExtent,
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.linear);
                      setState(() {});
                    },
                    icon: Transform.rotate(
                      angle: -90 * (pi / 180),
                      child: const Icon(Icons.arrow_back_ios),
                    )),
              ),
            )
          : null,
    );
  }
}

String formatEpochToDateTime(int epoch) {
  var dateTime = DateTime.fromMillisecondsSinceEpoch(epoch);
  var formatter = DateFormat('dd MMM HH:mm');
  return formatter.format(dateTime);
}
