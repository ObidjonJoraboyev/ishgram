import 'package:equatable/equatable.dart';
import 'package:ish_top/data/forms/form_status.dart';
import 'package:ish_top/data/models/user_model.dart';

class AuthState extends Equatable {
  const AuthState(
      {required this.errorMessage,
      required this.statusMessage,
      required this.formStatus,
      required this.userModel,
      required this.users});

  final String errorMessage;
  final String statusMessage;
  final FormStatus formStatus;
  final UserModel userModel;
  final List<UserModel> users;

  AuthState copyWith({
    String? errorMessage,
    String? statusMessage,
    FormStatus? formStatus,
    UserModel? userModel,
    List<UserModel>? users,
  }) {
    return AuthState(
      errorMessage: errorMessage ?? this.errorMessage,
      statusMessage: statusMessage ?? this.statusMessage,
      formStatus: formStatus ?? this.formStatus,
      userModel: userModel ?? this.userModel,
      users: users ?? this.users,
    );
  }

  @override
  List<Object?> get props => [
        errorMessage,
        statusMessage,
        formStatus,
        userModel,
        users,
      ];
}
