import 'dart:io';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
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
    on<NotificationGetEvent>(notifGet, transformer: droppable());
    on<NotificationUpdateEvent>(notifUpdate, transformer: droppable());
    on<NotificationDeleteEvent>(notifDelete, transformer: droppable());
    on<NotificationAddEvent>(notifAdd, transformer: droppable());
    on<NotificationReadAllEvent>(notifRead, transformer: droppable());
  }

  notifGet(NotificationGetEvent event, emit) async {
    emit(state.copyWith(status: StatusOfNotif.loading));
    Dio dio = Dio();

    try {
      Response response = await dio.get(
        "https://ishgram-production.up.railway.app/api/v1/notifications/${StorageRepository.getString(key: "userId")}",
      );
      if (response.statusCode == 200) {
        List<NotificationModel> list = (response.data["notifications"] as List?)
                ?.map((element) =>
                    NotificationModel.fromJson(element as Map<String, dynamic>))
                .toList() ??
            [];
        emit(
            state.copyWith(notifications: list, status: StatusOfNotif.success));
      }
    } catch (error) {
      debugPrint("ERROR CATCH $error");
    }
  }

  notifUpdate(NotificationUpdateEvent event, emit) async {
    final dio = Dio();
    dio.put(
      "https://notification-api-production.up.railway.app/api/v1/notification",
      data: event.notificationModel.toJsonForUpdate(),
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500 || status == 307;
        },
      ),
    );
  }

  notifRead(NotificationReadAllEvent event, emit) async {
    final dio = Dio();
    try {
      emit(state.copyWith(status: StatusOfNotif.loading));
      Response response = await dio.patch(
          "https://ishgram-production.up.railway.app/api/v1/notifications/${StorageRepository.getString(key: "userId")}",
          onReceiveProgress: (v, w) {});
      if (response.statusCode == 200) {
        emit(state.copyWith(status: StatusOfNotif.success));
        List<NotificationModel> list = (response.data["notifications"] as List?)
                ?.map((element) =>
                    NotificationModel.fromJson(element as Map<String, dynamic>))
                .toList() ??
            [];
        emit(state.copyWith(notifications: list));
      } else {
        emit(state.copyWith(status: StatusOfNotif.error));
      }
    } catch (er) {
      emit(state.copyWith(status: StatusOfNotif.error));
    }
  }

  notifDelete(NotificationDeleteEvent event, emit) async {}

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
  }
}
