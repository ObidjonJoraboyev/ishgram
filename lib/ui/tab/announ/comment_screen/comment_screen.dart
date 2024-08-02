import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/comment/comment_bloc.dart';
import 'package:ish_top/blocs/comment/comment_event.dart';
import 'package:ish_top/blocs/comment/comment_state.dart';
import 'package:ish_top/blocs/user/user_bloc.dart';
import 'package:ish_top/data/local/local_storage.dart';
import 'package:ish_top/data/models/announ_model.dart';
import 'package:ish_top/data/models/message_model.dart';
import 'package:ish_top/ui/tab/announ/detail/detail_screen.dart';
import 'package:ish_top/ui/tab/announ/widgets/zoom_tap.dart';
import 'package:ish_top/utils/size/size_utils.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key, required this.announcementModel});

  final AnnounModel announcementModel;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final ScrollController scrollController = ScrollController();

  final TextEditingController controller = TextEditingController();

  final FocusNode focus = FocusNode();

  bool bottomVisibility = false;

  MessageModel messageModel = MessageModel.initialValue;

  final String currentNum = StorageRepository.getString(key: "userNum");
  final String currentDoc = StorageRepository.getString(key: "userDoc");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
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
        backgroundColor: CupertinoColors.white,
      ),
      backgroundColor: CupertinoColors.systemGrey6,
      body: BlocConsumer<MessageBloc, MessageState>(
        listener: (context, state) {},
        builder: (context, state) {
          List<MessageModel> messages = state.messages
              .where((v) => v.idTo == widget.announcementModel.docId)
              .toList();

          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    boxShadow: [
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
                          return DetailScreen(
                            hireModel: widget.announcementModel,
                            defaultImageIndex: 0,
                          );
                        },
                      ),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: widget.announcementModel.images.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: widget.announcementModel.images[0],
                                width: 50.w,
                                height: 50.w,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 50.w,
                                height: 50.w,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      CupertinoColors.activeOrange,
                                      CupertinoColors.activeBlue,
                                      CupertinoColors.activeGreen,
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      10.getW(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Material(
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
                            Material(
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
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  reverse: true,
                  controller: scrollController,
                  children: [
                    ...List.generate(messages.length, (index) {
                      return Row(
                        mainAxisAlignment: messages[index].idFrom != currentDoc
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            child: CupertinoContextMenu(
                              actions: [
                                CupertinoContextMenuAction(
                                  child: const Icon(Icons.delete),
                                  onPressed: () {},
                                ),
                                CupertinoContextMenuAction(
                                  child: const Icon(Icons.edit),
                                  onPressed: () {},
                                ),
                              ],
                              child: Material(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.transparent,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 12),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(10),
                                          topRight: const Radius.circular(10),
                                          bottomRight: messages[index].idTo ==
                                                  widget.announcementModel.docId
                                              ? const Radius.circular(0)
                                              : const Radius.circular(10),
                                          bottomLeft: messages[index].idTo ==
                                                  widget.announcementModel.docId
                                              ? const Radius.circular(10)
                                              : const Radius.circular(0)),
                                      color: const Color(0xff30A3E6)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        messages[index].messageText,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          letterSpacing: 1,
                                        ),
                                        maxLines: 10,
                                      ),
                                      Text(
                                        "11",
                                        style: TextStyle(
                                            color: Colors.white.withOpacity(.6),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            letterSpacing: 1,
                                            overflow: TextOverflow.ellipsis),
                                        maxLines: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    })
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                            color: CupertinoColors.systemGrey5,
                            boxShadow: [
                              BoxShadow(
                                  color: CupertinoColors.systemGrey
                                      .withOpacity(.1),
                                  spreadRadius: 0,
                                  blurRadius: 10)
                            ],
                            borderRadius: BorderRadius.circular(16.r)),
                        child: CupertinoTextField(
                          style: const TextStyle(color: Colors.black),
                          onTapOutside: (v) {},
                          textInputAction: TextInputAction.done,
                          maxLines: null,
                          controller: controller,
                          onChanged: (v) {},
                          onTap: () {
                            focus.requestFocus();
                          },
                          cursorColor: const Color(0xff30A3E6),
                          focusNode: focus,
                          keyboardType: TextInputType.text,
                          placeholder: "Message",
                          placeholderStyle: TextStyle(
                              color: CupertinoColors.systemGrey3,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: CupertinoColors.white,
                          ),
                        ),
                      ),
                    ),
                    15.getW(),
                    ScaleOnPress(
                      onTap: () async {
                        if (controller.text.isNotEmpty) {
                          if (!context.mounted) return;
                          String controllerTemp = controller.text;
                          controller.clear();
                          messageModel = messageModel.copyWith(
                            messageText: controllerTemp,
                            isEdited: false,
                            idFrom:
                                context.read<UserBloc>().state.userModel.docId,
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
                      child: Container(
                        padding: EdgeInsets.all(7.sp),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: CupertinoColors.systemBlue.withOpacity(.2),
                        ),
                        child: const Icon(
                          CupertinoIcons.paperplane,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (focus.hasFocus) 10.getH(),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
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
