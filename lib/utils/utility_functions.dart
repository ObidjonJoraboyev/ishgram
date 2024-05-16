import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../blocs/image/image_bloc.dart';
import '../blocs/image/image_event.dart';
import '../data/models/announcement.dart';

Future<void> _getImageFromGallery(BuildContext context,
    {required int limit, required List<ImageModel> images}) async {
  final ImagePicker picker = ImagePicker();

  if (limit != 1) {
    List<XFile>? image = await picker.pickMultiImage(
      limit: limit,
      maxHeight: 1024,
      maxWidth: 1024,
    );
    if (!context.mounted) return;
    context
        .read<ImageBloc>()
        .add(ImageSetEvent(pickedFile: image, images: images));
  } else {
    XFile? image = await picker.pickImage(
      maxHeight: 1024,
      maxWidth: 1024,
      source: ImageSource.gallery,
    );
    if (!context.mounted) return;
    context
        .read<ImageBloc>()
        .add(ImageSetEvent(pickedFile: [image!], images: images));
  }
}

takeAnImage(
  BuildContext context, {
  required int limit,
  required List<ImageModel> images,
}) {
  showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
    context: context,
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 12.h),
          ListTile(
            onTap: () async {
              await _getImageFromGallery(context, limit: limit, images: images);
              // Navigator.pop(context);
            },
            leading: const Icon(Icons.photo_album_outlined),
            title: const Text("Take From Gallery"),
          ),
          SizedBox(height: 24.h),
        ],
      );
    },
  );
}
