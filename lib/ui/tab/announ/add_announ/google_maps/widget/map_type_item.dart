import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ish_top/blocs/map/map_bloc.dart';
import 'package:ish_top/blocs/map/map_event.dart';

class MapTypeItem extends StatelessWidget {
  const MapTypeItem({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: PopupMenuButton(
              padding: const EdgeInsets.all(0),
              splashRadius: 50,
              icon: const Icon(Icons.map, color: Colors.white),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: const Text("Normal"),
                    onTap: () {
                      context
                          .read<MapBloc>()
                          .add(ChangeMapTypeEvent(newMapType: MapType.normal));
                    },
                  ),
                  PopupMenuItem(
                    child: const Text("Hybrid"),
                    onTap: () {
                      context
                          .read<MapBloc>()
                          .add(ChangeMapTypeEvent(newMapType: MapType.hybrid));
                    },
                  ),
                  PopupMenuItem(
                    child: const Text("Satellite"),
                    onTap: () {
                      context.read<MapBloc>().add(
                          ChangeMapTypeEvent(newMapType: MapType.satellite));
                    },
                  ),
                ];
              },
            ),
          )
        ],
      ),
    );
  }
}
