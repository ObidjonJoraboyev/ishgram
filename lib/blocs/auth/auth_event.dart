import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:ish_top/data/models/user_model.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckAuthenticationEvent extends AuthEvent {
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
    required this.password,
  });

  final int password;
  final UserModel userModel;

  @override
  List<Object?> get props => [userModel];
}

class GetCurrentUser extends AuthEvent {}

class GetAllUsers extends AuthEvent {}

class CheckCurrentUser extends AuthEvent {
  final String userNumber;
  CheckCurrentUser({required this.userNumber});
}

class RegisterUpdateEvent extends AuthEvent {
  RegisterUpdateEvent({
    required this.userModel,
    required this.docId,
  });
  final UserModel userModel;
  final String docId;
  @override
  List<Object?> get props => [userModel];
}

class LogOutEvent extends AuthEvent {
  final BuildContext context;
  LogOutEvent({required this.context});
  @override
  List<Object?> get props => [];
}
