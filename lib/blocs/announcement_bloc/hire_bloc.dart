import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/blocs/announcement_bloc/hire_state.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/auth/auth_event.dart';
import 'package:ish_top/data/models/announcement_model.dart';
import 'hire_event.dart';

import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc;

class AnnouncementBloc extends Bloc<HireEvent, AnnounState> {
  AnnouncementBloc() : super(AnnounState(allHires: [], myHires: [])) {
    on<AnnounAddEvent>(addAnnoun);
    on<AnnounListGetEvent>(getAnnounList);
    on<AnnounGetEvent>(getAnnoun);
    on<AnnounRemoveEvent>(deleteAnnoun);
    on<AnnounUpdateEvent>(updateAnnoun);
    on<AnnounInitialEvent>(
      initial,
      transformer: bloc.restartable(),
    );
  }

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  addAnnoun(AnnounAddEvent event, emit) async {
    try {
      var docId = await firebaseFirestore
          .collection("hires")
          .add(event.hireModel.toJson());
      await firebaseFirestore
          .collection("hires")
          .doc(docId.id)
          .update({"doc_id": docId.id});

      if (!event.context.mounted) return;
      event.context.read<AuthBloc>().add(RegisterUpdateEvent(
          userModel: event.userModel
              .copyWith(allHiring: event.userModel.allHiring + [docId.id]),
          docId: ""));
    } catch (error) {
      debugPrint("ERROR CATCH $error");
    }
  }

  getAnnounList(AnnounListGetEvent event, Emitter emit) async {
    List<AnnouncementModel> announs = [];
    try {
      for (int i = 0; i < event.announcementDocs.length; i++) {
        await firebaseFirestore
            .collection("hires")
            .doc(event.announcementDocs[i])
            .get()
            .then((v) {
          announs.add(AnnouncementModel.fromJson(v.data()!));
        });
      }

      emit(state.copyWith(myHires: announs));
    } catch (error) {
      debugPrint("ERROR CATCH $error");
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

  Stream<List<AnnouncementModel>> streamController = FirebaseFirestore.instance
      .collection("hires")
      .snapshots()
      .map((event) => event.docs
          .map((doc) => AnnouncementModel.fromJson(doc.data()))
          .toList());

  getAnnoun(AnnounGetEvent event, Emitter emit) async {
    try {
      await emit.onEach(streamController,
          onData: (List<AnnouncementModel> hires) async {
        hires.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        emit(state.copyWith(allHires: hires));
      }, onError: (c, d) {});
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
