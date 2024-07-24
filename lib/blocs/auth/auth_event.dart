import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:ish_top/data/models/user_model.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckCurrentUser extends AuthEvent {
  final String userNumber;

  CheckCurrentUser({required this.userNumber});
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

class LogOutEvent extends AuthEvent {
  final BuildContext context;

  LogOutEvent({required this.context});

  @override
  List<Object?> get props => [];
}

class RegisterUserEvent extends AuthEvent {
  RegisterUserEvent({
    required this.userModel,
  });

  final UserModel userModel;

  @override
  List<Object?> get props => [userModel];
}
