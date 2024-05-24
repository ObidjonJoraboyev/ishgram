import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/data/local/local_storage.dart';
import 'package:ish_top/ui/auth/auth_screen.dart';
import '../../data/forms/form_status.dart';
import '../../data/models/user_model.dart';
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
          ),
        ) {
    on<LoginUserEvent>(_loginUser);
    on<LogOutEvent>(_logOutUser);
    on<RegisterUserEvent>(_registerUser);
  }

  Stream<List<UserModel>> response = FirebaseFirestore.instance
      .collection("users")
      .snapshots()
      .map((event) =>
          event.docs.map((doc) => UserModel.fromJson(doc.data())).toList());

  Future<void> _loginUser(
      LoginUserEvent event1, Emitter<AuthState> emit) async {
    emit(state.copyWith(formStatus: FormStatus.loading));

    try {
      await emit.onEach(
        response,
        onData: (List<UserModel> event) async {
          for (int i = 0; i < event.length; i++) {
            if (event[i].number == event1.number &&
                event[i].password == event1.password) {
              emit(state.copyWith(formStatus: FormStatus.authenticated));

              await StorageRepository.setString(
                  key: "userNumber", value: event[i].number);
              break;
            } else {
              emit(
                state.copyWith(
                  formStatus: FormStatus.error,
                  errorMessage: "Invalid Credentials",
                ),
              );
            }
          }
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          formStatus: FormStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  _registerUser(RegisterUserEvent event1, Emitter emit) async {
    emit(state.copyWith(formStatus: FormStatus.loading));

    List<UserModel> users = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      users = querySnapshot.docs.map((doc) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      debugPrint("Error fetching users: $e");
    }

    for (int i = 0; i < users.length; i++) {
      if (users[i].number == event1.userModel.number) {
        emit(state.copyWith(formStatus: FormStatus.unauthenticated));
        break;
      } else {
        emit(state.copyWith(formStatus: FormStatus.pure));
      }
    }

    if (state.formStatus != FormStatus.unauthenticated) {
      try {
        var docId = await FirebaseFirestore.instance
            .collection("users")
            .add(event1.userModel.toJson());

        await FirebaseFirestore.instance
            .collection("users")
            .doc(docId.id)
            .update({"doc_id": docId.id});

        await StorageRepository.setString(
            key: "userNumber", value: event1.userModel.number);
        emit(
          state.copyWith(
            formStatus: FormStatus.authenticated,
          ),
        );
      } catch (er) {
        emit(
          state.copyWith(
            formStatus: FormStatus.error,
            errorMessage: er.toString(),
          ),
        );
      }
    } else {}
  }

  _logOutUser(LogOutEvent event, emit) async {
    emit(state.copyWith(formStatus: FormStatus.loading));
    await StorageRepository.setString(key: "userNumber", value: "");
    if (!event.context.mounted) return;
    Navigator.pushAndRemoveUntil(
        event.context,
        MaterialPageRoute(
          builder: (context) => const AuthScreen(),
        ),
        (route) => false);

    emit(state.copyWith(formStatus: FormStatus.success));
  }
}
