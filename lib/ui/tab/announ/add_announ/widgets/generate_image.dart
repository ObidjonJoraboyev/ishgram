import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/image/formstatus.dart';
import 'package:ish_top/blocs/image/image_bloc.dart';
import 'package:ish_top/blocs/image/image_event.dart';
import 'package:ish_top/blocs/image/image_state.dart';
import 'package:ish_top/ui/tab/announ/add_announ/widgets/generate_image_sheet.dart';
import 'package:ish_top/ui/tab/announ/widgets/zoom_tap.dart';
import 'package:ish_top/utils/utility_functions.dart';
import 'package:shimmer/shimmer.dart';

class GenerateImage extends StatefulWidget {
  const GenerateImage({
    super.key,
    required this.state,
  });

  final ImageUploadState state;

  @override
  State<GenerateImage> createState() => _GenerateImageState();
}

class _GenerateImageState extends State<GenerateImage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).width / 2.5,
      child: GridView.count(
        physics: const ScrollPhysics(),
        childAspectRatio: MediaQuery.sizeOf(context).aspectRatio * 2,
        scrollDirection: Axis.horizontal,
        crossAxisCount: 1,
        mainAxisSpacing: 8.w,
        crossAxisSpacing: 8.w,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        children: [
          ...List.generate(
            widget.state.images.length,
            (index) => ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: CupertinoContextMenu(
                  enableHapticFeedback: false,
                  actions: [
                    CupertinoContextMenuAction(
                      onPressed: () async {
                        Navigator.of(context, rootNavigator: true).pop();
                        takeAnImage(context,
                            limit: 1,
                            images: widget.state.images,
                            deletingImage: widget.state.images[index],
                            isChange: true);
                      },
                      isDestructiveAction: false,
                      trailingIcon: CupertinoIcons.repeat,
                      child: const Text('Change'),
                    ),
                    widget.state.images.length > 1
                        ? CupertinoContextMenuAction(
                            onPressed: () async {
                              Navigator.of(context, rootNavigator: true).pop();
                              await showModalBottomSheet(
                                  context: context,
                                  useSafeArea: true,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return Container(
                                      padding: EdgeInsets.only(top: 14.h),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(30.r)),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: GenerateImageSheet(
                                              selectedIndex: index,
                                              state: context
                                                  .read<ImageBloc>()
                                                  .state,
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }).then((v) {
                                setState(() {});
                              });
                            },
                            isDestructiveAction: false,
                            trailingIcon: CupertinoIcons.arrow_swap,
                            child: const Text("Rasm joyini o'zgartirish"),
                          )
                        : const SizedBox(),
                    CupertinoContextMenuAction(
                      onPressed: () async {
                        context.read<ImageBloc>().add(
                              ImageRemoveEvent(
                                context,
                                docId: widget.state.images[index],
                              ),
                            );
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      isDestructiveAction: true,
                      trailingIcon: CupertinoIcons.delete,
                      child: const Text('Delete'),
                    ),
                  ],
                  child: CachedNetworkImage(
                    width: MediaQuery.sizeOf(context).width,
                    imageUrl: widget.state.images[index],
                    fit: BoxFit.cover,
                    placeholder: (s, w) {
                      return Padding(
                        padding: const EdgeInsets.all(0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: 150.w,
                            color: CupertinoColors.white,
                            child: (widget.state.formStatus ==
                                        FormStatusImage.uploading) &&
                                    (index == 0)
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : const Center(
                                    child: CircularProgressIndicator.adaptive(),
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
          ...List.generate(
            (5 - widget.state.images.length),
            (index) => ScaleOnPress(
              onTap: () async {
                takeAnImage(
                  context,
                  limit: 5 - widget.state.images.length,
                  images: widget.state.images,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  decoration: const BoxDecoration(
                    color: CupertinoColors.white,
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 0, blurRadius: 10, color: Colors.black)
                    ],
                  ),
                  child:
                      (widget.state.formStatus == FormStatusImage.uploading) &&
                              (index == 0)
                          ? Shimmer.fromColors(
                              baseColor: CupertinoColors.white,
                              highlightColor: CupertinoColors.systemGrey4,
                              child: Container(
                                height: 150.h,
                                width: 150.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                "add_image".tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  shadows: [
                                    BoxShadow(
                                      spreadRadius: 0,
                                      blurRadius: 10,
                                      color: Colors.white.withOpacity(.6),
                                    )
                                  ],
                                ),
                              ),
                            ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
