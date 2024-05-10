import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ish_top/blocs/image/image_bloc.dart';
import 'package:ish_top/blocs/image/image_event.dart';
import 'package:ish_top/data/models/announcement.dart';
import 'package:ish_top/utils/size/size_utils.dart';

import '../../../blocs/announcement_bloc/hire_bloc.dart';
import '../../../blocs/announcement_bloc/hire_event.dart';

class AddHireScreen extends StatefulWidget {
  const AddHireScreen({super.key});

  @override
  State<AddHireScreen> createState() => _AddHireScreenState();
}

class _AddHireScreenState extends State<AddHireScreen> {
  final TextEditingController nameCtrl = TextEditingController();

  final TextEditingController numberCtrl = TextEditingController();

  final TextEditingController ownerCtrl = TextEditingController();

  final TextEditingController descriptionCtrl = TextEditingController();

  final ImagePicker picker = ImagePicker();

  AnnouncementModel hireModel = AnnouncementModel.initial;
  String imageUrl = "";
  String storagePath = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGrey5,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("add_hire".tr()),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: TextField(
              controller: nameCtrl,
              style: TextStyle(
                  color: Colors.white.withOpacity(.6),
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.end,
              cursorColor: Colors.white,
              cursorWidth: 3,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.white.withOpacity(.6)),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
                  child: Text(
                    "work_name".tr(),
                    style: const TextStyle(
                        shadows: [Shadow(blurRadius: 0.5)],
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 19),
                  ),
                ),
                contentPadding: const EdgeInsets.only(right: 12),
                fillColor: Colors.grey.withOpacity(.9),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0, color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0, color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: TextField(
              controller: descriptionCtrl,
              style: TextStyle(
                  color: Colors.white.withOpacity(.6),
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.end,
              cursorColor: Colors.white,
              cursorWidth: 3,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.white.withOpacity(.6)),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
                  child: Text(
                    "about_work".tr(),
                    style: const TextStyle(
                        shadows: [Shadow(blurRadius: 0.5)],
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 19),
                  ),
                ),
                contentPadding: const EdgeInsets.only(right: 12),
                fillColor: Colors.grey.withOpacity(.9),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0, color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0, color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: TextField(
              controller: ownerCtrl,
              style: TextStyle(
                  color: Colors.white.withOpacity(.6),
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.end,
              cursorColor: Colors.white,
              cursorWidth: 3,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.white.withOpacity(.6)),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
                  child: Text(
                    "your_name".tr(),
                    style: const TextStyle(
                        shadows: [Shadow(blurRadius: 0.5)],
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 19),
                  ),
                ),
                contentPadding: const EdgeInsets.only(right: 12),
                fillColor: Colors.grey.withOpacity(.9),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0, color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0, color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: TextField(
              controller: numberCtrl,
              style: TextStyle(
                  color: Colors.white.withOpacity(.6),
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.end,
              cursorColor: Colors.white,
              cursorWidth: 3,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.white.withOpacity(.6)),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
                  child: Text(
                    "phone_number".tr(),
                    style: const TextStyle(
                        shadows: [Shadow(blurRadius: 0.5)],
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 19),
                  ),
                ),
                contentPadding: const EdgeInsets.only(right: 12),
                fillColor: Colors.grey.withOpacity(.9),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0, color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0, color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          TextButton(
              onPressed: () async {
                context.read<AnnouncementBloc>().add(
                      AnnouncementAddEvent(
                        hireModel: AnnouncementModel(
                            ownerName: ownerCtrl.text,
                            title: nameCtrl.text,
                            docId: "",
                            description: descriptionCtrl.text,
                            money: "",
                            timeInterval: "",
                            image: const [],
                            isActive: false,
                            lat: 1,
                            long: 0,
                            updatedAt: "",
                            countView: 1,
                            createdAt: "",
                            isFavourite: false,
                            number: numberCtrl.text,
                            category: WorkCategory.easy,
                            location: ''),
                      ),
                    );
              },
              child: Text("add".tr())),
          TextButton(
              onPressed: () async {
                takeAnImage();
              },
              child: const Text("Image"))
        ],
      ),
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
      if(!mounted)return;
      context.read<ImageBloc>().add(ImageEvent(
            pickedFile: image,
            storagePath: storagePath,
          ));
      if(!mounted)return;
      imageUrl = context.read<ImageBloc>().state;
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

        if(!mounted)return;
        context.read<ImageBloc>().add(
              ImageEvent(
                pickedFile: i,
                storagePath: storagePath,
              ),
            );
        imageUrl = context.read<ImageBloc>().state;
        images.add(imageUrl);
      }

      setState(() {});
      hireModel = hireModel.copyWith(image: images);
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
                if(!context.mounted)return;
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
