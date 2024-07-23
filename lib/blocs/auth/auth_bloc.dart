import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/data/forms/form_status.dart';
import 'package:ish_top/data/local/local_storage.dart';
import 'package:ish_top/data/models/user_model.dart';
import 'package:ish_top/ui/auth/register/get_number.dart';
import 'package:ish_top/utils/utility_functions.dart';
import 'auth_event.dart';
import 'auth_state.dart';

Dio dio = Dio();

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc()
      : super(
          AuthState(
              errorMessage: "",
              statusMessage: "",
              formStatus: FormStatus.pure,
              userModel: UserModel.initial,
              users: const [],
              progress: 0),
        ) {
    on<LoginUserEvent>(_loginUser);
    on<LogOutEvent>(_logOutUser);
    on<RegisterUserEvent>(_registerUser);
    on<GetCurrentUser>(_getCurrentUser);
    on<GetAllUsers>(getAllUsers);
    on<CheckCurrentUser>(checkUser);
    on<AuthResetEvent>(toPure);
    on<UpdateUser>(updateUser);
    on<AuthUpdateProfileUser>(updateProfile);
    on<AuthDeleteImage>(imageDelete);
  }

  imageDelete(AuthDeleteImage event, Emitter<AuthState> emit) async {
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

  updateProfile(AuthUpdateProfileUser event, Emitter<AuthState> emit) async {
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

  updateUser(UpdateUser event, Emitter<AuthState> emit) async {
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

  checkUser(CheckCurrentUser event, Emitter<AuthState> emit) async {
    emit(state.copyWith(formStatus: FormStatus.loading));
    Response response = await dio.post(
        "https://ishgram-production.up.railway.app/api/auth/register",
        data: {"Phone": replaceString(event.userNumber)});
    if (response.statusCode == 200) {
      emit(state.copyWith(
          statusMessage: response.data["Data"],
          formStatus: FormStatus.success));
    } else {
      emit(
          state.copyWith(statusMessage: "error", formStatus: FormStatus.error));
    }
  }

  Future<void> _loginUser(
      LoginUserEvent event1, Emitter<AuthState> emit) async {
    emit(state.copyWith(formStatus: FormStatus.loading));
    try {
      Response response = await dio.post(
          "https://ishgram-production.up.railway.app/api/auth/login",
          data: {"password": event1.password, "phone": event1.number});
      if (response.statusCode == 200) {
        StorageRepository.setString(
            key: "access_token", value: response.data["Data"]["access_token"]);
        StorageRepository.setString(
            key: "refresh_token",
            value: response.data["Data"]["refresh_token"]);
        StorageRepository.setString(key: "userNum", value: event1.number);
        StorageRepository.setString(
            key: "userId", value: response.data["Data"]["user"]["id"]);
        emit(state.copyWith(
            statusMessage: "Signed up", formStatus: FormStatus.success));
      }
    } on DioException catch (o) {
      if (o.response?.statusCode == 401) {
        emit(state.copyWith(
            statusMessage: "does not match", formStatus: FormStatus.error));
      }
    }
  }

  _getCurrentUser(GetCurrentUser event, Emitter<AuthState> emit) async {
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

  _registerUser(RegisterUserEvent event1, Emitter emit) async {
    emit(state.copyWith(formStatus: FormStatus.loading));
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.grey,
      Colors.pink,
      CupertinoColors.systemYellow,
      CupertinoColors.activeOrange,
      Colors.purpleAccent
    ];
    try {
      Response response = await dio.post(
          "https://ishgram-production.up.railway.app/api/v1/user",
          data: event1.userModel
              .copyWith(color: colors[getRandomNumber(7)].value.toString())
              .toJsonForApi());
      if (response.statusCode == 201) {
        StorageRepository.setString(key: "userId", value: response.data["id"]);
        emit(state.copyWith(
            statusMessage: "success", formStatus: FormStatus.success));
      } else {
        emit(state.copyWith(
            statusMessage: "error", formStatus: FormStatus.error));
      }
    } catch (o) {
      debugPrint(o.toString());
    }
  }

  _logOutUser(LogOutEvent event, emit) async {
    emit(state.copyWith(formStatus: FormStatus.loading));
    await StorageRepository.setString(key: "userNum", value: "");
    await StorageRepository.setString(key: "userDoc", value: "");
    if (!event.context.mounted) return;
    Navigator.pushAndRemoveUntil(
      event.context,
      MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      ),
      (Route<dynamic> route) => false,
    );

    emit(state.copyWith(formStatus: FormStatus.success));
  }

  getAllUsers(GetAllUsers event, Emitter<AuthState> emit) async {}

  toPure(AuthResetEvent event, Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        formStatus: FormStatus.pure,
        statusMessage: "",
        errorMessage: "",
        userModel: UserModel.initial,
        users: [],
      ),
    );
  }
}

int getRandomNumber(int max) {
  Random random = Random();
  return random.nextInt(max);
}
