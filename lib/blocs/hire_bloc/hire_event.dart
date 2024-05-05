import 'package:ish_top/data/models/hire_model.dart';

abstract class HireEvent {}

class HireAddEvent extends HireEvent {
  final HireModel hireModel;

  HireAddEvent({required this.hireModel});
}

class HireUpdateEvent extends HireEvent {
  final HireModel hireModel;

  HireUpdateEvent({required this.hireModel});
}

class HireRemoveEvent extends HireEvent {
  final String docId;

  HireRemoveEvent({required this.docId});
}

class HireGetEvent extends HireEvent {}
