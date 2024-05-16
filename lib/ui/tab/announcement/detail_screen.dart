import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/data/models/announcement.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.hireModel});

  final AnnouncementModel hireModel;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGrey5,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "about_work".tr(),
          style: const TextStyle(color: Colors.black, shadows: [
            Shadow(color: Colors.white, blurRadius: 10),
          ]),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: ListView(
            children: [
              SizedBox(
                height: 340,
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ...List.generate(
                      widget.hireModel.image.length,
                      (index) => Row(
                        children: [
                          SizedBox(
                            width: 10.w,
                          ),
                          ZoomTapAnimation(
                            onTap: () {
                              showImageViewer(
                                context,
                                CachedNetworkImageProvider(
                                  widget.hireModel.image[index].imageUrl,
                                ),
                                swipeDismissible: true,
                                doubleTapZoomable: true,
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        spreadRadius: 3,
                                        blurRadius: 10,
                                        color: CupertinoColors.systemGrey4)
                                  ],
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                      width: 4.w, color: Colors.white)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.r),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      widget.hireModel.image[index].imageUrl,
                                  width:
                                      MediaQuery.sizeOf(context).width - 30.w,
                                  fit: BoxFit.cover,
                                  height: 300,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              20.getH(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  widget.hireModel.title,
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),
              ),
              10.getH(),
              const Divider(),
              10.getH(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  widget.hireModel.description,
                  style:
                      TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
                ),
              ),
              10.getH(),
              const Divider(),
              10.getH(),
              Text(
                widget.hireModel.number,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp),
              ),
              10.getH(),
              const Divider(),
              10.getH(),
              Row(
                children: [
                  Icon(CupertinoIcons.eye_fill),
                  Text(widget.hireModel.countView.toString())
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
