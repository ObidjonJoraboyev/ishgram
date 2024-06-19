import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/blocs/notification/notification_event.dart';
import 'package:ish_top/blocs/notification/notification_state.dart';
import 'package:ish_top/data/local/local_storage.dart';
import 'package:ish_top/data/models/notification_model.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc()
      : super(const NotificationState(
            notifications: [],
            status: StatusOfNotif.pure,
            )) {
    on<NotificationGetEvent>(notifGet);
    on<NotificationUpdateEvent>(notifUpdate);
    on<NotificationDeleteEvent>(notifDelete);
    on<NotificationAddEvent>(notifAdd);
  }

  notifGet(NotificationGetEvent event, emit) async {
    Stream<List<NotificationModel>> streamController = FirebaseFirestore
        .instance
        .collection("notifications")
        .snapshots()
        .map((event) => event.docs
            .map((doc) => NotificationModel.fromJson(doc.data()))
            .toList());
    emit(state.copyWith(status: StatusOfNotif.loading));
    print(StorageRepository.getString(key: "userDoc"));
    StorageRepository.setString(key: "userDoc", value: "O5gsAcT0COW5QKVEAmHN");



    try {
      await emit.onEach<List<NotificationModel>>(streamController,
          onData: (List<NotificationModel> messages) async {
        emit(state.copyWith(
            notifications: messages,
            status: StatusOfNotif.success,
          ));
      }, onError: (c, d) {});
    } catch (error) {
      debugPrint("ERROR CATCHd $error");
    }
  }

  notifUpdate(NotificationUpdateEvent event, emit) async {
    try {
      await FirebaseFirestore.instance
          .collection("notifications")
          .doc(event.notificationModel.docId)
          .update(event.notificationModel.toJson());
    } catch (error) {
      debugPrint("ERROR CATCH $error");
    }
  }

  notifDelete(NotificationDeleteEvent event, emit) async {
    try {
      await FirebaseFirestore.instance
          .collection("notifications")
          .doc(event.docId)
          .delete();
    } catch (error) {
      debugPrint("ERROR CATCH $error");
    }
  }

  notifAdd(NotificationAddEvent event, emit) async {
    try {
      var docId = await FirebaseFirestore.instance
          .collection("notifications")
          .add(event.notificationModel.toJson());
      await FirebaseFirestore.instance
          .collection("notifications")
          .doc(docId.id)
          .update({"docId": docId.id});
    } catch (error) {
      debugPrint("ERROR CATCH $error");
    }
  }
}
