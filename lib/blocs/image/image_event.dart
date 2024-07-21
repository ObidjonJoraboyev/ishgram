import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

abstract class ImageEvent extends Equatable {}

class ImageSetEvent extends ImageEvent {
  ImageSetEvent({
    required this.pickedFile,
    required this.images,
  });

  final List<XFile> pickedFile;
  final List<String> images;

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

class ImageMoveEvent extends ImageEvent {
  ImageMoveEvent({
    required this.currentIndex,
    required this.wantIndex,
  });

  final int currentIndex;
  final int wantIndex;

  @override
  List<Object?> get props => [];
}

class ImageChangeEvent extends ImageEvent {
  final String deletedUrl;
  final XFile changedFile;

  ImageChangeEvent({required this.deletedUrl, required this.changedFile});

  @override
  List<Object?> get props => [];
}
