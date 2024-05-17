import 'package:ish_top/data/models/announcement.dart';

abstract class HireEvent {}

class AnnouncementAddEvent extends HireEvent {
  final AnnouncementModel hireModel;

  AnnouncementAddEvent({required this.hireModel});
}

class AnnouncementUpdateEvent extends HireEvent {
  final AnnouncementModel hireModel;

  AnnouncementUpdateEvent({required this.hireModel});
}

class AnnouncementRemoveEvent extends HireEvent {
  final String docId;

  AnnouncementRemoveEvent({required this.docId});
}

class AnnouncementGetEvent extends HireEvent {}
class AnnouncementInitialEvent extends HireEvent {}
