import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/data/models/announcement.dart';
import 'package:ish_top/ui/tab/announcement/detail/widgets/widget_detail.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
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
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.transparent,
        title: Text(
          "about_work".tr(),
          style: const TextStyle(color: Colors.black, shadows: [
            Shadow(color: Colors.white, blurRadius: 10),
          ]),
        ),
      ),
      backgroundColor: CupertinoColors.systemGrey5,
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
                                  borderRadius: BorderRadius.circular(18.r),
                                  border: Border.all(
                                    width: 2.w,
                                    color: Colors.white,
                                  )),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.r),
                                child: CachedNetworkImage(
                                  placeholder: (v, w) {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.white,
                                      highlightColor: Colors.grey,
                                      child: Container(
                                        height: 80.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16.r),
                                        ),
                                      ),
                                    );
                                  },
                                  errorWidget: (v, w, d) {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.white,
                                      highlightColor: Colors.grey,
                                      child: Container(
                                        height: 80.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16.r),
                                        ),
                                      ),
                                    );
                                  },
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
              WidgetOfDetail(hireModel: widget.hireModel)
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> launchCaller(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
  } else {
    throw 'Could not launch $launchUri';
  }
}
