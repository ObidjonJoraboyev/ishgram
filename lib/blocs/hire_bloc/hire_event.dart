import 'package:ish_top/data/models/hire_model.dart';

abstract class HireEvent {}

class AnnouncementAddEvent extends HireEvent {
  final HireModel hireModel;

  AnnouncementAddEvent({required this.hireModel});
}

class AnnouncementUpdateEvent extends HireEvent {
  final HireModel hireModel;

  AnnouncementUpdateEvent({required this.hireModel});
}

class AnnouncementRemoveEvent extends HireEvent {
  final String docId;

  AnnouncementRemoveEvent({required this.docId});
}

class AnnouncementGetEvent extends HireEvent {}
