import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/image/formstatus.dart';
import 'package:ish_top/blocs/image/image_state.dart';
import 'image_event.dart';
import 'package:image/image.dart' as img;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ImageBloc extends Bloc<ImageEvent, ImageUploadState> {
  ImageBloc() : super(ImageUploadState.imageUploadState) {
    on<ImageSetEvent>(setImage);
    on<ImageRemoveEvent>(removeImage);
    on<ImageCleanEvent>(cleanImages);
    on<ImageChangeEvent>(changeImage);
    on<ImageMoveEvent>(moveImage);
  }

  changeImage(ImageChangeEvent event, Emitter<ImageUploadState> emit) async {
    emit(state.copyWith(formStatus: FormStatusImage.uploading));
    File file = File(event.changedFile.path);
    Uint8List imageBytes = await file.readAsBytes();
    img.Image? decodedImage = img.decodeImage(imageBytes);
    if (decodedImage == null) {
      emit(state.copyWith(formStatus: FormStatusImage.error));
      return;
    }
    List<int> jpgBytes = img.encodeJpg(decodedImage);
    String newPath = file.path.replaceAll(RegExp(r'\.\w+$'), '.jpg');
    File jpgFile = File(newPath);
    await jpgFile.writeAsBytes(jpgBytes);
    FormData formData = FormData.fromMap({
      'files':
          await MultipartFile.fromFile(jpgFile.path, filename: 'upload.jpg'),
    });
    emit(
      state.copyWith(
        images: [
          ...state.images.where((test) => test != event.deletedUrl),
        ],
      ),
    );
    Response response = await dio.post(
        "https://ishgram-production.up.railway.app/api/v1/announcement-image",
        data: formData, onSendProgress: (sent, total) {
      double progress = sent / total;
      emit(state.copyWith(progress: progress));
    });

    if (response.statusCode == 201) {
      emit(
        state.copyWith(
          formStatus: FormStatusImage.success,
          progress: 0,
          images: [
            ...state.images.where((test) => test != event.deletedUrl),
            response.data["Data"][0]
          ],
        ),
      );
    } else {
      emit(state.copyWith(formStatus: FormStatusImage.error, progress: 0));
    }
  }

  cleanImages(ImageCleanEvent event, Emitter<ImageUploadState> emit) async {
    emit(state.copyWith(images: [], formStatus: FormStatusImage.success));
  }

  setImage(ImageSetEvent event, Emitter<ImageUploadState> emit) async {
    emit(state.copyWith(formStatus: FormStatusImage.uploading));
    try {
      for (int i = 0; i < event.pickedFile.length; i++) {
        File file = File(event.pickedFile[i].path);
        Uint8List imageBytes = await file.readAsBytes();
        img.Image? decodedImage = img.decodeImage(imageBytes);
        if (decodedImage == null) {
          emit(state.copyWith(formStatus: FormStatusImage.error));
          return;
        }
        List<int> jpgBytes = img.encodeJpg(decodedImage);
        String newPath = file.path.replaceAll(RegExp(r'\.\w+$'), '.jpg');
        File jpgFile = File(newPath);
        await jpgFile.writeAsBytes(jpgBytes);
        FormData formData = FormData.fromMap({
          'files': await MultipartFile.fromFile(jpgFile.path,
              filename: 'upload.jpg'),
        });

        Response response = await dio.post(
            "https://ishgram-production.up.railway.app/api/v1/announcement-image",
            data: formData, onSendProgress: (sent, total) {
          double progress = sent / total;
          emit(state.copyWith(progress: progress));
        });

        if (response.statusCode == 201) {
          emit(
            state.copyWith(
              formStatus: FormStatusImage.success,
              progress: 0,
              images: [...state.images, response.data["Data"][0]],
            ),
          );
        } else {
          emit(state.copyWith(formStatus: FormStatusImage.error, progress: 0));
        }
      }
    } on FirebaseException catch (error) {
      debugPrint(error.message);
      emit(state.copyWith(formStatus: FormStatusImage.error));
    }
  }

  removeImage(ImageRemoveEvent event, Emitter<ImageUploadState> emit) async {
    emit(state.copyWith(formStatus: FormStatusImage.uploading));

    List<String> filteredImages =
        state.images.where((image) => image != event.docId).toList();

    emit(
      state.copyWith(
        images: filteredImages,
        formStatus: FormStatusImage.success,
      ),
    );
  }

  moveImage(ImageMoveEvent event, Emitter<ImageUploadState> emit) {
    List<String> movedImages = state.images;
    String temp = movedImages[event.currentIndex];
    movedImages[event.currentIndex] = movedImages[event.wantIndex];
    movedImages[event.wantIndex] = temp;

    emit(state.copyWith(images: movedImages));
  }
}
