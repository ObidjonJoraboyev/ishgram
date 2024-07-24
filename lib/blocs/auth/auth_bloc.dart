import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/data/forms/form_status.dart';
import 'package:ish_top/data/local/local_storage.dart';
import 'package:ish_top/ui/auth/register/get_number.dart';
import 'package:ish_top/utils/utility_functions.dart';
import 'auth_event.dart';
import 'auth_state.dart';

Dio dio = Dio();

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc()
      : super(
          const AuthState(
            errorMessage: "",
            statusMessage: "",
            formStatus: FormStatus.pure,
          ),
        ) {
    on<LoginUserEvent>(loginUser);
    on<LogOutEvent>(logOutUser);
    on<RegisterUserEvent>(registerUser);
    on<CheckCurrentUser>(checkUser);
    on<AuthResetEvent>(toPure);
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

  registerUser(RegisterUserEvent event1, Emitter emit) async {
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

  logOutUser(LogOutEvent event, emit) async {
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

  loginUser(LoginUserEvent event1, Emitter<AuthState> emit) async {
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

  toPure(AuthResetEvent event, Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        formStatus: FormStatus.pure,
        statusMessage: "",
        errorMessage: "",
      ),
    );
  }
}

int getRandomNumber(int max) {
  Random random = Random();
  return random.nextInt(max);
}
