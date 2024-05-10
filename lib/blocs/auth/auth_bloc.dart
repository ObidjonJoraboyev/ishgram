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

  Future<void> _loginUser(LoginUserEvent event1, Emitter emit) async {
    emit(state.copyWith(formStatus: FormStatus.loading));

    try {
      Stream<List<UserModel>> response = FirebaseFirestore.instance
          .collection("users")
          .snapshots()
          .map((event) =>
              event.docs.map((doc) => UserModel.fromJson(doc.data())).toList());

      await emit.onEach(
        response,
        onData: (List<UserModel> event) async {
          for (int i = 0; i < event.length; i++) {
            print("EVENT !${event[i].number}");
            print("EVENT !${event1.number}");

            if (event[i].number == event1.number &&
                event[i].password == event1.password) {
              emit(state.copyWith(formStatus: FormStatus.authenticated));

              await StorageRepository.setString(
                  key: "userNumber", value: "+998${event[i].number}");
              break;
            }else{
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

  _registerUser(RegisterUserEvent event, emit) async {
    emit(state.copyWith(formStatus: FormStatus.loading));

    try {
      var docId = await FirebaseFirestore.instance
          .collection("users")
          .add(event.userModel.toJson());

      await FirebaseFirestore.instance
          .collection("users")
          .doc(docId.id)
          .update({"doc_id": docId.id});

      await StorageRepository.setString(
          key: "userNumber", value: "+998${event.userModel.number}");
      emit(
        state.copyWith(
          formStatus: FormStatus.authenticated,
          userModel: event.userModel,
        ),
      );

      await StorageRepository.setString(
          key: "userNumber", value: "+998${event.userModel.number}");
    } catch (er) {
      emit(
        state.copyWith(
          formStatus: FormStatus.error,
          errorMessage: er.toString(),
        ),
      );
    }
  }

  _logOutUser(LogOutEvent event, emit) async {
    emit(state.copyWith(formStatus: FormStatus.loading));
    await StorageRepository.setString(key: "userNumber", value: "");
    if (!event.context.mounted) return;
    Navigator.pushAndRemoveUntil(
        event.context,
        MaterialPageRoute(builder: (context) => AuthScreen()),
        (route) => false);

    emit(state.copyWith(formStatus: FormStatus.success));
  }
}
