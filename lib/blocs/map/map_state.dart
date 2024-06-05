import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapState {
  final String currentPlaceName;
  final Completer<GoogleMapController> controller;
  final MapType mapType;
  final CameraPosition initialCameraPosition;
  final CameraPosition currentCameraPosition;
  final Set<Marker> markers;
  final CameraPosition userPosition;
  final bool isOk;

  MapState({
    required this.currentPlaceName,
    required this.controller,
    required this.mapType,
    required this.initialCameraPosition,
    required this.currentCameraPosition,
    required this.markers,
    required this.userPosition,
    required this.isOk,
  });

  MapState copyWith(
      {String? currentPlaceName,
      Completer<GoogleMapController>? controller,
      MapType? mapType,
      CameraPosition? initialCameraPosition,
      CameraPosition? currentCameraPosition,
      Set<Marker>? markers,
      CameraPosition? userPosition,
      bool? isOk}) {
    return MapState(
      isOk: isOk ?? this.isOk,
      currentPlaceName: currentPlaceName ?? this.currentPlaceName,
      controller: controller ?? this.controller,
      mapType: mapType ?? this.mapType,
      initialCameraPosition:
          initialCameraPosition ?? this.initialCameraPosition,
      currentCameraPosition:
          currentCameraPosition ?? this.currentCameraPosition,
      markers: markers ?? this.markers,
      userPosition: userPosition ?? this.userPosition,
    );
  }
}
