import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/blocs/image/image_state.dart';
import 'package:ish_top/data/models/announcement.dart';

import 'image_event.dart';

class ImageBloc extends Bloc<ImageEvent, ImageUploadState> {
  ImageBloc() : super(ImageUploadState.imageUploadState) {
    on<ImageEvent>(setImage);
  }

  setImage(ImageEvent event, Emitter<ImageUploadState> emit) async {
    emit(state.copyWith(formStatus: FormStatus.uploading));

    try {
      List<ImageModel> images = [];
      for (int i = 0; i < event.pickedFile.length; i++) {
        var ref = FirebaseStorage.instance
            .ref()
            .child("files/images/${event.pickedFile[i].name}");
        File file = File(event.pickedFile[i].path);
        var uploadTask = await ref.putFile(file);
        await uploadTask.ref.getDownloadURL().then((downloadUrl) {
          images.add(ImageModel(
              imageUrl: downloadUrl,
              imageDocId: "files/images/${event.pickedFile[i].name}"));
        });
      }
      emit(state.copyWith(images: images, formStatus: FormStatus.success));
    } on FirebaseException catch (error) {
      debugPrint(error.message);
      throw Exception();
    }
  }
}
