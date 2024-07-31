import 'package:flutter/material.dart';
import 'package:ish_top/data/models/announ_model.dart';
import 'package:ish_top/data/models/user_model.dart';

abstract class AnnounEvent {}

class AnnounAddEvent extends AnnounEvent {
  final AnnounModel hireModel;
  final BuildContext context;
  final UserModel userModel;

  AnnounAddEvent(
      {required this.hireModel,
      required this.context,
      required this.userModel});
}

class AnnounUpdateEvent extends AnnounEvent {
  final AnnounModel hireModel;

  AnnounUpdateEvent({required this.hireModel});
}

class AnnounRemoveEvent extends AnnounEvent {
  final String docId;

  AnnounRemoveEvent({required this.docId});
}

class AnnounGetEvent extends AnnounEvent {}

class AnnounGetUserIdEvent extends AnnounEvent {
  final String userId;

  AnnounGetUserIdEvent({required this.userId});
}

class AnnounInitialEvent extends AnnounEvent {}

class AnnounGetQREvent extends AnnounEvent {
  final String userIdQr;
  AnnounGetQREvent({required this.userIdQr});
}
