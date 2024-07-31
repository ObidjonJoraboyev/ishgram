import 'package:ish_top/data/forms/form_status.dart';
import 'package:ish_top/data/models/announ_model.dart';

class AnnounState {
  final List<AnnounModel> allHires;
  final List<AnnounModel> myHires;
  final List<AnnounModel> qrHires;
  final FormStatus status;

  AnnounState(
      {required this.allHires,
      required this.myHires,
      required this.status,
      required this.qrHires});

  AnnounState copyWith({
    List<AnnounModel>? allHires,
    List<AnnounModel>? myHires,
    FormStatus? status,
    List<AnnounModel>? qrHires,
  }) {
    return AnnounState(
      qrHires: qrHires ?? this.qrHires,
      status: status ?? this.status,
      allHires: allHires ?? this.allHires,
      myHires: myHires ?? this.myHires,
    );
  }
}
