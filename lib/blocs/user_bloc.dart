import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/user_event.dart';
import 'package:ish_top/blocs/user_state.dart';
import 'package:ish_top/data/forms/form_status.dart';
import 'package:ish_top/data/models/user_model.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ish_top/data/local/local_storage.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc()
      : super(UserState(
            errorMessage: '',
            formStatus: FormStatus.pure,
            userModel: UserModel.initial,
            statusMessage: "",
            users: const [],
            progress: 0)) {
    on<GetCurrentUser>(getCurrentUser);
    on<GetAllUsers>(getAllUsers);
    on<UpdateUser>(updateUser);
    on<AuthUpdateProfileUser>(updateProfile);
    on<AuthDeleteImage>(imageDelete);
  }

  imageDelete(AuthDeleteImage event, Emitter<UserState> emit) async {
    try {
      Response response = await dio.delete(
          "https://ishgram-production.up.railway.app/api/v1/user-image/${StorageRepository.getString(key: "userId")}");

      if (response.statusCode == 200) {
        emit(state.copyWith(
          formStatus: FormStatus.success,
          userModel: UserModel.fromJson(response.data),
        ));
      } else {
        emit(state.copyWith(formStatus: FormStatus.errorImage));
      }
    } catch (o) {
      debugPrint(o.toString());
    }
  }

  updateProfile(AuthUpdateProfileUser event, Emitter<UserState> emit) async {
    emit(state.copyWith(formStatus: FormStatus.uploadingImage));
    try {
      File file = File(event.pickedFile.path);
      Uint8List imageBytes = await file.readAsBytes();
      img.Image? decodedImage = img.decodeImage(imageBytes);
      if (decodedImage == null) {
        emit(state.copyWith(formStatus: FormStatus.error));
        return;
      }
      List<int> jpgBytes = img.encodeJpg(decodedImage);
      String newPath = file.path.replaceAll(RegExp(r'\.\w+$'), '.jpg');
      File jpgFile = File(newPath);
      await jpgFile.writeAsBytes(jpgBytes);
      FormData formData = FormData.fromMap({
        'file':
            await MultipartFile.fromFile(jpgFile.path, filename: 'upload.jpg'),
      });

      String userId = StorageRepository.getString(key: "userId");

      Response response = await dio.patch(
          "https://ishgram-production.up.railway.app/api/v1/user-photo/$userId",
          data: formData, onSendProgress: (sent, total) {
        double progress = sent / total;
        emit(state.copyWith(progress: progress));
      });

      if (response.statusCode == 200) {
        emit(state.copyWith(
            formStatus: FormStatus.successImage,
            userModel: UserModel.fromJson(response.data),
            progress: 0));
      } else {
        emit(state.copyWith(formStatus: FormStatus.error, progress: 0));
      }
    } catch (error) {
      debugPrint(error.toString());
      emit(state.copyWith(formStatus: FormStatus.errorImage, progress: 0));
    }
  }

  updateUser(UpdateUser event, Emitter<UserState> emit) async {
    emit(state.copyWith(formStatus: FormStatus.loading));
    Response response = await dio.put(
        "https://ishgram-production.up.railway.app/api/v1/user",
        data: event.userModel.toJsonForUpdate());
    if (response.statusCode == 200) {
      emit(state.copyWith(
          statusMessage: response.data["data"],
          formStatus: FormStatus.success));
    } else {
      emit(state.copyWith(
          statusMessage: response.data["data"], formStatus: FormStatus.error));
    }
  }

  getAllUsers(GetAllUsers event, Emitter<UserState> emit) async {}

  getCurrentUser(GetCurrentUser event, Emitter<UserState> emit) async {
    emit(state.copyWith(formStatus: FormStatus.loading));
    try {
      Response response = await dio.get(
        "https://ishgram-production.up.railway.app/api/v1/user/${StorageRepository.getString(key: "userId")}",
      );
      if (response.statusCode == 200) {
        emit(state.copyWith(
            userModel: UserModel.fromJson(response.data),
            statusMessage: "got user",
            formStatus: FormStatus.success));
      } else {
        emit(state.copyWith(
            statusMessage: "not got user", formStatus: FormStatus.error));
      }
    } catch (o) {
      emit(state.copyWith(
          statusMessage: "not got user", formStatus: FormStatus.error));
    }
  }
}
