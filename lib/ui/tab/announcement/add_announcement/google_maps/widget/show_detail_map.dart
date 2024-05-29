import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/blocs/map/map_bloc.dart';
import '../../../../../../data/models/place_model.dart';

addressDetailDialog(
    {required BuildContext context,
      required ValueChanged<PlaceModel> placeModel,
      required String defaultName}) {
  TextEditingController nameController = TextEditingController();
  TextEditingController flatNumber = TextEditingController();
  TextEditingController orient = TextEditingController();
  TextEditingController entrance = TextEditingController();
  TextEditingController stage = TextEditingController();

  int incrementId =0;

  nameController.text = defaultName;
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Add Address",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black.withOpacity(.4)),
                    labelText: "Name",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.black.withOpacity(.5),
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.black.withOpacity(.5),
                        )),
                  ),
                  controller: nameController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          labelStyle:
                          TextStyle(color: Colors.black.withOpacity(.4)),
                          labelText: "Entrance",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.black.withOpacity(.5),
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.black.withOpacity(.5),
                              )),
                        ),
                        controller: entrance,
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      child: TextField(
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          labelStyle:
                          TextStyle(color: Colors.black.withOpacity(.4)),
                          labelText: "Stage",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.black.withOpacity(.5),
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.black.withOpacity(.5),
                              )),
                        ),
                        controller: stage,
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      child: TextField(
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          labelStyle:
                          TextStyle(color: Colors.black.withOpacity(.4)),
                          labelText: "Apartment",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.black.withOpacity(.5),
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.black.withOpacity(.5),
                              )),
                        ),
                        controller: flatNumber,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black.withOpacity(.4)),
                    labelText: "Orient",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.black.withOpacity(.5),
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.black.withOpacity(.5),
                        )),
                  ),
                  controller: orient,
                ),
              ),
              const SizedBox(height: 4),
              TextButton(
                  onPressed: () {
                    incrementId++;
                    placeModel.call(
                      PlaceModel(
                        entrance: entrance.text,
                        flatNumber: flatNumber.text,
                        orientAddress: orient.text,
                        lat: 0,
                        long: 0,
                        placeName: nameController.text,
                        stage: stage.text, id: incrementId,
                      ),
                    );


                    double lat=  context.read<MapBloc>().state.currentCameraPosition.target.latitude;
                    double lon=  context.read<MapBloc>().state.currentCameraPosition.target.latitude;




                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(fontSize: 18),
                  )),
              const SizedBox(height: 24),
            ],
          ),
        );
      });
}
