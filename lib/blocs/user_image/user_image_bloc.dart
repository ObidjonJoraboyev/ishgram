import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ish_top/blocs/image/formstatus.dart';
import 'package:ish_top/blocs/user_image/user_image_event.dart';
import 'package:ish_top/blocs/user_image/user_image_state.dart';
import 'package:ish_top/data/models/image_model.dart';

class UserImageBloc extends Bloc<UserImageEvent, UserImageUploadState> {
  UserImageBloc() : super(UserImageUploadState.imageUploadState) {
    on<UserImageSetEvent>(setImage);
    on<UserImageRemoveEvent>(removeImage);
    on<UserImageCleanEvent>(cleanImages);
  }

  cleanImages(
      UserImageCleanEvent event, Emitter<UserImageUploadState> emit) async {
    emit(state.copyWith(
        images: ImageModel(imageUrl: "", imageDocId: ''),
        formStatus: FormStatusImage.success));
  }

  setImage(UserImageSetEvent event, Emitter<UserImageUploadState> emit) async {
    emit(state.copyWith(formStatus: FormStatusImage.uploading));
    ImageModel image = ImageModel(imageUrl: "", imageDocId: "");

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

        image = ImageModel(
          imageUrl: downloadUrl,
          imageDocId: "files/images/${pickedFile.name}",
        );
      }

      emit(state.copyWith(images: image, formStatus: FormStatusImage.success));
    } on FirebaseException catch (error) {
      debugPrint(error.message);
      emit(state.copyWith(formStatus: FormStatusImage.error));
    }
  }

  removeImage(
      UserImageRemoveEvent event, Emitter<UserImageUploadState> emit) async {
    emit(state.copyWith(formStatus: FormStatusImage.uploading));

    try {
      await FirebaseStorage.instance.ref(event.docId).delete();
      emit(
        state.copyWith(
          formStatus: FormStatusImage.success,
        ),
      );
    } on FirebaseException catch (error) {
      debugPrint(error.message);
      throw Exception();
    }
  }
}
