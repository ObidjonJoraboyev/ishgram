import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/data/local/local_storage.dart';
import '../../data/forms/form_status.dart';
import '../../data/models/network_response.dart';
import '../../data/models/user_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  //final AuthRepository authRepository;

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

    NetworkResponse networkResponse = NetworkResponse();

    try {
      Stream<List<UserModel>> response = FirebaseFirestore.instance
          .collection("users")
          .snapshots()
          .map((event) =>
              event.docs.map((doc) => UserModel.fromJson(doc.data())).toList());

      await emit.onEach(
        response,
        onData: (List<UserModel> event) {
          for (int i = 0; i < event.length; i++) {
            if (event[i].number == event1.number &&
                event[i].password == event1.password) {
              emit(state.copyWith(formStatus: FormStatus.authenticated));
              break;
            }
          }
        },
      );
    } catch (e) {
      networkResponse.errorText = e.toString();
    }

    if (networkResponse.errorText.isNotEmpty &&
        state.formStatus != FormStatus.authenticated) {
      emit(
        state.copyWith(
          formStatus: FormStatus.error,
          errorMessage: networkResponse.errorText,
        ),
      );
    }
  }

  _registerUser(RegisterUserEvent event, emit) async {
    emit(state.copyWith(formStatus: FormStatus.loading));

    NetworkResponse networkResponse = NetworkResponse();

    var docId = await FirebaseFirestore.instance
        .collection("users")
        .add(event.userModel.toJson());

    await FirebaseFirestore.instance
        .collection("users")
        .doc(docId.id)
        .update({"doc_id": docId.id});
    if (networkResponse.errorText.isEmpty) {
      emit(
        state.copyWith(
          formStatus: FormStatus.authenticated,
          statusMessage: "registered",
          userModel: event.userModel,
        ),
      );
    } else {
      emit(
        state.copyWith(
          formStatus: FormStatus.error,
          errorMessage: networkResponse.errorText,
        ),
      );
    }
  }

  _logOutUser(LogOutEvent event, emit) async {
    emit(state.copyWith(formStatus: FormStatus.loading));
    await StorageRepository.setString(key: "userNumber", value: "");
    emit(state.copyWith(formStatus: FormStatus.success));
  }
}
