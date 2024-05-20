import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/data/models/announcement.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../blocs/announcement_bloc/hire_bloc.dart';
import '../../../../blocs/announcement_bloc/hire_event.dart';
import '../detail/detail_screen.dart';

class HiringItem extends StatefulWidget {
  const HiringItem({
    super.key,
    required this.hires,
    required this.scrollController,
  });

  final List<AnnouncementModel> hires;
  final ScrollController scrollController;

  @override
  State<HiringItem> createState() => _HiringItemState();
}

class _HiringItemState extends State<HiringItem> {
  // Maintain the activeIndex state inside each HiringItem
  List<int> activeIndexes = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  init() {
    activeIndexes = List.filled(widget.hires.length, 0);
  }

  @override
  Widget build(BuildContext context) {
    return activeIndexes.isNotEmpty
        ? GridView.builder(
            controller: widget.scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 0.8,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            itemCount: widget.hires.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index1) {
              return GestureDetector(
                onTap: () async {
                  context.read<AnnouncementBloc>().add(
                        AnnouncementUpdateEvent(
                          hireModel: widget.hires[index1].copyWith(
                            countView:
                                widget.hires[index1].countView + ["salom"],
                          ),
                        ),
                      );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        hireModel: widget.hires[index1].copyWith(
                          countView: widget.hires[index1].countView,
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
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
                            height: 300,
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
                                                          BorderRadius.circular(
                                                              16),
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
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                  ),
                                                );
                                              },
                                              imageUrl: widget.hires[index1]
                                                  .image[index].imageUrl,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
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
                                  bottom: 15,
                                  right: 15,
                                  child: Row(
                                    children: [
                                      ...List.generate(
                                          widget.hires[index1].image.length,
                                          (index) {
                                        return AnimatedContainer(
                                          curve: Curves.linear,
                                          duration:
                                              const Duration(milliseconds: 200),
                                          margin: const EdgeInsets.all(2),
                                          width: activeIndexes[index1] != index
                                              ? 8
                                              : 10,
                                          height: activeIndexes[index1] != index
                                              ? 8
                                              : 10,
                                          decoration: BoxDecoration(
                                              boxShadow: const [
                                                BoxShadow(
                                                  spreadRadius: 1,
                                                  blurRadius: 0,
                                                  color: 1 == 2
                                                      ? Color(0xFFBDBDBD)
                                                      : Colors.black,
                                                )
                                              ],
                                              shape: BoxShape.circle,
                                              color:
                                                  activeIndexes[index1] != index
                                                      ? Colors.white
                                                      : Colors.black),
                                        );
                                      })
                                    ],
                                  ),
                                )
                              : const SizedBox()
                        ],
                      ),
                      Text(
                        widget.hires[index1].title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.hires[index1].money,
                        style: TextStyle(
                          fontSize: 19.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.eye_solid,
                            color: CupertinoColors.black.withOpacity(.6),
                          ),
                          3.getW(),
                          Text(
                            widget.hires[index1].countView.length.toString(),
                            style: TextStyle(
                              color: CupertinoColors.black.withOpacity(.6),
                            ),
                          ),
                          6.getW(),
                          Text(
                            DateFormat("HH:mm").format(
                              DateTime.fromMillisecondsSinceEpoch(
                                int.parse(
                                    widget.hires[index1].createdAt.toString()),
                              ),
                            ),
                            style: TextStyle(
                                color: CupertinoColors.black.withOpacity(.6)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        : FutureBuilder(
            future: Future.delayed(const Duration(seconds: 1), () {
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
