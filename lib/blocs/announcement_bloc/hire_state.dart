import '../../data/models/announcement.dart';

abstract class AnnouncementState {}

class AnnouncementInitial extends AnnouncementState {}

class AnnouncementGetState extends AnnouncementState {
  final List<AnnouncementModel> hires;

  AnnouncementGetState({required this.hires});
}

class AnnouncementLoadingState extends AnnouncementState {}
