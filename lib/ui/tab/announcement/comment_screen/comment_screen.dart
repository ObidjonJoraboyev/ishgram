import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/data/models/announcement.dart';
import 'package:ish_top/data/models/message_model.dart';
import 'package:ish_top/ui/tab/announcement/detail/detail_screen.dart';
import 'package:ish_top/ui/tab/announcement/widgets/zoom_tap.dart';
import 'package:ish_top/utils/size/size_utils.dart';

import '../../../../blocs/message/message_bloc.dart';
import '../../../../blocs/message/message_event.dart';
import '../../../../data/local/local_storage.dart';

class CommentScreen extends StatefulWidget {
  CommentScreen({super.key, required this.announcementModel});

  final AnnouncementModel announcementModel;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final ScrollController scrollController = ScrollController();

  final TextEditingController controller = TextEditingController();

  final FocusNode focus = FocusNode();

  bool bottomVisibility = false;

  MessageModel messageModel = MessageModel.initialValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "comments".tr(),
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 20.sp,
              letterSpacing: 0.3),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.sizeOf(context).width, 2),
          child: Container(
            height: 1,
            color: CupertinoColors.systemGrey,
          ),
        ),
        backgroundColor: CupertinoColors.systemGrey6,
      ),
      backgroundColor: CupertinoColors.systemGrey5,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.sp),
            decoration:
                BoxDecoration(color: CupertinoColors.systemGrey6, boxShadow: [
              BoxShadow(
                spreadRadius: 1,
                blurRadius: 15,
                color: CupertinoColors.systemGrey4.withOpacity(.7),
              )
            ]),
            child: ScaleOnPress(
              scaleValue: 0.98,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return DetailScreen(hireModel: widget.announcementModel);
                    },
                  ),
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: "image0",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: CachedNetworkImage(
                        imageUrl: widget.announcementModel.image[0].imageUrl,
                        width: 50.w,
                        height: 50.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  10.getW(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: "detail",
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              widget.announcementModel.title,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        Hero(
                          tag: "description",
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              widget.announcementModel.description,
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(child: ListView(
            controller: scrollController,
          )),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            color: CupertinoColors.systemGrey5,
            height: Platform.isIOS ? 75 : null,
            alignment: Alignment.topCenter,
            child: CupertinoTextField(
              textInputAction: TextInputAction.done,
              maxLines: null,
              controller: controller,
              onChanged: (v) {},
              onTap: () {
                focus.requestFocus();
              },
              cursorColor: const Color(0xff30A3E6),
              focusNode: focus,
              suffix: IconButton(
                onPressed: () async {
                  if (controller.text.isNotEmpty) {
                    if (!context.mounted) return;
                    String controllerTemp = controller.text;
                    controller.clear();

                    messageModel = messageModel.copyWith(
                      createdTime:
                          DateTime.now().millisecondsSinceEpoch.toString(),
                      messageText: controllerTemp,
                      messageId: "",
                      status: true,
                      idFrom: StorageRepository.getString(key: "userNumber"),
                      idTo: widget.announcementModel.docId,
                    );

                    context
                        .read<MessageBloc>()
                        .add(MessageAddEvent(messages: messageModel));
                    scrollController.position.animateTo(
                        scrollController.position.minScrollExtent,
                        duration: const Duration(seconds: 1),
                        curve: Curves.linear);
                    bottomVisibility = false;
                  }
                },
                icon: const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Icon(
                    CupertinoIcons.paperplane_fill,
                    color: CupertinoColors.activeBlue,
                  ),
                ),
              ),
              clearButtonMode: OverlayVisibilityMode.editing,
              placeholder: "Message",
              placeholderStyle: TextStyle(
                  color: Colors.white.withOpacity(.9),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: CupertinoColors.systemGrey2,
              ),
            ),
          ),
        ],
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
