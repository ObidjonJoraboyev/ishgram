import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

abstract class UserImageEvent extends Equatable {}

class UserImageSetEvent extends UserImageEvent {
  UserImageSetEvent({
    required this.pickedFile,
  });

  final List<XFile> pickedFile;

  @override
  List<Object?> get props => [pickedFile];
}

class UserImageRemoveEvent extends UserImageEvent {
  UserImageRemoveEvent(this.context, {required this.docId});

  final String docId;
  final BuildContext context;

  @override
  List<Object?> get props => [docId];
}

class UserImageCleanEvent extends UserImageEvent {
  UserImageCleanEvent();

  @override
  List<Object?> get props => [];
}
