import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:ish_top/data/models/notification_model.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class NotificationGetEvent extends NotificationEvent {
  final BuildContext context;
  const NotificationGetEvent({required this.context});
  @override
  List<Object?> get props => [];
}

class NotificationAddEvent extends NotificationEvent {
  final NotificationModel notificationModel;

  const NotificationAddEvent({required this.notificationModel});

  @override
  List<Object?> get props => [];
}

class NotificationUpdateEvent extends NotificationEvent {
  final NotificationModel notificationModel;

  const NotificationUpdateEvent({required this.notificationModel});

  @override
  List<Object?> get props => [];
}

class NotificationDeleteEvent extends NotificationEvent {
  final String docId;

  const NotificationDeleteEvent({required this.docId});

  @override
  List<Object?> get props => [];
}

class NotificationReadAllEvent extends NotificationEvent {
  final BuildContext context;
  final String uuId;

  const NotificationReadAllEvent({required this.uuId, required this.context});
  @override
  List<Object?> get props => [];
}
