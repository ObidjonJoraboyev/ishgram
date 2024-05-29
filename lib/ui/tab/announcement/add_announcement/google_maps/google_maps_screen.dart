import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ish_top/blocs/map/map_bloc.dart';
import 'package:ish_top/blocs/map/map_event.dart';
import 'package:ish_top/blocs/map/map_state.dart';
import 'package:ish_top/ui/tab/announcement/add_announcement/google_maps/widget/map_type_item.dart';
import 'package:ish_top/ui/tab/announcement/add_announcement/google_maps/widget/show_detail_map.dart';
import '../../../../../data/models/place_model.dart';
import '../../../../../utils/styles/app_text_style.dart';

class GoogleMapsScreen extends StatefulWidget {
  const GoogleMapsScreen({
    super.key,
  });

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  int activeIndex = 1;
  CameraPosition? cameraPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MapBloc, MapState>(
        builder: (context, viewModel) {
          return Stack(
            children: [
              GoogleMap(

                markers: viewModel.markers,

                onCameraIdle: () {
                  if (cameraPosition != null) {
                    context
                        .read<MapBloc>()
                        .add(ChangeCurrentCameraPositionEvent(cameraPosition!));
                  }
                },
                onCameraMove: (CameraPosition currentCameraPosition) {
                  cameraPosition = currentCameraPosition;
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                mapType: viewModel.mapType,
                initialCameraPosition: viewModel.initialCameraPosition,
                onMapCreated: (GoogleMapController createdController) {
                  viewModel.controller.complete(createdController);
                },
              ),
              Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  "assets/icons/location.svg",
                  width: 50,
                  height: 50,
                ),
              ),
              Positioned(
                top: 40,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    Text(
                      viewModel.currentPlaceName,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.interSemiBold.copyWith(
                          fontSize: 24,
                          color: Colors.white,
                          shadows: [
                            const Shadow(color: Colors.black, blurRadius: 40)
                          ]),
                    ),
                    Text(
                      "${viewModel.currentCameraPosition.target.latitude}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 30,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 13),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: const Offset(0, 7),
                                  color: Colors.black.withOpacity(.24))
                            ],
                            borderRadius: BorderRadius.circular(16),
                            color: activeIndex == 1
                                ? Colors.orangeAccent
                                : Colors.white,
                          ),
                          child: InkWell(
                            onTap: () {
                              activeIndex = 1;
                              setState(() {});
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.home,
                                  color: activeIndex != 1
                                      ? Colors.black
                                      : Colors.white,
                                ),
                                Text(
                                  "Home",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: activeIndex != 1
                                          ? Colors.black
                                          : Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 13),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: const Offset(0, 7),
                                  color: Colors.black.withOpacity(.24))
                            ],
                            borderRadius: BorderRadius.circular(16),
                            color: activeIndex == 2
                                ? Colors.orangeAccent
                                : Colors.white,
                          ),
                          child: InkWell(
                            onTap: () {
                              activeIndex = 2;
                              setState(() {});
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.work,
                                  color: activeIndex != 2
                                      ? Colors.black
                                      : Colors.white,
                                ),
                                Text(
                                  "Work",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: activeIndex != 2
                                          ? Colors.black
                                          : Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 13),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: const Offset(0, 7),
                                  color: Colors.black.withOpacity(.24))
                            ],
                            borderRadius: BorderRadius.circular(16),
                            color: activeIndex == 3
                                ? Colors.orangeAccent
                                : Colors.white,
                          ),
                          child: InkWell(
                            onTap: () {
                              activeIndex = 3;
                              setState(() {});
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit_location_alt,
                                  color: activeIndex != 3
                                      ? Colors.black
                                      : Colors.white,
                                ),
                                Text(
                                  "Other",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: activeIndex != 3
                                          ? Colors.black
                                          : Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 13),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 7),
                              color: Colors.black.withOpacity(.24))
                        ],
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.orangeAccent,
                      ),
                      child: InkWell(
                        onTap: () {
                          addressDetailDialog(
                            context: context,
                            placeModel: (newAddressDetails) {
                              PlaceModel place = newAddressDetails;
                              place.lat = cameraPosition?.target.latitude ?? 12;
                              place.long =
                                  cameraPosition?.target.longitude ?? 12;
                            },
                            defaultName: viewModel.currentPlaceName,
                          );
                        },
                        child: Text(
                          "Add as ${activeIndex == 1 ? "Home" : activeIndex == 2 ? "Work" : "Other"}",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 340,
                right: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        context.read<MapBloc>().add(
                              ChangeCurrentCameraPositionEvent(
                                const CameraPosition(
                                  target: LatLng(0, 0),
                                ),
                              ),
                            );
                      },
                      child: const Icon(Icons.gps_fixed),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    const MapTypeItem(),
                  ],
                ),
              )
            ],
          );
        },
        listener: (BuildContext context, state) {},
      ),
    );
  }
}
