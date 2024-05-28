import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ish_top/blocs/image/formstatus.dart';
import 'package:ish_top/blocs/image/image_state.dart';
import 'package:ish_top/data/models/image_model.dart';
import 'image_event.dart';

class ImageBloc extends Bloc<ImageEvent, ImageUploadState> {
  ImageBloc() : super(ImageUploadState.imageUploadState) {
    on<ImageSetEvent>(setImage);
    on<ImageRemoveEvent>(removeImage);
    on<ImageCleanEvent>(cleanImages);
  }

  cleanImages(ImageCleanEvent event, Emitter<ImageUploadState> emit) async {
    emit(state.copyWith(images: [], formStatus: FormStatusImage.success));
  }

  setImage(ImageSetEvent event, Emitter<ImageUploadState> emit) async {
    emit(state.copyWith(formStatus: FormStatusImage.uploading));
    List<ImageModel> images = [];

    try {
      for (XFile pickedFile in event.pickedFile) {
        var ref = FirebaseStorage.instance
            .ref()
            .child("files/images/${pickedFile.name}");
        File file = File(pickedFile.path);

        UploadTask uploadTask = ref.putFile(file);
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          double progress =
              (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          emit(state.copyWith(progress: progress));
        }, onError: (dynamic error) {});

        TaskSnapshot taskSnapshot = await uploadTask;

        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        images.add(
          ImageModel(
            imageUrl: downloadUrl,
            imageDocId: "files/images/${pickedFile.name}",
          ),
        );
      }

      List<ImageModel> temp = [...event.images, ...images];
      emit(state.copyWith(images: temp, formStatus: FormStatusImage.success));
    } on FirebaseException catch (error) {
      debugPrint(error.message);
      emit(state.copyWith(formStatus: FormStatusImage.error));
    }
  }

  removeImage(ImageRemoveEvent event, Emitter<ImageUploadState> emit) async {
    emit(state.copyWith(formStatus: FormStatusImage.uploading));

    try {
      await FirebaseStorage.instance.ref(event.docId).delete();

      List<ImageModel> filteredImages = state.images
          .where((image) => image.imageDocId != event.docId)
          .toList();

      emit(
        state.copyWith(
          images: filteredImages,
          formStatus: FormStatusImage.success,
        ),
      );
    } on FirebaseException catch (error) {
      debugPrint(error.message);
      throw Exception();
    }
  }
}
