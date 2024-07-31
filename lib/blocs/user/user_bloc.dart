import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/user/user_event.dart';
import 'package:ish_top/blocs/user/user_state.dart';
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
            qrUserModel: UserModel.initial,
            progress: 0)) {
    on<GetCurrentUser>(getCurrentUser);
    on<GetAllUsers>(getAllUsers);
    on<UpdateUser>(updateUser);
    on<UserUpdateProfileUser>(updateProfile);
    on<UserDeleteImage>(imageDelete);
    on<UserRemoveUsername>(deleteUsername);
    on<UserUpdateUsername>(updateUsername);
    on<UserGetWithQr>(getUserQr);
  }

  getUserQr(UserGetWithQr event, Emitter<UserState> emit) async {
    if (event.string == "clear") {
      emit(state.copyWith(qrUserModel: UserModel.initial));
    } else {
      emit(state.copyWith(formStatus: FormStatus.loadingQrGet));
      try {
        Response response = await dio.get(
            "https://ishgram-production.up.railway.app/api/v1/user-by-phone",
            queryParameters: {"phone": event.phoneNumber});

        if (response.statusCode == 200) {
          emit(state.copyWith(
            formStatus: FormStatus.successQr,
            qrUserModel: UserModel.fromJson(response.data),
          ));
        } else {
          emit(state.copyWith(formStatus: FormStatus.errorQr));
        }
      } catch (e) {
        debugPrint(e.toString());
        emit(state.copyWith(formStatus: FormStatus.errorQr));
      }
    }
  }

  imageDelete(UserDeleteImage event, Emitter<UserState> emit) async {
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

  updateProfile(UserUpdateProfileUser event, Emitter<UserState> emit) async {
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
    if (event.userModel != state.userModel) {
      emit(state.copyWith(formStatus: FormStatus.updating));
      Response response = await dio.put(
          "https://ishgram-production.up.railway.app/api/v1/user",
          data: event.userModel.toJsonForUpdate());
      if (response.statusCode == 200) {
        emit(state.copyWith(
            statusMessage: response.data["data"],
            formStatus: FormStatus.success,
            userModel: UserModel.fromJson(response.data["Data"])));
      } else {
        emit(state.copyWith(
            statusMessage: response.data["data"],
            formStatus: FormStatus.error));
      }
    }
  }

  getAllUsers(GetAllUsers event, Emitter<UserState> emit) async {
    emit(state.copyWith(formStatus: FormStatus.loading));
    try {
      Response response = await dio
          .get("https://ishgram-production.up.railway.app/api/v1/users");
      if (response.statusCode == 200) {
        emit(state.copyWith(
            users: (response.data["users"] as List? ?? [])
                .map((e) => UserModel.fromJson(e))
                .toList(),
            formStatus: FormStatus.success));
      } else {
        emit(state.copyWith(formStatus: FormStatus.error));
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(formStatus: FormStatus.error));
    }
  }

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

  deleteUsername(UserRemoveUsername event, Emitter<UserState> emit) async {
    emit(state.copyWith(formStatus: FormStatus.loading));
    try {
      Response response = await dio.patch(
        "https://ishgram-production.up.railway.app/api/v1/user-remove-username/${state.userModel.docId}",
      );
      if (response.statusCode == 200) {
        emit(state.copyWith(
            formStatus: FormStatus.success,
            userModel: UserModel.fromJson(response.data)));
      } else {
        emit(state.copyWith(formStatus: FormStatus.error));
      }
    } catch (b) {
      debugPrint(b.toString());
      emit(state.copyWith(
          statusMessage: b.toString(), formStatus: FormStatus.error));
    }
  }

  updateUsername(UserUpdateUsername event, Emitter<UserState> emit) async {
    emit(state.copyWith(formStatus: FormStatus.loading));
    try {
      Response response = await dio.patch(
        "https://ishgram-production.up.railway.app/api/v1/change-username",
        queryParameters: {
          "username": event.username,
          "user_id": state.userModel.docId
        },
      );
      if (response.statusCode == 200) {
        emit(state.copyWith(
            formStatus: FormStatus.success,
            userModel: UserModel.fromJson(response.data)));
      } else {
        emit(state.copyWith(formStatus: FormStatus.error));
      }
    } catch (o) {
      debugPrint(o.toString());
      emit(state.copyWith(
          statusMessage: o.toString(), formStatus: FormStatus.error));
    }
  }
}
