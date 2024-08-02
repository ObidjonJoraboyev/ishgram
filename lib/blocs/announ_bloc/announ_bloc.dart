import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/data/forms/form_status.dart';
import 'package:ish_top/data/models/announ_model.dart';
import 'announ_event.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc;
import 'announ_state.dart';

class AnnounBloc extends Bloc<AnnounEvent, AnnounState> {
  AnnounBloc()
      : super(AnnounState(
          allHires: [],
          myHires: [],
          status: FormStatus.pure,
          qrHires: [],
        )) {
    on<AnnounAddEvent>(addAnnoun);
    on<AnnounGetEvent>(getAnnoun);
    on<AnnounRemoveEvent>(deleteAnnoun);
    on<AnnounUpdateEvent>(updateAnnoun);
    on<AnnounGetQREvent>(announGetQr);
    on<AnnounGetUserIdEvent>(getAnnounByUserId);
    on<AnnounInitialEvent>(initial, transformer: bloc.restartable());
  }

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  addAnnoun(AnnounAddEvent event, emit) async {
    debugPrint("adding announ");
    emit(state.copyWith(status: FormStatus.loading));
    try {
      Response response = await dio.post(
          "https://ishgram-production.up.railway.app/api/v1/announcement",
          data: event.hireModel.toJsonForPost());
      if (response.statusCode == 201) {
        emit(state.copyWith(status: FormStatus.success));
      } else {
        emit(state.copyWith(status: FormStatus.error));
      }
    } on DioException catch (error) {
      emit(state.copyWith(status: FormStatus.error));

      debugPrint("ERROR CATCH ADD ANNOUN ${error.response}");
    }
  }

  updateAnnoun(AnnounUpdateEvent event, emit) async {
    debugPrint("updating announ");
  }

  getAnnoun(AnnounGetEvent event, Emitter emit) async {
    debugPrint("getting announ");

    emit(state.copyWith(status: FormStatus.loading));

    try {
      Response response = await dio.get(
          "https://ishgram-production.up.railway.app/api/v1/announcements");
      if (response.statusCode == 200) {
        emit(
          state.copyWith(
              allHires: (response.data["announcements"] as List? ?? [])
                  .map((e) => AnnounModel.fromJson(e))
                  .toList(),
              status: FormStatus.success),
        );
      } else {
        emit(state.copyWith(status: FormStatus.error));
      }
    } catch (error) {
      emit(state.copyWith(status: FormStatus.error));

      debugPrint("ERROR CATCH $error");
    }
  }

  getAnnounByUserId(AnnounGetUserIdEvent event, Emitter emit) async {
    debugPrint("getting by userid announ");

    emit(state.copyWith(status: FormStatus.loading));

    try {
      Response response = await dio.get(
          "https://ishgram-production.up.railway.app/api/v1/announcements-by/${event.userId}");
      if (response.statusCode == 200) {
        emit(
          state.copyWith(
              myHires: (response.data["announcements"] as List? ?? [])
                  .map((e) => AnnounModel.fromJson(e))
                  .toList(),
              status: FormStatus.success),
        );
      } else {
        emit(state.copyWith(status: FormStatus.error));
      }
    } catch (error) {
      emit(state.copyWith(status: FormStatus.error));

      debugPrint("ERROR CATCH $error");
    }
  }

  announGetQr(AnnounGetQREvent event, Emitter emit) async {
    debugPrint("get announ with QR");

    emit(state.copyWith(status: FormStatus.loadingQrGet));

    try {
      Response response = await dio.get(
          "https://ishgram-production.up.railway.app/api/v1/announcements-by/${event.userIdQr}");
      if (response.statusCode == 200) {
        emit(
          state.copyWith(
              qrHires: (response.data["announcements"] as List? ?? [])
                  .map((e) => AnnounModel.fromJson(e))
                  .toList(),
              status: FormStatus.successQr),
        );
      } else {
        emit(state.copyWith(status: FormStatus.errorQr));
      }
    } catch (error) {
      emit(state.copyWith(status: FormStatus.errorQr));

      debugPrint("ERROR CATCH $error");
    }
  }

  deleteAnnoun(AnnounRemoveEvent event, Emitter emit) async {
    debugPrint("deleting announ");

    emit(state.copyWith(status: FormStatus.loading));
    try {
      Response response = await dio.delete(
          "https://ishgram-production.up.railway.app/api/v1/announcement/${event.docId}");
      if (response.statusCode == 200) {
        emit(
          state.copyWith(
            status: FormStatus.success,
            myHires: (response.data["announcements"] as List? ?? [])
                .map((toElement) => AnnounModel.fromJson(toElement))
                .toList(),
          ),
        );
      } else {
        emit(state.copyWith(status: FormStatus.error));
      }
    } catch (error) {
      emit(state.copyWith(status: FormStatus.error));
      debugPrint("ERROR CATCH $error");
    }
  }

  initial(AnnounInitialEvent event, Emitter emit) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
