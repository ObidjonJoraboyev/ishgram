import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/data/local/local_storage.dart';
import 'package:ish_top/data/models/announcement.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../blocs/announcement_bloc/hire_bloc.dart';
import '../../../../blocs/announcement_bloc/hire_event.dart';
import '../detail/detail_screen.dart';

class HiringItem extends StatefulWidget {
  const HiringItem({
    super.key,
    required this.hires,
    required this.voidCallback,
    required this.scrollController,
  });

  final List<AnnouncementModel> hires;
  final ScrollController scrollController;
  final VoidCallback voidCallback;

  @override
  State<HiringItem> createState() => _HiringItemState();
}

class _HiringItemState extends State<HiringItem> {
  List<int> activeIndexes = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  init() {
    activeIndexes = List.filled(widget.hires.length, 0);
  }

  String userNum = StorageRepository.getString(key: "userNumber");

  @override
  Widget build(BuildContext context) {
    return activeIndexes.isNotEmpty
        ? ListView(
            shrinkWrap: true,
            controller: widget.scrollController,
            scrollDirection: Axis.vertical,
            children: [
              ...List.generate(widget.hires.length, (index1) {
                return GestureDetector(
                  onTap: () async {
                    (!widget.hires[index1].countView.contains(userNum)) &&
                            (userNum.isNotEmpty)
                        ? context.read<AnnouncementBloc>().add(
                              AnnouncementUpdateEvent(
                                hireModel: widget.hires[index1].copyWith(
                                  countView: widget.hires[index1].countView +
                                      [userNum],
                                ),
                              ),
                            )
                        : null;

                    widget.voidCallback.call();

                    Platform.isIOS
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                hireModel: widget.hires[index1].copyWith(
                                  countView: widget.hires[index1].countView,
                                ),
                              ),
                            ),
                          )
                        : Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeftJoined,
                              alignment: Alignment.topRight,
                              childCurrent: const SizedBox(),
                              child: DetailScreen(
                                hireModel: widget.hires[index1].copyWith(
                                  countView: widget.hires[index1].countView,
                                ),
                              ),
                            ),
                          );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 12.h),
                    padding: EdgeInsets.all(7.sp),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 10,
                          color: CupertinoColors.systemGrey.withOpacity(.1),
                        )
                      ],
                      color: CupertinoColors.white.withOpacity(.9),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              height: 300.h,
                              child: widget.hires[index1].image.isNotEmpty
                                  ? PageView(
                                      onPageChanged: (index) {
                                        setState(() {
                                          activeIndexes[index1] = index;
                                        });
                                      },
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        ...List.generate(
                                          widget.hires[index1].image.length,
                                          (index) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: CachedNetworkImage(
                                                placeholder: (context, st) {
                                                  return Shimmer.fromColors(
                                                    baseColor: Colors.white,
                                                    highlightColor: Colors.grey,
                                                    child: Container(
                                                      height: 80.h,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                errorWidget:
                                                    (BuildContext context,
                                                        String st, a) {
                                                  return Shimmer.fromColors(
                                                    baseColor: Colors.white,
                                                    highlightColor: Colors.grey,
                                                    child: Container(
                                                      height: 80.h,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                imageUrl: widget.hires[index1]
                                                    .image[index].imageUrl,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: 300.h,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Text("No Image"),
                            ),
                            widget.hires[index1].image.length > 1
                                ? Positioned(
                                    bottom: 15.w,
                                    right: 15.w,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.w, vertical: 2.w),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: CupertinoColors.systemGrey6,
                                      ),
                                      child: Row(
                                        children: [
                                          ...List.generate(
                                            widget.hires[index1].image.length,
                                            (index) {
                                              return AnimatedContainer(
                                                curve: Curves.linear,
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                margin: EdgeInsets.all(1.sp),
                                                width: activeIndexes[index1] !=
                                                        index
                                                    ? 6.sp
                                                    : 7.sp,
                                                height: activeIndexes[index1] !=
                                                        index
                                                    ? 6.sp
                                                    : 7.sp,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color:
                                                        activeIndexes[index1] !=
                                                                index
                                                            ? Colors.grey
                                                            : CupertinoColors
                                                                .activeBlue),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.w),
                          child: Text(
                            widget.hires[index1].title,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.w, top: 3.h),
                          child: Text(
                            widget.hires[index1].money,
                            style: TextStyle(
                              fontSize: 19.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              widget.hires[index1].countView.length.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: CupertinoColors.black.withOpacity(.6),
                              ),
                            ),
                            5.getW(),
                            Icon(
                              CupertinoIcons.eye_solid,
                              color: CupertinoColors.black.withOpacity(.6),
                            ),
                            12.getW(),
                            Text(
                              timeago.format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(widget.hires[index1].createdAt
                                        .toString()),
                                  ),
                                  locale: "uz"),
                              style: TextStyle(
                                  color: CupertinoColors.black.withOpacity(.6),
                                  fontWeight: FontWeight.w500),
                            ),
                            8.getW()
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          )
        : FutureBuilder(
            future: Future.delayed(const Duration(microseconds: 1), () {
              init();
              setState(() {});
            }),
            builder: (c, d) {
              return const Center(
                child: CircularProgressIndicator.adaptive(
                  strokeWidth: 20,
                ),
              );
            },
          );
  }
}
