import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/data/forms/form_status.dart';
import 'package:ish_top/data/local/local_storage.dart';
import 'package:ish_top/data/models/user_model.dart';
import 'package:ish_top/ui/auth/auth_screen.dart';
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
    on<RegisterUpdateEvent>(_registerUpdateUser);
    on<GetCurrentUser>(_getCurrentUser);
    on<GetAllUsers>(getAllUsers);
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
        onData: (List<UserModel> users) async {
          for (int i = 0; i < users.length; i++) {
            if (users[i].phone == event1.number &&
                users[i].password == event1.password) {
              emit(state.copyWith(formStatus: FormStatus.authenticated));

              StorageRepository.setString(
                  key: "userNumber", value: users[i].phone);
              StorageRepository.setString(
                  key: "userDoc", value: users[i].docId);
              break;
            } else {
              emit(
                state.copyWith(
                  formStatus: FormStatus.notExist,
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

  _getCurrentUser(GetCurrentUser event, Emitter<AuthState> emit) async {
    emit(state.copyWith(formStatus: FormStatus.loading));
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(StorageRepository.getString(key: "userDoc"))
          .get()
          .then((doc) async {
        emit(state.copyWith(
          formStatus: FormStatus.authenticated,
          userModel: UserModel.fromJson(doc.data()!),
        ));
      });
    } catch (e) {
      emit(
        state.copyWith(
          formStatus: FormStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  _registerUpdateUser(
      RegisterUpdateEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(formStatus: FormStatus.loading));
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(event.userModel.docId)
          .update(event.userModel.toJsonForUpdate());
      emit(state.copyWith(formStatus: FormStatus.authenticated));
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
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.grey,
      Colors.pink,
      Colors.yellow,
      Colors.orange,
      Colors.purpleAccent
    ];
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
      if (users[i].phone == event1.userModel.phone) {
        emit(state.copyWith(formStatus: FormStatus.exist));
        break;
      } else {
        emit(state.copyWith(formStatus: FormStatus.loading));
      }
    }

    if (state.formStatus != FormStatus.exist &&
        event1.password == int.parse(event1.userModel.password)) {
      try {
        var docId = await FirebaseFirestore.instance
            .collection("users")
            .add(event1.userModel.toJson());

        await FirebaseFirestore.instance
            .collection("users")
            .doc(docId.id)
            .update({
          "doc_id": docId.id,
          "color": colors[Random().nextInt(7)].value.toString()
        });

        StorageRepository.setString(
            key: "userNumber", value: event1.userModel.phone);
        StorageRepository.setString(key: "userDoc", value: docId.id);

        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(docId.id)
            .get();
        UserModel userModel =
            UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
        emit(
          state.copyWith(
              formStatus: FormStatus.firstAuth, userModel: userModel),
        );
      } catch (er) {
        emit(
          state.copyWith(
            formStatus: FormStatus.error,
            errorMessage: er.toString(),
          ),
        );
      }
    } else {
      emit(state.copyWith(formStatus: FormStatus.error));
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
        builder: (context) => const AuthScreen(),
      ),
      (Route<dynamic> route) => false,
    );

    emit(state.copyWith(formStatus: FormStatus.success));
  }

  getAllUsers(GetAllUsers event, Emitter<AuthState> emit) async {
    emit(state.copyWith(formStatus: FormStatus.loading));

    await emit.onEach(response, onData: (List<UserModel> users) {
      emit(state.copyWith(users: users, formStatus: FormStatus.success));
    });
  }
}
