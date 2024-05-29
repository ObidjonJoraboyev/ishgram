import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../data/network/api_provider_location.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc()
      : super(MapState(
            currentPlaceName: "",
            controller: Completer<GoogleMapController>(),
            mapType: MapType.none,
            initialCameraPosition: const CameraPosition(target: LatLng(0, 0), zoom: 12),
            currentCameraPosition: const CameraPosition(target: LatLng(0, 0), zoom:  12),
            markers: const {})) {
    on<ChangeMapTypeEvent>(changeMapType);
    on<ChangePlaceName>(changeCurrentLocation);
    on<ChangeCurrentCameraPositionEvent>(changeCurrentCameraPosition);
  }

  changeMapType(ChangeMapTypeEvent event, Emitter emit) {
    emit(state.copyWith(mapType: event.newMapType));
  }

  changeCurrentCameraPosition(ChangeCurrentCameraPositionEvent event, Emitter emit) async {
    final GoogleMapController mapController = await state.controller.future;
    await mapController
        .animateCamera(CameraUpdate.newCameraPosition(event.cameraPosition));
  }

  changeCurrentLocation(ChangePlaceName event, Emitter emit) async {

    emit(state.copyWith(currentCameraPosition: event.cameraPosition));
    String a = await ApiProvider.getPlaceNameByLocation(event.cameraPosition.target);
    emit(state.copyWith(currentPlaceName: a));
  }

  getUserLocation(ChangePlaceName event, Emitter emit) async {
    Location location =
        Location();
    bool serviceEnabled = false;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();

    emit(state.copyWith(
        currentCameraPosition: CameraPosition(
            target: LatLng(locationData.latitude!, locationData.longitude!))));
  }
}
