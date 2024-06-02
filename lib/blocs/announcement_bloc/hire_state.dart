import '../../data/models/announcement_model.dart';

class AnnounState {
  final List<AnnouncementModel> allHires;
  final List<AnnouncementModel> myHires;

  AnnounState({required this.allHires, required this.myHires});

  AnnounState copyWith({
    List<AnnouncementModel>? allHires,
    List<AnnouncementModel>? myHires,
  }) {
    return AnnounState(
      allHires: allHires ?? this.allHires,
      myHires: myHires ?? this.myHires,
    );
  }
}
