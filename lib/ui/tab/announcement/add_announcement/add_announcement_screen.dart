import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/image/image_bloc.dart';
import 'package:ish_top/blocs/image/image_event.dart';
import 'package:ish_top/blocs/image/image_state.dart';
import 'package:ish_top/data/models/announcement.dart';
import 'package:ish_top/ui/tab/announcement/add_announcement/widgets/global_button.dart';
import 'package:ish_top/ui/tab/announcement/add_announcement/widgets/text_field_widget.dart';
import 'package:ish_top/utils/formatters/formatters.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../../../../blocs/announcement_bloc/hire_bloc.dart';
import '../../../../blocs/announcement_bloc/hire_event.dart';
import '../../../../utils/utility_functions.dart';

class AddHireScreen extends StatefulWidget {
  const AddHireScreen({super.key});

  @override
  State<AddHireScreen> createState() => _AddHireScreenState();
}

class _AddHireScreenState extends State<AddHireScreen> {
  final TextEditingController nameCtrl = TextEditingController();

  final TextEditingController numberCtrl = TextEditingController();
  final TextEditingController money = TextEditingController();

  final TextEditingController ownerCtrl = TextEditingController();

  final TextEditingController descriptionCtrl = TextEditingController();

  int takenImages = 0;
  AnnouncementModel hireModel = AnnouncementModel.initial;

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
                              docId: state.images[i].imageDocId,
                            ),
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
            children: [
              SizedBox(
                height: 150.w,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    12.getW(),
                    ...List.generate(
                      state.images.length,
                      (index) => ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Padding(
                          padding: EdgeInsets.all(8.0.w),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CupertinoContextMenu(
                              enableHapticFeedback: false,
                              actions: [
                                CupertinoContextMenuAction(
                                  onPressed: () async {
                                    context.read<ImageBloc>().add(
                                          ImageRemoveEvent(
                                            docId:
                                                state.images[index].imageDocId,
                                          ),
                                        );

                                    setState(() {});
                                  },
                                  isDestructiveAction: true,
                                  trailingIcon: CupertinoIcons.delete,
                                  child: const Text('Delete'),
                                ),
                              ],
                              child: CachedNetworkImage(
                                imageUrl: state.images[index].imageUrl,
                                fit: BoxFit.cover,
                                width: 150.w,
                                placeholder: (s, w) {
                                  return Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        width: 150.w,
                                        color: CupertinoColors.systemGrey2,
                                        child: (state.formStatus ==
                                                    FormStatus.uploading) &&
                                                (index == 0)
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : Center(
                                                child: Text(
                                                  "add_image".tr(),
                                                  style: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                    shadows: [
                                                      BoxShadow(
                                                        spreadRadius: 0,
                                                        blurRadius: 10,
                                                        color: Colors.black
                                                            .withOpacity(.6),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ...List.generate(
                      (5 - state.images.length),
                      (index) => ZoomTapAnimation(
                        onTap: () {
                          takeAnImage(
                            context,
                            limit: 5 - state.images.length,
                            images: state.images,
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8.0.sp),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: CupertinoColors.systemGrey2,
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 0,
                                      blurRadius: 10,
                                      color: Colors.black)
                                ],
                              ),
                              width: 150.w,
                              child: (state.formStatus ==
                                          FormStatus.uploading) &&
                                      (index == 0)
                                  ? const Center(
                                      child:
                                          CircularProgressIndicator.adaptive(),
                                    )
                                  : Center(
                                      child: Text(
                                        "add_image".tr(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          shadows: [
                                            BoxShadow(
                                              spreadRadius: 0,
                                              blurRadius: 10,
                                              color:
                                                  Colors.black.withOpacity(.6),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    12.getW(),
                  ],
                ),
              ),
              30.getH(),
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
                maxLength: 500,
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: TextField(
                  textInputAction: TextInputAction.done,
                  maxLength: 15,
                  onChanged: (c) {},
                  keyboardType: TextInputType.phone,
                  controller: money,
                  inputFormatters: [
                    CurrencyInputFormatter(
                      mantissaLength: 0,
                      maxTextLength: 1,
                      useSymbolPadding: false,
                      trailingSymbol: " so'm",
                      thousandSeparator: ThousandSeparator.Space,
                    )
                  ],
                  decoration: InputDecoration(
                    counterText: "",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(.6)),
                    labelText: "salary".tr(),
                    labelStyle: TextStyle(
                      color: Colors.black.withOpacity(.8),
                      fontWeight: FontWeight.w500,
                      shadows: [
                        BoxShadow(
                          color: Colors.white.withOpacity(.1),
                          blurRadius: 10,
                          spreadRadius: 0,
                        )
                      ],
                      fontSize: 16.sp,
                    ),
                    contentPadding: EdgeInsets.all(12.sp),
                    fillColor: Colors.grey.withOpacity(.7),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 0, color: Colors.grey),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 0, color: Colors.grey),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                          color: Colors.black.withOpacity(.4), blurRadius: 10)
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(24.0.sp),
                child: GlobalButton(
                  title: "add".tr(),
                  color: Colors.green,
                  onTap: () {
                    hireModel = hireModel.copyWith(
                      ownerName: ownerCtrl.text,
                      title: nameCtrl.text,
                      description: descriptionCtrl.text,
                      image: context.read<ImageBloc>().state.images,
                      money: money.text,
                      number: numberCtrl.text,
                      createdAt: DateTime.now().millisecondsSinceEpoch,
                    );
                    context
                        .read<AnnouncementBloc>()
                        .add(AnnouncementAddEvent(hireModel: hireModel));
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
