import 'dart:async';
import 'dart:math';
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

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc()
      : super(
    AuthState(
        errorMessage: "",
        statusMessage: "",
        formStatus: FormStatus.pure,
        userModel: UserModel.initial,
        users: const []),
  ) {
    on<LoginUserEvent>(_loginUser);
    on<LogOutEvent>(_logOutUser);
    on<RegisterUserEvent>(_registerUser);
    on<GetCurrentUser>(_getCurrentUser);
    on<GetAllUsers>(getAllUsers);
    on<CheckCurrentUser>(checkUser);
    on<AuthResetEvent>(toPure);
    on<UpdateUser>(updateUser);
  }

  Dio dio = Dio();

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
      emit(state.copyWith(
          statusMessage: response.data["Data"], formStatus: FormStatus.error));
    }
  }

  Future<void> _loginUser(LoginUserEvent event1,
      Emitter<AuthState> emit) async {
    emit(state.copyWith(formStatus: FormStatus.loading));
  }

  _getCurrentUser(GetCurrentUser event, Emitter<AuthState> emit) async {}

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
      if (response.statusCode == 200) {
        emit(state.copyWith(
            statusMessage: "success", formStatus: FormStatus.success));
      } else {
        emit(state.copyWith(
            statusMessage: "success", formStatus: FormStatus.error));
      }
    } catch (o) {
      debugPrint(o.toString());
    }
  }

  _logOutUser(LogOutEvent event, emit) async {
    emit(state.copyWith(formStatus: FormStatus.loading));
    await StorageRepository.setString(key: "userNumber", value: "");
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

  getAllUsers(GetAllUsers event, Emitter<AuthState> emit) async {



  }

  toPure(AuthResetEvent event, Emitter<AuthState> emit) {
    emit(state.copyWith(
        formStatus: FormStatus.pure,
        statusMessage: "",
        errorMessage: "",
        userModel: UserModel.initial,
        users: []));
  }
}

int getRandomNumber(int max) {
  Random random = Random();
  return random.nextInt(max);
}
