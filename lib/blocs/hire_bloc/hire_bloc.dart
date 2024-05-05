import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/data/models/hire_model.dart';

import 'hire_event.dart';
import 'hire_state.dart';

class HireBloc extends Bloc<HireEvent, HireState> {
  HireBloc() : super(HireInitial()) {
    on<HireAddEvent>(addHire);
    on<HireGetEvent>(getHires);
    on<HireRemoveEvent>(deleteHires);
  }

  addHire(HireAddEvent event, emit) async {
    emit(HireLoadingState());

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

  Stream<List<HireModel>> streamController = FirebaseFirestore.instance
      .collection("hires")
      .snapshots()
      .map(
        (event) =>
            event.docs.map((doc) => HireModel.fromJson(doc.data())).toList(),
      );

  getHires(HireGetEvent event, Emitter emit) async {
    emit(HireLoadingState());
    try {
      await emit.onEach(streamController,
          onData: (List<HireModel> hires) async {
        emit(HireGetState(hires: hires));
      }, onError: (c, d) {});
    } catch (error) {
      debugPrint("ERROR CATCH $error");
    }
  }

  deleteHires(HireRemoveEvent event, Emitter emit) async {
    emit(HireLoadingState());
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
