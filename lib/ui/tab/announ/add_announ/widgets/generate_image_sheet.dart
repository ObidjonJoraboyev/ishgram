import 'dart:ui';
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
import 'package:ish_top/ui/admins_panel/tab/announ/widgets/zoom_tap.dart';
import 'package:ish_top/ui/auth/widgets/button.dart';

class GenerateImageSheet extends StatefulWidget {
  const GenerateImageSheet({
    super.key,
    required this.state,
    required this.selectedIndex,
  });

  final int selectedIndex;
  final ImageUploadState state;

  @override
  State<GenerateImageSheet> createState() => _GenerateImageSheetState();
}

class _GenerateImageSheetState extends State<GenerateImageSheet> {
  int activeIndex = -1;

  @override
  void initState() {
    activeIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.count(
            physics: const ScrollPhysics(),
            childAspectRatio: MediaQuery.sizeOf(context).aspectRatio * 2,
            scrollDirection: Axis.vertical,
            crossAxisCount: 2,
            mainAxisSpacing: 8.w,
            crossAxisSpacing: 8.w,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            children: [
              ...List.generate(
                widget.state.images.length,
                (index) => GestureDetector(
                  onTap: () {
                    activeIndex > -1
                        ? context.read<ImageBloc>().add(ImageMoveEvent(
                            currentIndex: activeIndex, wantIndex: index))
                        : null;

                    if (activeIndex == index) {
                      activeIndex = -1;
                    } else {
                      activeIndex = index;
                    }
                    setState(() {});
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: CachedNetworkImage(
                          width: double.infinity,
                          height: double.infinity,
                          imageUrl: widget.state.images[index],
                          fit: BoxFit.cover,
                          placeholder: (s, w) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: Container(
                                width: 150.w,
                                color: CupertinoColors.white,
                                child: (widget.state.formStatus ==
                                            FormStatusImage.uploading) &&
                                        (index == 0)
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : const Center(
                                        child: CircularProgressIndicator
                                            .adaptive()),
                              ),
                            );
                          },
                        ),
                      ),
                      if (activeIndex == index)
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                              child: Center(
                                child: Icon(
                                  CupertinoIcons.checkmark,
                                  color: Colors.white,
                                  size: 30.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        top: 10.sp,
                        left: 10.sp,
                        child: ScaleOnPress(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.7),
                                  spreadRadius: 10.sp,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0.w),
          child: LoginButtonItems(
            onTap: () {
              Navigator.of(context).pop();
            },
            isLoading: false,
            active: true,
            title: "done".tr(),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).padding.bottom,
        )
      ],
    );
  }
}
