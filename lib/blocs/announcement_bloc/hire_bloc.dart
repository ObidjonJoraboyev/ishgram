import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/data/models/announcement.dart';
import 'hire_event.dart';

class AnnouncementBloc extends Bloc<HireEvent, List<AnnouncementModel>> {
  AnnouncementBloc() : super([]) {
    on<AnnouncementAddEvent>(addAnnouncement);
    on<AnnouncementGetEvent>(getAnnouncements);
    on<AnnouncementRemoveEvent>(deleteAnnouncements);
    on<AnnouncementUpdateEvent>(updateAnnouncement);
  }

  addAnnouncement(AnnouncementAddEvent event, emit) async {
    try {
      var docId = await FirebaseFirestore.instance
          .collection("hires")
          .add(event.hireModel.toJson());
      await FirebaseFirestore.instance
          .collection("hires")
          .doc(docId.id)
          .update({"doc_id": docId.id});
    } catch (error) {
      debugPrint("ERROR CATCH $error");
    }
  }
  updateAnnouncement(AnnouncementUpdateEvent event, emit) async {
    try {
       await FirebaseFirestore.instance
          .collection("hires")
          .doc(event.hireModel.docId).update(event.hireModel.toJsonForUpdate());
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

  getAnnouncements(AnnouncementGetEvent event, Emitter emit) async {
    try {
      await emit.onEach(streamController,
          onData: (List<AnnouncementModel> hires) async {
        hires.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        emit(hires);
      }, onError: (c, d) {});
    } catch (error) {
      debugPrint("ERROR CATCH $error");
    }
  }

  deleteAnnouncements(AnnouncementRemoveEvent event, Emitter emit) async {
    try {
      await FirebaseFirestore.instance
          .collection("hires")
          .doc(event.docId)
          .delete();
    } catch (error) {
      debugPrint("ERROR CATCH $error");
    }
  }
}
