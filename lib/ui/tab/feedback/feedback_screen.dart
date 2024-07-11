import 'dart:io';
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ish_top/blocs/message/message_bloc.dart';
import 'package:ish_top/blocs/message/message_event.dart';
import 'package:ish_top/data/local/local_storage.dart';
import 'package:ish_top/data/models/message_model.dart';
import 'package:ish_top/data/models/user_model.dart';
import 'package:ish_top/ui/tab/announ/widgets/zoom_tap.dart';
import 'package:pull_down_button/pull_down_button.dart';

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

  List<MessageModel> selectMessages = [];
  String userNumber = StorageRepository.getString(key: "userNumber");

  String fcm = "";
  bool check = false;

  final ImagePicker picker = ImagePicker();
  String imageUrl = "";
  String storagePath = "";
  bool bottomVisibility = false;

  List<MessageModel> list = [];

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

  bool isOnline = false;
  String lastOnline = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: 1 == 1,
      backgroundColor: CupertinoColors.systemGrey5,
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
            backgroundColor: CupertinoColors.systemGrey6,
            actions: [
              (selectMessages.isEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: "s" == "h"
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(1000),
                              child: Container(
                                width: 50,
                                height: 50,
                                color: Colors.blue,
                              ))
                          : Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      CupertinoColors.activeBlue
                                          .withOpacity(.6),
                                      CupertinoColors.activeBlue
                                          .withOpacity(.99),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                    child: Icon(
                                  Icons.support,
                                  color: Colors.white,
                                )),
                              ),
                            ),
                    )
                  : IconButton(
                      onPressed: () async {
                        for (var e in selectMessages) {
                          context
                              .read<MessageBloc>()
                              .add(MessageDeleteEvent(docId: e.messageId));
                        }
                        bottomVisibility = false;

                        selectMessages = [];
                        setState(() {});
                      },
                      icon: const Icon(
                        CupertinoIcons.delete,
                        color: Colors.red,
                      ),
                    ))
            ],
            leading: selectMessages.isEmpty
                ? const SizedBox()
                : IconButton(
                    onPressed: () {
                      if (selectMessages.length == list.length) {
                        selectMessages = [];
                        setState(() {});
                      } else {
                        selectMessages = list;
                        setState(() {});
                      }
                    },
                    icon: Icon(
                      selectMessages.length != list.length
                          ? CupertinoIcons.check_mark_circled
                          : CupertinoIcons.check_mark_circled_solid,
                      color: CupertinoColors.activeBlue,
                    ),
                  ),
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  "support".tr(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Text(
                  "Online",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: CupertinoColors.activeBlue,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<MessageBloc, List<MessageModel>>(
        builder: (context, snapshot) {
          list = snapshot
              .where((e) =>
                  (e.idFrom == StorageRepository.getString(key: "userNumber")))
              .toList();

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
                          return PullDownButton(
                              itemBuilder: (context) => [
                                    PullDownMenuItem(
                                      onTap: () {},
                                      title: 'Pin',
                                      icon: CupertinoIcons.pin,
                                    ),
                                    PullDownMenuItem(
                                      title: 'Forward',
                                      subtitle: 'Share in different channel',
                                      onTap: () {},
                                      icon: CupertinoIcons
                                          .arrowshape_turn_up_right,
                                    ),
                                    PullDownMenuItem(
                                      onTap: () {},
                                      title: 'Delete',
                                      isDestructive: true,
                                      icon: CupertinoIcons.delete,
                                    ),
                                  ],
                              buttonBuilder: (context, showMenu) =>
                                  ScaleOnPress(
                                    scaleValue: 0.99,
                                    onLongPressed: showMenu,
                                    child: Row(
                                      mainAxisAlignment: list[index].idTo ==
                                              "ibodulla@gmail.com"
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                      children: [
                                        1 == 1
                                            ? ChatBubble(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 4.h,
                                                    horizontal: 3.w),
                                                clipper: ChatBubbleClipper3(
                                                    type: BubbleType
                                                        .receiverBubble),
                                                child: Text(
                                                  list[index].messageText,
                                                  style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16,
                                                    letterSpacing: 1,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              )
                                            : Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 8),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 2,
                                                      color: selectMessages
                                                              .contains(
                                                                  list[index])
                                                          ? Colors.black
                                                          : Colors.white),
                                                  borderRadius: BorderRadius.only(
                                                      topLeft:
                                                          const Radius.circular(
                                                              12),
                                                      topRight:
                                                          const Radius.circular(
                                                              12),
                                                      bottomRight: list[index]
                                                                  .idTo !=
                                                              widget.userModel
                                                                  .phone
                                                          ? const Radius.circular(
                                                              12)
                                                          : const Radius.circular(
                                                              0),
                                                      bottomLeft: list[index]
                                                                  .idTo ==
                                                              widget.userModel
                                                                  .phone
                                                          ? const Radius.circular(12)
                                                          : const Radius.circular(0)),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.only(
                                                      topLeft:
                                                          const Radius.circular(
                                                              10),
                                                      topRight:
                                                          const Radius.circular(
                                                              10),
                                                      bottomRight: list[index]
                                                                  .idTo !=
                                                              widget.userModel
                                                                  .phone
                                                          ? const Radius.circular(
                                                              10)
                                                          : const Radius.circular(
                                                              0),
                                                      bottomLeft: list[index]
                                                                  .idTo ==
                                                              widget.userModel
                                                                  .phone
                                                          ? const Radius.circular(10)
                                                          : const Radius.circular(0)),
                                                  child: Stack(
                                                    children: [
                                                      Image.network(
                                                        list[index].messageText,
                                                        width: 200,
                                                        height: 200,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      selectMessages.contains(
                                                              list[index])
                                                          ? Container(
                                                              width: 200,
                                                              height: 200,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      .5),
                                                            )
                                                          : const SizedBox()
                                                    ],
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ));
                        },
                      )
                    ],
                  ),
                ),
                Container(
                  color: CupertinoColors.systemGrey5,
                  height: Platform.isIOS ? 75 : null,
                  alignment: Alignment.topCenter,
                  child: Row(
                    children: [
                      Transform.rotate(
                        angle: 45 * (pi / 180),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: IconButton(
                            onPressed: () {
                              takeAnImage();
                            },
                            icon: Icon(
                              Icons.attach_file,
                              size: 26,
                              color: Colors.grey.withOpacity(.8),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 10,
                              left: 0,
                              bottom: 10,
                              right: focus.hasFocus ? 0 : 0),
                          child: SizedBox(
                            height: 35,
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
                                      isSupport: true,
                                      createdTime: DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString(),
                                      messageText: controllerTemp,
                                      messageId: "",
                                      idFrom: StorageRepository.getString(
                                          key: "userNumber"),
                                      idTo: "toSupport",
                                    );

                                    context.read<MessageBloc>().add(
                                        MessageAddEvent(
                                            messages: messageModel));
                                    scrollController.position.animateTo(
                                        scrollController
                                            .position.minScrollExtent,
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.linear);
                                    bottomVisibility = false;
                                  }
                                },
                                icon: const Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Icon(
                                    CupertinoIcons.paperplane,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              clearButtonMode: OverlayVisibilityMode.editing,
                              placeholder: " Message",
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(120),
                                color: Colors.grey.withOpacity(.6),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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

  Future<void> _getImageFromCamera() async {
    XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1024,
      maxWidth: 1024,
    );
    if (image != null && context.mounted) {
      debugPrint("IMAGE PATH:${image.path}");
      storagePath = "files/images/${image.name}";
      if (!mounted) return;

      // contactModel= contactModel.copyWith(imageUrl: imageUrl);

      debugPrint("DOWNLOAD URL:$imageUrl");
    }
  }

  Future<void> _getImageFromGallery() async {
    List<String> images = [];
    List<XFile>? image = await picker.pickMultiImage(
      limit: 4,
      maxHeight: 1024,
      maxWidth: 1024,
    );
    if (image.isNotEmpty && context.mounted) {
      for (var i in image) {
        storagePath = "files/images/${i.name}";

        if (!mounted) return;

        images.add(imageUrl);
      }

      setState(() {});
      debugPrint("DOWNLOAD URL:$imageUrl");
    }
  }

  takeAnImage() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      )),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12.h),
            ListTile(
              onTap: () async {
                await _getImageFromGallery();
                setState(() {});
                // Navigator.pop(context);
              },
              leading: const Icon(Icons.photo_album_outlined),
              title: const Text("Take From Gallery"),
            ),
            ListTile(
              onTap: () async {
                await _getImageFromCamera();
                setState(() {});
                if (!context.mounted) return;
                Navigator.pop(context);
              },
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take From Camera"),
            ),
            SizedBox(height: 24.h),
          ],
        );
      },
    );
  }
}

String formatEpochToDateTime(int epoch) {
  var dateTime = DateTime.fromMillisecondsSinceEpoch(epoch);
  var formatter = DateFormat('dd MMM HH:mm');
  return formatter.format(dateTime);
}
