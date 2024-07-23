import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/data/models/announ_model.dart';
import 'announ_event.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc;
import 'announ_state.dart';

class AnnounBloc extends Bloc<AnnounEvent, AnnounState> {
  AnnounBloc() : super(AnnounState(allHires: [], myHires: [])) {
    on<AnnounAddEvent>(addAnnoun);
    on<AnnounGetEvent>(getAnnoun);
    on<AnnounRemoveEvent>(deleteAnnoun);
    on<AnnounUpdateEvent>(updateAnnoun);
    on<AnnounGetUserIdEvent>(getAnnounByUserId);
    on<AnnounInitialEvent>(initial, transformer: bloc.restartable());
  }

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  addAnnoun(AnnounAddEvent event, emit) async {
    try {
      Response response = await dio.post(
          "https://ishgram-production.up.railway.app/api/v1/announcement",
          data: event.hireModel.toJsonForPost());
      if (response.statusCode == 201) {
      } else {}
    } on DioException catch (error) {
      debugPrint("ERROR CATCH ADD ANNOUN ${error.response}");
    }
  }

  updateAnnoun(AnnounUpdateEvent event, emit) async {
    try {
      await firebaseFirestore
          .collection("hires")
          .doc(event.hireModel.docId)
          .update(event.hireModel.toJsonForUpdate());
    } catch (error) {
      debugPrint("ERROR CATCH $error");
    }
  }

  getAnnoun(AnnounGetEvent event, Emitter emit) async {
    try {
      Response response = await dio.get(
          "https://ishgram-production.up.railway.app/api/v1/announcements");
      if (response.statusCode == 200) {
        emit(
          state.copyWith(
            allHires: (response.data["announcements"] as List? ?? [])
                .map((e) => AnnounModel.fromJson(e))
                .toList(),
          ),
        );
      } else {}
    } catch (error) {
      debugPrint("ERROR CATCH $error");
    }
  }

  getAnnounByUserId(AnnounGetUserIdEvent event, Emitter emit) async {
    try {
      Response response = await dio.get(
          "https://ishgram-production.up.railway.app/api/v1/announcements-by/${event.userId}");
      if (response.statusCode == 200) {
        emit(
          state.copyWith(
            myHires: (response.data["announcements"] as List? ?? [])
                .map((e) => AnnounModel.fromJson(e))
                .toList(),
          ),
        );
      } else {}
    } catch (error) {
      debugPrint("ERROR CATCH $error");
    }
  }

  deleteAnnoun(AnnounRemoveEvent event, Emitter emit) async {
    try {
      await firebaseFirestore.collection("hires").doc(event.docId).delete();
    } catch (error) {
      debugPrint("ERROR CATCH $error");
    }
  }

  initial(AnnounInitialEvent event, Emitter emit) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
