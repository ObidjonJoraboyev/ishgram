import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  final void Function() voidCallback;

  @override
  State<AddHireScreen> createState() => _AddHireScreenState();
}

class _AddHireScreenState extends State<AddHireScreen> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController numberCtrl = TextEditingController();
  final TextEditingController money = TextEditingController();
  final TextEditingController ownerCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();

  int startWork = 0;
  int endWork = 0;
  int takenImages = 0;
  AnnouncementModel hireModel = AnnouncementModel.initial;
  bool? hasVibrator;
  FToast t = FToast();

  init() async {
    hasVibrator = await Vibration.hasVibrator();
  }

  @override
  void initState() {
    init();
    setState(() {});
    t.init(context);
    super.initState();
  }

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
          return ListView(
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
              const Divider(),
              StatefulBuilder(
                builder: (context, setState) {
                  return CupertinoListTile(
                    onTap: () {
                      show(
                        context: context,
                        cancelButton: () {
                          endWork = 0;
                          startWork = 0;
                          Navigator.pop(context);
                        },
                        doneButton: () {
                          if (endWork !=
                                  DateTime.now().millisecondsSinceEpoch &&
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
                      );
                    },
                    title: const Text("Ish vaqt oralig'i"),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: GlobalButton(
                  title: "add".tr(),
                  color: isValid() ? Colors.green : CupertinoColors.systemGrey,
                  onTap: () async {
                    if (hasVibrator ?? false) {
                      Vibration.vibrate(
                          pattern: [2, 5], intensities: [100, 2000]);
                    }

                    if (isValid()) {
                      if (!context.mounted) return;
                      hireModel = hireModel.copyWith(
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
                      widget.voidCallback.call();
                      Widget toast = Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.green,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            Text(
                              "added_hiring".tr(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp),
                            ),
                          ],
                        ),
                      );

                      t.showToast(child: toast);
                      nameCtrl.clear();
                      numberCtrl.clear();
                      money.clear();
                      ownerCtrl.clear();
                      descriptionCtrl.clear();
                    }
                  },
                ),
              )
            ],
          );
        },
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
        descriptionCtrl.text.isNotEmpty;
  }
}
