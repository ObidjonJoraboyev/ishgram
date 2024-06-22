import 'dart:io';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/notification/notification_event.dart';
import 'package:ish_top/blocs/notification/notification_state.dart';
import 'package:ish_top/data/models/notification_model.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc()
      : super(const NotificationState(
          notifications: [],
          status: StatusOfNotif.pure,
        )) {
    on<NotificationGetEvent>(notifGet, transformer: droppable());
    on<NotificationUpdateEvent>(notifUpdate, transformer: droppable());
    on<NotificationDeleteEvent>(notifDelete, transformer: droppable());
    on<NotificationAddEvent>(notifAdd, transformer: droppable());
    on<NotificationReadAllEvent>(notifRead, transformer: droppable());
  }

  notifGet(NotificationGetEvent event, emit) async {
    //  Stream<List<NotificationModel>> streamController = FirebaseFirestore
    //         .instance
    //         .collection("notifications")
    //         .snapshots()
    //         .map((event) => event.docs
    //             .map((doc) => NotificationModel.fromJson(doc.data()))
    //             .toList());
    //     emit(state.copyWith(status: StatusOfNotif.loading));
    //     try {
    //       await emit.onEach<List<NotificationModel>>(streamController,
    //           onData: (List<NotificationModel> messages) async {
    //         emit(state.copyWith(
    //           notifications: messages,
    //           status: StatusOfNotif.success,
    //         ));
    //       }, onError: (c, d) {});
    //     } catch (error) {
    //       debugPrint("ERROR CATCHd $error");
    //     }

    final dio = Dio();
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        emit(state.copyWith(status: StatusOfNotif.loading));

        return handler.next(options); // continue
      },
      onResponse: (Response response, handler) {

        List<NotificationModel> list = (response.data["notifications"] as List?)
                ?.map((element) =>
                    NotificationModel.fromJson(element as Map<String, dynamic>))
                .toList() ??
            [];

        emit(
            state.copyWith(notifications: list, status: StatusOfNotif.success));
        return handler.next(response); // continue
      },
      onError: (error, handler) {
        emit(state.copyWith(status: StatusOfNotif.error));

        return handler.next(error); // continue
      },
    ));

    try {
      await dio.get(
          "https://notification-api-production.up.railway.app/api/v1/notifications/",
          queryParameters: {
            "user_id": event.context.read<AuthBloc>().state.userModel.docId
          });
    } catch (error) {
      debugPrint("ERROR CATCH $error");
    }
  }

  notifUpdate(NotificationUpdateEvent event, emit) async {
    final dio = Dio();
    print(event.notificationModel.toJsonForUpdate());
    dio.put(
        "https://notification-api-production.up.railway.app/api/v1/notification",
        data: event.notificationModel.toJsonForUpdate(),options: Options(
      followRedirects: false,
      validateStatus: (status) {
        return status! < 500 || status == 307;
      },
    ),);



    //try {
    //       await FirebaseFirestore.instance
    //           .collection("notifications")
    //           .doc(event.notificationModel.docId)
    //           .update(event.notificationModel.toJson());
    //     } catch (error) {
    //       debugPrint("ERROR CATCH $error");
    //     }
  }

  notifRead(NotificationReadAllEvent event, emit) async {
    for (int i = 0; i < event.notifs.length; i++) {
      try {
        await FirebaseFirestore.instance
            .collection("notifications")
            .doc(event.notifs[i].docId)
            .update({"isRead": true});
      } catch (error) {
        debugPrint("ERROR CATCH $error");
      }
    }
  }

  notifDelete(NotificationDeleteEvent event, emit) async {
    try {
      final dio = Dio();
    } catch (er) {}

    // try {
    //       await FirebaseFirestore.instance
    //           .collection("notifications")
    //           .doc(event.docId)
    //           .delete();
    //     } catch (error) {
    //       debugPrint("ERROR CATCH $error");
    //     }
  }

  notifAdd(NotificationAddEvent event, emit) async {
    try {
      emit(state.copyWith(status: StatusOfNotif.loading));
      final dio = Dio();
      Response response = await dio.post(
          "https://notification-api-production.up.railway.app/api/v1/notification",
          data: event.notificationModel.toJson());
      if (response.statusCode == HttpStatus.ok) {
        emit(state.copyWith(status: StatusOfNotif.success));
      } else {
        emit(state.copyWith(status: StatusOfNotif.error));
      }
    } catch (er) {
      emit(state.copyWith(status: StatusOfNotif.error));
      debugPrint(er.toString());
    }

    //  try {
    //       var docId = await FirebaseFirestore.instance
    //           .collection("notifications")
    //           .add(event.notificationModel.toJson());
    //       await FirebaseFirestore.instance
    //           .collection("notifications")
    //           .doc(docId.id)
    //           .update({"docId": docId.id});
    //     } catch (error) {
    //       debugPrint("ERROR CATCH $error");
    //     }
  }
}
