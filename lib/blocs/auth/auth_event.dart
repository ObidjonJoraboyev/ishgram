import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ish_top/data/models/user_model.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckAuthenticationEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class AuthResetEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class LoginUserEvent extends AuthEvent {
  LoginUserEvent({required this.number, required this.password});

  final String number;
  final String password;

  @override
  List<Object?> get props => [number, password];
}

class RegisterUserEvent extends AuthEvent {
  RegisterUserEvent({
    required this.userModel,
  });

  final UserModel userModel;

  @override
  List<Object?> get props => [userModel];
}

class GetCurrentUser extends AuthEvent {}

class GetAllUsers extends AuthEvent {}

class UpdateUser extends AuthEvent {
  final UserModel userModel;

  UpdateUser({required this.userModel});
}

class CheckCurrentUser extends AuthEvent {
  final String userNumber;

  CheckCurrentUser({required this.userNumber});
}

class LogOutEvent extends AuthEvent {
  final BuildContext context;

  LogOutEvent({required this.context});

  @override
  List<Object?> get props => [];
}

class AuthUpdateProfileUser extends AuthEvent {
  AuthUpdateProfileUser({
    required this.pickedFile,
  });

  final XFile pickedFile;
}

class AuthDeleteImage extends AuthEvent {}
