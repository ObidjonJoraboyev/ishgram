import '../../data/models/announcement_model.dart';

abstract class AnnouncementState {}

class AnnouncementInitial extends AnnouncementState {}

class AnnouncementGetState extends AnnouncementState {
  final List<AnnouncementModel> hires;

  AnnouncementGetState({required this.hires});
}

class AnnouncementLoadingState extends AnnouncementState {}
