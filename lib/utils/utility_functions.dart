import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    Navigator.pop(context);

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

    Navigator.pop(context);

    context
        .read<ImageBloc>()
        .add(ImageSetEvent(pickedFile: [image!], images: images));
  }
}

Future<void> _getImageFromCamera(BuildContext context,
    {required List<ImageModel> images}) async {
  final ImagePicker picker = ImagePicker();

  XFile? image = await picker.pickImage(
    source: ImageSource.camera,
    maxHeight: 1024,
    maxWidth: 1024,
  );
  if (!context.mounted) return;
  Navigator.pop(context);

  context
      .read<ImageBloc>()
      .add(ImageSetEvent(pickedFile: [image!], images: images));
}

void takeAnImage(
  BuildContext context, {
  required int limit,
  required List<ImageModel> images,
}) {
  showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return CupertinoActionSheet(
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
          },
          child: Text(
            "cancel".tr(),
            style: const TextStyle(color: CupertinoColors.activeBlue),
          ),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              await _getImageFromCamera(context, images: images);
            },
            child: Text(
              "takeCamera".tr(),
              style: const TextStyle(color: CupertinoColors.activeBlue),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              await _getImageFromGallery(context, images: images, limit: limit);
            },
            child: Text(
              "takeGallery".tr(),
              style: const TextStyle(color: CupertinoColors.activeBlue),
            ),
          ),
        ],
      );
    },
  );
}
