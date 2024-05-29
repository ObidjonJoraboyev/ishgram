import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapState extends Equatable {
  final String currentPlaceName;

  final Completer<GoogleMapController> controller;
  final MapType mapType;
  final CameraPosition initialCameraPosition;
  final CameraPosition currentCameraPosition;

  final Set<Marker> markers;

  const MapState({
    required this.currentPlaceName,
    required this.controller,
    required this.mapType,
    required this.initialCameraPosition,
    required this.currentCameraPosition,
    required this.markers,
  });

  MapState copyWith({
    String? currentPlaceName,
    Completer<GoogleMapController>? controller,
    MapType? mapType,
    CameraPosition? initialCameraPosition,
    CameraPosition? currentCameraPosition,
    Set<Marker>? markers,
  }) {
    return MapState(
      currentPlaceName: currentPlaceName ?? this.currentPlaceName,
      controller: controller ?? this.controller,
      mapType: mapType ?? this.mapType,
      initialCameraPosition:
          initialCameraPosition ?? this.initialCameraPosition,
      currentCameraPosition:
          currentCameraPosition ?? this.currentCameraPosition,
      markers: markers ?? this.markers,
    );
  }

  @override
  List<Object?> get props => [];
}
