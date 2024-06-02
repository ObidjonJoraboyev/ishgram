import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ish_top/blocs/map/map_bloc.dart';
import 'package:ish_top/blocs/map/map_event.dart';
import 'package:ish_top/blocs/map/map_state.dart';
import 'package:ish_top/ui/tab/announ/add_announ/widgets/global_button.dart';
import 'package:ish_top/utils/size/size_utils.dart';

import 'widget/map_type_item.dart';

class GoogleMapsScreen extends StatefulWidget {
  const GoogleMapsScreen({
    super.key,
    required this.cameraPosition,
  });

  final CameraPosition cameraPosition;

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  int activeIndex = 1;
  CameraPosition? cameraPosition;
  GoogleMapController? mapController;

  bool open = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Manzilni kiritish",
          style: TextStyle(
              color: Colors.black,
              shadows: [Shadow(blurRadius: 14, color: Colors.white38)]),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        backgroundColor: Colors.white.withOpacity(.5),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ),
      body: BlocConsumer<MapBloc, MapState>(
        builder: (context, state) {
          return Stack(
            children: [
              GoogleMap(
                markers: state.markers,
                onCameraIdle: () async {
                  setState(() {});
                  if (cameraPosition != null) {
                    context
                        .read<MapBloc>()
                        .add(ChangePlaceName(cameraPosition: cameraPosition!));

                    context.read<MapBloc>().add(
                          ChangeCurrentCameraPositionEvent(
                              cameraPosition: cameraPosition!,
                              controller: mapController!),
                        );
                  }

                  state.isOk ? open = true : open = false;
                },
                onCameraMove: (CameraPosition currentCameraPosition) {
                  cameraPosition = currentCameraPosition;
                  open = false;

                  setState(() {});
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: true,
                compassEnabled: true,
                mapType: state.mapType,
                initialCameraPosition: widget.cameraPosition,
                onMapCreated: (createdController) {
                  mapController = createdController;
                  context
                      .read<MapBloc>()
                      .state
                      .controller
                      .complete(createdController);
                  context.read<MapBloc>().add(GetUserLocation());
                  setState(() {});
                },
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: SvgPicture.asset(
                    "assets/icons/location.svg",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      color: Colors.transparent,
                      child: AnimatedContainer(
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.5),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16.r),
                                topLeft: Radius.circular(16.r))),
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.linear,
                        height: open ? 180.h : 0,
                        width: MediaQuery.sizeOf(context).width,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              10.getH(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24.w, vertical: 12.h),
                                child: Text(
                                  state.currentPlaceName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GlobalButton(
                                    title: "Tanlash",
                                    color: CupertinoColors.activeBlue,
                                    onTap: () {}),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 340,
                right: 10,
                child: Column(
                  children: [
                    const MapTypeItem(),
                    SizedBox(
                      height: 56,
                      width: 56,
                      child: IconButton(
                        style:
                            IconButton.styleFrom(backgroundColor: Colors.white),
                        onPressed: () async {
                          context.read<MapBloc>().add(
                                ChangeCurrentCameraPositionEvent(
                                    cameraPosition: state.userPosition,
                                    controller: mapController!),
                              );
                        },
                        icon: const Icon(Icons.my_location),
                      ),
                    )
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
