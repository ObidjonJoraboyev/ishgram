import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ish_top/blocs/announcement_bloc/hire_bloc.dart';
import 'package:ish_top/blocs/announcement_bloc/hire_event.dart';
import 'package:ish_top/blocs/image/image_bloc.dart';
import 'package:ish_top/blocs/image/image_event.dart';
import 'package:ish_top/blocs/image/image_state.dart';
import 'package:ish_top/data/models/announcement.dart';
import 'package:ish_top/ui/tab/announcement/add_announcement/widgets/generate_blame.dart';
import 'package:ish_top/ui/tab/announcement/add_announcement/widgets/generate_image.dart';
import 'package:ish_top/ui/tab/announcement/add_announcement/widgets/global_button.dart';
import 'package:ish_top/ui/tab/announcement/add_announcement/widgets/salary_textfield.dart';
import 'package:ish_top/ui/tab/announcement/add_announcement/widgets/text_field_widget.dart';
import 'package:ish_top/utils/formatters/formatters.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:ish_top/utils/utility_functions.dart';
import 'package:vibration/vibration.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class AddHireScreen extends StatefulWidget {
  const AddHireScreen({super.key, required this.voidCallback});

  final ValueChanged voidCallback;

  @override
  State<AddHireScreen> createState() => _AddHireScreenState();
}

class _AddHireScreenState extends State<AddHireScreen> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController numberCtrl = TextEditingController();
  final TextEditingController money = TextEditingController();
  final TextEditingController ownerCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();

  final ScrollController controller = ScrollController();
  int startWork = DateTime.now().millisecondsSinceEpoch;
  int endWork = DateTime.now().millisecondsSinceEpoch;
  int takenImages = 0;
  AnnouncementModel hireModel = AnnouncementModel.initial;
  bool? hasVibrator;
  FToast t = FToast();

  init() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGrey5,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("add_hire".tr()),
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
                child: ZoomTapAnimation(
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
                    ),
                    GlobalTextFiled(
                      onChanged: (v) {
                        setState(() {});
                      },
                      controller: ownerCtrl,
                      labelText: "your_name",
                      maxLines: 1,
                      maxLength: 50,
                    ),
                    GlobalTextFiled(
                      onChanged: (v) {
                        setState(() {});
                      },
                      controller: descriptionCtrl,
                      labelText: "about_work",
                      maxLength: 800,
                    ),
                    0.getH(),
                    GlobalTextFiled(
                      onChanged: (v) {
                        setState(() {});
                      },
                      controller: numberCtrl,
                      labelText: "phone_number",
                      maxLines: 1,
                      formatter: AppInputFormatters.phoneFormatter,
                      isPhone: true,
                    ),
                    14.getH(),
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
                            "Ish vaqt oralig'i",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16.sp),
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
                      height: 50.h,
                      child: CupertinoPageScaffold(
                        backgroundColor: Colors.transparent,
                        navigationBar: CupertinoNavigationBar(
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
                            children: const {
                              Sky.midnight: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'Oson',
                                  style: TextStyle(
                                      color: CupertinoColors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Sky.viridian: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  "O'rtacha",
                                  style: TextStyle(
                                      color: CupertinoColors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Sky.cerulean: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'Qiyin',
                                  style: TextStyle(
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
                    const SizedBox(
                      height: 200,
                      width: 300,
                      child: GoogleMap(
                        mapType: MapType.hybrid,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(12, 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
              context
                  .read<AnnouncementBloc>()
                  .add(AnnouncementAddEvent(hireModel: hireModel));
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
  Sky.midnight: CupertinoColors.activeOrange,
  Sky.viridian: CupertinoColors.activeOrange,
  Sky.cerulean: CupertinoColors.activeOrange,
};
