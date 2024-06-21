import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ish_top/blocs/announ_bloc/announ_bloc.dart';
import 'package:ish_top/blocs/announ_bloc/announ_event.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/auth/auth_event.dart';
import 'package:ish_top/blocs/auth/auth_state.dart';
import 'package:ish_top/blocs/image/image_bloc.dart';
import 'package:ish_top/blocs/image/image_event.dart';
import 'package:ish_top/blocs/image/image_state.dart';
import 'package:ish_top/blocs/map/map_bloc.dart';
import 'package:ish_top/data/local/local_storage.dart';
import 'package:ish_top/data/models/announ_model.dart';
import 'package:ish_top/data/network/api_provider_location.dart';
import 'package:ish_top/ui/admins_panel/tab/announ/add_announ/google_maps/google_maps_screen.dart';
import 'package:ish_top/ui/admins_panel/tab/announ/widgets/zoom_tap.dart';
import 'package:ish_top/utils/formatters/formatters.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:ish_top/utils/utility_functions.dart';
import 'package:vibration/vibration.dart';
import 'widgets/generate_blame.dart';
import 'widgets/generate_image.dart';
import 'widgets/global_button.dart';
import 'widgets/salary_textfield.dart';
import 'widgets/text_field_widget.dart';

class AdminAddHireScreen extends StatefulWidget {
  const AdminAddHireScreen(
      {super.key, required this.voidCallback, required this.context});

  final ValueChanged voidCallback;

  final BuildContext context;

  @override
  State<AdminAddHireScreen> createState() => _AdminAddHireScreenState();
}

class _AdminAddHireScreenState extends State<AdminAddHireScreen> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController numberCtrl = TextEditingController();
  final TextEditingController money = TextEditingController();
  final TextEditingController ownerCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();

  final ScrollController controller = ScrollController();
  int startWork = DateTime.now().millisecondsSinceEpoch;
  int endWork = DateTime.now().millisecondsSinceEpoch;
  int takenImages = 0;
  AnnounModel hireModel = AnnounModel.initial;
  bool? hasVibrator;
  FToast t = FToast();

  init() async {
    position = await ApiProvider().getGeoLocationPosition();
    hasVibrator = await Vibration.hasVibrator();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    numberCtrl.dispose();
    money.dispose();
    ownerCtrl.dispose();
    descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    init();
    setState(() {});
    t.init(context);
    controller.addListener(
      () {
        if (controller.position.userScrollDirection ==
            ScrollDirection.forward) {
          FocusScope.of(context).unfocus();
        }
      },
    );
    super.initState();
  }

  int activeCategory = 1;
  Sky _selectedSegment = Sky.midnight;

  String location = "";
  Position? position;

  bool checkBoxNum = false;
  bool checkBoxName = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {},
      builder: (context, authState) {
        return Scaffold(
          backgroundColor: CupertinoColors.systemGrey5,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              "add_hire".tr(),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 18.sp),
            ),
            actions: [
              BlocBuilder<ImageBloc, ImageUploadState>(
                builder: (context, state) {
                  return Visibility(
                    visible: nameCtrl.text.isNotEmpty ||
                        numberCtrl.text.isNotEmpty ||
                        money.text.isNotEmpty ||
                        ownerCtrl.text.isNotEmpty ||
                        descriptionCtrl.text.isNotEmpty ||
                        state.images.isNotEmpty,
                    child: ScaleOnPress(
                      onTap: () {
                        nameCtrl.clear();
                        numberCtrl.clear();
                        money.clear();
                        ownerCtrl.clear();
                        descriptionCtrl.clear();
                        for (int i = 0; i < state.images.length; i++) {
                          context.read<ImageBloc>().add(
                                ImageRemoveEvent(
                                    docId: state.images[i].imageDocId, context),
                              );
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: Text(
                          "reset".tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
          body: BlocConsumer<ImageBloc, ImageUploadState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView(
                      controller: controller,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        SizedBox(
                          height: 150.w,
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            children: [
                              12.getW(),
                              GenerateImage(state: state),
                              GenerateBlame(state: state),
                              12.getW(),
                            ],
                          ),
                        ),
                        2.getH(),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Padding(
                            padding: EdgeInsets.only(right: 16.w),
                            child: Text(
                              "${state.images.length}/5",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp),
                            ),
                          ),
                        ),
                        12.getH(),
                        GlobalTextFiled(
                          onChanged: (v) {
                            setState(() {});
                          },
                          controller: nameCtrl,
                          labelText: "work_name",
                          maxLines: 1,
                          maxLength: 100,
                          formStatus: authState.formStatus,
                        ),
                        GlobalTextFiled(
                          onChanged: (v) {
                            setState(() {});
                          },
                          controller: descriptionCtrl,
                          labelText: "about_work",
                          maxLength: 800,
                          formStatus: authState.formStatus,
                        ),
                        GlobalTextFiled(
                          onChanged: (v) {
                            setState(() {});

                            if (v ==
                                context.read<AuthBloc>().state.userModel.name) {
                              checkBoxName = true;
                            } else {
                              checkBoxName = false;
                            }
                          },
                          controller: ownerCtrl,
                          labelText: "your_name",
                          maxLines: 1,
                          maxLength: 50,
                          formStatus: authState.formStatus,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: GestureDetector(
                            onTap: () {
                              checkBoxName = !checkBoxName;

                              if (checkBoxName) {
                                ownerCtrl.text = context
                                    .read<AuthBloc>()
                                    .state
                                    .userModel
                                    .name;
                              } else {
                                ownerCtrl.text = "";
                              }
                              setState(() {});
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 16.h,
                                  child: Checkbox(
                                    activeColor: CupertinoColors.activeBlue,
                                    value: checkBoxName,
                                    onChanged: (v) {
                                      checkBoxName = v!;

                                      if (checkBoxName) {
                                        ownerCtrl.text = context
                                            .read<AuthBloc>()
                                            .state
                                            .userModel
                                            .name;
                                      } else {
                                        ownerCtrl.text = "";
                                      }
                                      setState(() {});
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "my_name".tr(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        25.getH(),
                        GlobalTextFiled(
                          onChanged: (v) {
                            setState(() {});

                            if (v ==
                                StorageRepository.getString(
                                    key: "userNumber")) {
                              checkBoxNum = true;
                            } else {
                              checkBoxNum = false;
                            }
                          },
                          controller: numberCtrl,
                          labelText: "phone_number",
                          maxLines: 1,
                          formatter: AppInputFormatters.phoneFormatter,
                          isPhone: true,
                          formStatus: authState.formStatus,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: GestureDetector(
                            onTap: () {
                              checkBoxNum = !checkBoxNum;

                              if (checkBoxNum) {
                                numberCtrl.text = StorageRepository.getString(
                                    key: "userNumber");
                              } else {
                                numberCtrl.text = "";
                              }
                              setState(() {});
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 12.h,
                                  child: Checkbox(
                                    activeColor: CupertinoColors.activeBlue,
                                    value: checkBoxNum,
                                    onChanged: (v) {
                                      checkBoxNum = v!;

                                      if (checkBoxNum) {
                                        numberCtrl.text =
                                            StorageRepository.getString(
                                                key: "userNumber");
                                      } else {
                                        numberCtrl.text = "";
                                      }
                                      setState(() {});
                                    },
                                  ),
                                ),
                                Expanded(
                                    child: Text(
                                  "my_number".tr(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13.sp,
                                  ),
                                ))
                              ],
                            ),
                          ),
                        ),
                        10.getH(),
                        SalaryTextField(
                          controller: money,
                          valueChanged: (c) {
                            setState(() {});
                          },
                        ),
                        Container(
                          width: double.infinity,
                          height: 0.6,
                          color: Colors.grey,
                        ),
                        StatefulBuilder(
                          builder: (context, setState) {
                            return ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16.w),
                              onTap: () {
                                show(
                                    context: context,
                                    cancelButton: () {
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    doneButton: () {
                                      if (endWork !=
                                              DateTime.now()
                                                  .millisecondsSinceEpoch &&
                                          startWork < endWork &&
                                          startWork != endWork) {
                                        Navigator.pop(context);
                                      }
                                    },
                                    onStartChange: (v) {
                                      startWork = v.millisecondsSinceEpoch;
                                      setState(() {});
                                    },
                                    onEndChange: (v) {
                                      endWork = v.millisecondsSinceEpoch;
                                      setState(
                                        () {},
                                      );
                                    },
                                    startTime: startWork,
                                    endTime: endWork);
                              },
                              title: Text(
                                "time_interval".tr(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp),
                              ),
                            );
                          },
                        ),
                        Container(
                          width: double.infinity,
                          height: 0.6,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          child: CupertinoPageScaffold(
                            backgroundColor: Colors.transparent,
                            navigationBar: CupertinoNavigationBar(
                              backgroundColor: CupertinoColors.systemGrey5,
                              middle: CupertinoSlidingSegmentedControl<Sky>(
                                backgroundColor: CupertinoColors.systemGrey2,
                                thumbColor: skyColors[_selectedSegment]!,
                                groupValue: _selectedSegment,
                                onValueChanged: (Sky? value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedSegment = value;
                                      activeCategory = _selectedSegment.index;
                                    });
                                  }
                                },
                                children: {
                                  Sky.midnight: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text(
                                      'easy'.tr(),
                                      style: const TextStyle(
                                          color: CupertinoColors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Sky.viridian: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text(
                                      "medium".tr(),
                                      style: const TextStyle(
                                          color: CupertinoColors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Sky.cerulean: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text(
                                      'hard'.tr(),
                                      style: const TextStyle(
                                          color: CupertinoColors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                },
                              ),
                            ),
                            child: const SizedBox(),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 0.6,
                          color: Colors.grey,
                        ),
                        ScaleOnPress(
                          scaleValue: 0.98,
                          onTap: () async {
                            setState(() {});
                            if (!context.mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (c) {
                                  return GoogleMapsScreen(
                                    cameraPosition: CameraPosition(
                                        target: LatLng(position?.latitude ?? 0,
                                            position?.longitude ?? 0),
                                        zoom: 15),
                                  );
                                },
                              ),
                            ).then(
                              (v) => setState(
                                () {
                                  hireModel = hireModel.copyWith(
                                      location: context
                                          .read<MapBloc>()
                                          .state
                                          .currentPlaceName,
                                      lat: context
                                          .read<MapBloc>()
                                          .state
                                          .currentCameraPosition
                                          .target
                                          .latitude,
                                      long: context
                                          .read<MapBloc>()
                                          .state
                                          .currentCameraPosition
                                          .target
                                          .longitude);
                                },
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(16.0.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 4.h),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.sizeOf(context).width / 2,
                                      child: Text(
                                        context
                                            .read<MapBloc>()
                                            .state
                                            .currentPlaceName,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.2.sp),
                                        maxLines: 10,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                SizedBox(
                                  height: MediaQuery.sizeOf(context).width / 2,
                                  width: MediaQuery.sizeOf(context).width / 2,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.r),
                                    child: GoogleMap(
                                      markers: {
                                        Marker(
                                          onTap: () async {},
                                          icon: BitmapDescriptor.defaultMarker,
                                          position: const LatLng(12, 12),
                                          markerId: const MarkerId(""),
                                        ),
                                      },
                                      zoomControlsEnabled: false,
                                      myLocationButtonEnabled: false,
                                      onTap: (v) {},
                                      mapType: MapType.normal,
                                      initialCameraPosition: CameraPosition(
                                        target: LatLng(position?.latitude ?? 0,
                                            position?.longitude ?? 0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 0.6,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          height: 100,
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 5.h, left: 14.w, right: 14.w),
            child: GlobalButton(
              title: "add".tr(),
              color: isValid() ? Colors.green : Colors.grey,
              onTap: () async {
                if (hasVibrator ?? false) {
                  Vibration.vibrate(pattern: [2, 5], intensities: [100, 2000]);
                }

                if (isValid()) {
                  if (!context.mounted) return;
                  hireModel = hireModel.copyWith(
                    category: WorkCategory.values[activeCategory],
                    ownerName: ownerCtrl.text,
                    title: nameCtrl.text,
                    timeInterval: "$startWork:$endWork",
                    description: descriptionCtrl.text,
                    image: context.read<ImageBloc>().state.images,
                    money: money.text,
                    number: numberCtrl.text,
                    createdAt: DateTime.now().millisecondsSinceEpoch,
                  );
                  context.read<AuthBloc>().add(GetCurrentUser());

                  context.read<AnnounBloc>().add(AnnounAddEvent(
                      hireModel: hireModel,
                      context: widget.context,
                      userModel: authState.userModel));

                  widget.voidCallback.call(() {
                    t.showToast(child: toast);
                    nameCtrl.clear();
                    numberCtrl.clear();
                    money.clear();
                    ownerCtrl.clear();
                    descriptionCtrl.clear();
                    startWork = DateTime.now().millisecondsSinceEpoch;
                    endWork = DateTime.now().millisecondsSinceEpoch;
                  });
                }
              },
            ),
          ),
        );
      },
    );
  }

  bool isValid() {
    return nameCtrl.text.isNotEmpty &&
        numberCtrl.text.length == 19 &&
        money.text != "0 so'm" &&
        money.text.isNotEmpty &&
        ownerCtrl.text.isNotEmpty &&
        startWork != 0 &&
        endWork != 0 &&
        descriptionCtrl.text.isNotEmpty &&
        startWork != DateTime.now().millisecondsSinceEpoch &&
        endWork != DateTime.now().millisecondsSinceEpoch;
  }
}

enum Sky { midnight, viridian, cerulean }

Map<Sky, Color> skyColors = <Sky, Color>{
  Sky.midnight: CupertinoColors.activeBlue,
  Sky.viridian: CupertinoColors.activeBlue,
  Sky.cerulean: CupertinoColors.activeBlue,
};
