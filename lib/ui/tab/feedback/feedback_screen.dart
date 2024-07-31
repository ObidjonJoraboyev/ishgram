import 'dart:io';
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/comment/comment_bloc.dart';
import 'package:ish_top/blocs/comment/comment_state.dart';
import 'package:ish_top/data/models/message_model.dart';
import 'package:ish_top/data/models/user_model.dart';
import 'package:ish_top/ui/tab/announ/widgets/zoom_tap.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:ish_top/utils/utility_functions.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key, required this.userModel});

  final UserModel userModel;

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final FocusNode focus = FocusNode();
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool bottomVisibility = false;
  List<MessageModel> list = [];

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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: 1 == 1,
      backgroundColor: CupertinoColors.systemGrey6,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 65),
        child: Container(
          decoration: const BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(width: 0.5, color: Colors.black),
            ),
          ),
          child: AppBar(
            scrolledUnderElevation: 0,
            elevation: 0,
            backgroundColor: CupertinoColors.white,
            actions: [
              ClipRRect(
                borderRadius: BorderRadius.circular(1000),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    width: 50.spMin,
                    height: 50.spMin,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          CupertinoColors.activeOrange.withOpacity(.6),
                          CupertinoColors.activeOrange,
                        ],
                      ),
                    ),
                    child: Center(
                        child: Icon(
                      Icons.support_agent_sharp,
                      color: Colors.white,
                      size: 22.sp,
                    )),
                  ),
                ),
              )
            ],
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  "support".tr(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  "Online",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    letterSpacing: 1,
                    color: CupertinoColors.activeBlue,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<MessageBloc, MessageState>(
        builder: (context, snapshot) {
          if (list.isEmpty) {
            bottomVisibility = false;
          }

          return SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    reverse: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      ...List.generate(
                        list.length,
                        (index) {
                          return ScaleOnPress(
                            scaleValue: 0.99,
                            child: Row(
                              children: [
                                ChatBubble(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 4.h, horizontal: 3.w),
                                  clipper: ChatBubbleClipper3(
                                      type: BubbleType.receiverBubble),
                                  child: Text(
                                    list[index].messageText,
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      letterSpacing: 1,
                                    ),
                                    maxLines: 1,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  color: CupertinoColors.systemGrey6,
                  alignment: Alignment.topCenter,
                  child: Row(
                    children: [
                      Transform.rotate(
                        angle: 45 * (pi / 180),
                        child: IconButton(
                          onPressed: () {
                            takeAnImage(
                              context,
                              images: [],
                              limit: 1,
                            );
                          },
                          icon: const Icon(
                            Icons.attach_file,
                            size: 26,
                            color: CupertinoColors.systemGrey2,
                          ),
                        ),
                      ),
                      Expanded(
                        child: CupertinoTextField(
                          onTapOutside: (v) {
                            FocusScope.of(context).unfocus();
                          },
                          textInputAction: TextInputAction.done,
                          maxLength: 400,
                          maxLines: null,
                          controller: controller,
                          onChanged: (v) {
                            setState(() {});
                          },
                          onTap: () {},
                          cursorColor: CupertinoColors.activeBlue,
                          focusNode: focus,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          placeholder: "Message",
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: CupertinoColors.systemGrey3.withOpacity(.8),
                          ),
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.only(right: 5.w),
                        onPressed: () async {},
                        child: const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Icon(
                            CupertinoIcons.paperplane,
                            color: CupertinoColors.systemGrey2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                10.getH(),
              ],
            ),
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
