import 'package:ish_top/data/models/announ_model.dart';

class AnnounState {
  final List<AnnounModel> allHires;
  final List<AnnounModel> myHires;

  AnnounState({required this.allHires, required this.myHires});

  AnnounState copyWith({
    List<AnnounModel>? allHires,
    List<AnnounModel>? myHires,
  }) {
    return AnnounState(
      allHires: allHires ?? this.allHires,
      myHires: myHires ?? this.myHires,
    );
  }
}
