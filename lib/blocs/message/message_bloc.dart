import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/data/models/message_model.dart';
import 'message_event.dart';

class MessageBloc extends Bloc<MessageEvent, List<MessageModel>> {
  MessageBloc() : super([]) {
    on<MessageGetEvent>(getAllMessages);
    on<MessageAddEvent>(addMessage);
    on<MessageDeleteEvent>(deleteMessage);
  }

  getAllMessages(MessageGetEvent event, Emitter emit) async {
    Stream<List<MessageModel>> streamController = FirebaseFirestore.instance
        .collection("messages")
        .orderBy("created_time", descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map((doc) => MessageModel.fromJson(
                    doc.data(),
                  ))
              .toList(),
        );
    try {
      await emit.onEach(streamController,
          onData: (List<MessageModel> messages) async {
        emit(messages);
      }, onError: (c, d) {});
    } catch (error) {
      debugPrint("ERROR CATCH $error");
    }
  }

  addMessage(MessageAddEvent event, Emitter emit) async {
    try {
      var docId = await FirebaseFirestore.instance
          .collection("messages")
          .add(event.messages.toJson());
      await FirebaseFirestore.instance
          .collection("messages")
          .doc(docId.id)
          .update({"doc_id": docId.id});
    } catch (error) {
      debugPrint("ERROR CATCH $error");
    }
  }

  deleteMessage(MessageDeleteEvent event, Emitter emit) async {
    try {
      await FirebaseFirestore.instance
          .collection("messages")
          .doc(event.docId)
          .delete();
    } on FirebaseException catch (error) {
      debugPrint(
        error.toString(),
      );
    }
  }
}
