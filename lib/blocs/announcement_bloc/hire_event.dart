import 'package:flutter/material.dart';
import 'package:ish_top/data/models/announcement_model.dart';

import '../../data/models/user_model.dart';

abstract class HireEvent {}

class AnnounAddEvent extends HireEvent {
  final AnnouncementModel hireModel;
  final BuildContext context;
  final UserModel userModel;

  AnnounAddEvent(
      {required this.hireModel,
      required this.context,
      required this.userModel});
}

class AnnounUpdateEvent extends HireEvent {
  final AnnouncementModel hireModel;

  AnnounUpdateEvent({required this.hireModel});
}

class AnnounRemoveEvent extends HireEvent {
  final String docId;

  AnnounRemoveEvent({required this.docId});
}

class AnnounGetEvent extends HireEvent {}

class AnnounInitialEvent extends HireEvent {}

class AnnounListGetEvent extends HireEvent {
  final List<String> announcementDocs;

  AnnounListGetEvent({required this.announcementDocs});
}
