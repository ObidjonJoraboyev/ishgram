import '../../data/models/hire_model.dart';

abstract class AnnouncementState {}

class AnnouncementInitial extends AnnouncementState {}

class AnnouncementGetState extends AnnouncementState {
  final List<HireModel> hires;

  AnnouncementGetState({required this.hires});
}

class AnnouncementLoadingState extends AnnouncementState {}
