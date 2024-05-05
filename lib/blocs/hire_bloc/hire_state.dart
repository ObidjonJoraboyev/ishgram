import '../../data/models/hire_model.dart';

abstract class HireState {}

class HireInitial extends HireState {}

class HireGetState extends HireState {
  final List<HireModel> hires;

  HireGetState({required this.hires});
}

class HireLoadingState extends HireState {}
