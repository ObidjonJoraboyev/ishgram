import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapEvent extends Equatable {}

class SetInitialLatLongEvent extends MapEvent {
  final LatLng latLng;

  SetInitialLatLongEvent(this.latLng);

  @override
  List<Object> get props => [latLng];
}

class ChangeMapTypeEvent extends MapEvent {
  final MapType newMapType;
  ChangeMapTypeEvent({required this.newMapType});

  @override
  List<Object?> get props => [newMapType];
}

class ChangeCurrentCameraPositionEvent extends MapEvent {
  final CameraPosition cameraPosition;

  ChangeCurrentCameraPositionEvent(this.cameraPosition);

  @override
  List<Object?> get props => [cameraPosition];
}

class GetUserLocation extends MapEvent {
  @override
  List<Object?> get props => [];
}
class ChangePlaceName extends MapEvent {
 final  CameraPosition cameraPosition;
 ChangePlaceName({required this.cameraPosition});
  @override
  List<Object?> get props => [];
}
