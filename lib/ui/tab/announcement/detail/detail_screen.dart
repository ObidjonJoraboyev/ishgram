import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/data/models/announcement.dart';
import 'package:ish_top/ui/tab/announcement/detail/widgets/widget_detail.dart';
import 'package:shimmer/shimmer.dart';
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
      body: ListView(
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
                                    borderRadius: BorderRadius.circular(16.r),
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
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                ),
                              );
                            },
                            imageUrl: widget.hireModel.image[index].imageUrl,
                            width: MediaQuery.sizeOf(context).width,
                            fit: BoxFit.cover,
                            height: 300,
                          ),
                        ),
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
    );
  }
}
