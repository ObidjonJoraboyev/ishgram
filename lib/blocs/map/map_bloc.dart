import 'dart:async';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ish_top/data/network/api_provider_location.dart';
import 'package:location/location.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc()
      : super(MapState(
          isOk: false,
          currentPlaceName: "",
          controller: Completer<GoogleMapController>(),
          mapType: MapType.hybrid,
          initialCameraPosition:
              const CameraPosition(target: LatLng(0, 0), zoom: 18),
          currentCameraPosition:
              const CameraPosition(target: LatLng(0, 0), zoom: 18),
          markers: const {},
          userPosition: const CameraPosition(target: LatLng(0, 0), zoom: 18),
        )) {
    on<ChangeMapTypeEvent>(changeMapType);
    on<ChangePlaceName>(changeCurrentLocation);
    on<ChangeCurrentCameraPositionEvent>(changeCurrentCameraPosition,
        transformer: droppable());
    on<GetUserLocation>(getUserLocation, transformer: droppable());
  }

  changeMapType(ChangeMapTypeEvent event, Emitter<MapState> emit) {
    emit(state.copyWith(mapType: event.newMapType));
  }

  changeCurrentCameraPosition(
      ChangeCurrentCameraPositionEvent event, Emitter<MapState> emit) async {
    final GoogleMapController mapController = await state.controller.future;
    await mapController
        .animateCamera(CameraUpdate.newCameraPosition(event.cameraPosition));
    emit(state.copyWith(currentCameraPosition: event.cameraPosition));
  }

  changeCurrentLocation(ChangePlaceName event, Emitter<MapState> emit) async {
    emit(state.copyWith(isOk: false));
    emit(state.copyWith(currentCameraPosition: event.cameraPosition));
    String placeName =
        await ApiProvider.getPlaceNameByLocation(event.cameraPosition.target);
    emit(state.copyWith(currentPlaceName: placeName, isOk: true));
  }

  getUserLocation(GetUserLocation event, Emitter<MapState> emit) async {
    Location location = Location();
    bool serviceEnabled;

    PermissionStatus permissionGranted;
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
    var locationUser = await ApiProvider().getGeoLocationPosition();
    emit(
      state.copyWith(
        userPosition: CameraPosition(
          target: LatLng(locationUser.latitude, locationUser.longitude),
          zoom: 16,
        ),
      ),
    );
  }
}
