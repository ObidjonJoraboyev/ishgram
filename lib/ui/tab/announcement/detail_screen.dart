import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
              TextButton(
                onPressed: () async {
                  try {
                    await FirebaseStorage.instance
                        .ref(
                            "files/images/image_picker_0561379A-FAED-4DF2-8568-3434C180F111-14860-000000623ADAD7F2.jpg")
                        .delete();
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                },
                child: const Text("DELETE"),
              ),
              SizedBox(
                height: 300,
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
                                Image.network(
                                  widget.hireModel.image[index].imageUrl,
                                  width: MediaQuery.sizeOf(context).width,
                                  fit: BoxFit.cover,
                                  height: 300.h,
                                ).image,
                                swipeDismissible: true,
                                doubleTapZoomable: true,
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: CachedNetworkImage(
                                imageUrl:
                                    widget.hireModel.image[index].imageUrl,
                                width: MediaQuery.sizeOf(context).width - 20.w,
                                fit: BoxFit.cover,
                                height: 300,
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
            ],
          ),
        ),
      ),
    );
  }
}
