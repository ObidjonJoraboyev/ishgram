import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ish_top/data/models/image_model.dart';

abstract class ImageEvent extends Equatable {}

class ImageSetEvent extends ImageEvent {
  ImageSetEvent({
    required this.pickedFile,
    required this.images,
  });

  final List<XFile> pickedFile;
  final List<ImageModel> images;

  @override
  List<Object?> get props => [pickedFile];
}

class ImageRemoveEvent extends ImageEvent {
  ImageRemoveEvent(this.context, {required this.docId});

  final String docId;
  final BuildContext context;

  @override
  List<Object?> get props => [docId];
}

class ImageCleanEvent extends ImageEvent {
  ImageCleanEvent();

  @override
  List<Object?> get props => [];
}
