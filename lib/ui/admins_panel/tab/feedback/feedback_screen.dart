import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ish_top/blocs/message/message_bloc.dart';
import 'package:ish_top/data/local/local_storage.dart';
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
      extendBodyBehindAppBar: true,
      backgroundColor: CupertinoColors.systemGrey5,
      appBar: PreferredSize(
        preferredSize:  Size(double.infinity, 56.h),
        child: Container(
          decoration: const BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(width: 0.5, color: Colors.black),
            ),
          ),
          child:  AppBar(
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
      body: BlocBuilder<MessageBloc, List<MessageModel>>(
        builder: (context, snapshot) {
          list = snapshot
              .where((e) =>
                  (e.idFrom ==
                      StorageRepository.getString(key: "userNumber")))
              .toList();

          if (list.isEmpty) {
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
