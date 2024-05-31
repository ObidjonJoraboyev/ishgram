import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ish_top/blocs/announcement_bloc/hire_bloc.dart';
import 'package:ish_top/blocs/announcement_bloc/hire_event.dart';
import 'package:ish_top/data/local/local_storage.dart';
import 'package:ish_top/data/models/announcement_model.dart';
import 'package:ish_top/ui/tab/announcement/detail/widgets/widget_detail.dart';
import 'package:shimmer/shimmer.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.hireModel});

  final AnnouncementModel hireModel;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFirstIcon = false;

  String userNum = StorageRepository.getString(key: "userNumber");

  Set<String> ls = {};

  void _toggleIcon() {
    if (userNum.isNotEmpty) {
      setState(() {
        isFirstIcon = !isFirstIcon;
        if (isFirstIcon) {
          ls.add(userNum);
          context.read<AnnouncementBloc>().add(
                AnnouncementUpdateEvent(
                  hireModel: widget.hireModel.copyWith(
                    likedUsers: ls,
                  ),
                ),
              );
          setState(() {});
        }
        if (!isFirstIcon && widget.hireModel.likedUsers.contains(userNum)) {
          context.read<AnnouncementBloc>().add(
                AnnouncementUpdateEvent(
                  hireModel: widget.hireModel.copyWith(
                    likedUsers: widget.hireModel.likedUsers
                        .where((element) => element != userNum)
                        .toSet(),
                  ),
                ),
              );
          setState(() {});
        }
      });
    } else {}
  }

  @override
  void initState() {
    ls = widget.hireModel.likedUsers;
    isFirstIcon = widget.hireModel.likedUsers.contains(userNum);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: CupertinoColors.systemGrey6,
        elevation: 0,
        actions: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Padding(
              key: ValueKey<bool>(isFirstIcon),
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: _toggleIcon,
                child: Padding(
                  padding: EdgeInsets.only(top: 3.h),
                  child: SvgPicture.asset(
                    !isFirstIcon
                        ? "assets/icons/save.svg"
                        : "assets/icons/save_fill.svg",
                    width: 30.w,
                    height: 34.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
        scrolledUnderElevation: 0,
        title: Text(
          "about_work".tr(),
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 20.sp),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: CupertinoColors.systemGrey5,
      body: Stack(
        children: [
          ListView(
            children: [
              SizedBox(
                height: 340.h,
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ...List.generate(
                      widget.hireModel.image.length,
                      (index) => Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showImageViewerPager(
                                swipeDismissible: true,
                                doubleTapZoomable: true,
                                useSafeArea: false,
                                immersive: true,
                                infinitelyScrollable: false,
                                backgroundColor: Colors.black,
                                closeButtonTooltip: "",
                                context,
                                MultiImageProvider(
                                  [
                                    ...List.generate(
                                      widget.hireModel.image.length,
                                      (index) => CachedNetworkImageProvider(
                                        widget.hireModel.image[index].imageUrl,
                                        maxWidth: MediaQuery.sizeOf(context)
                                            .width
                                            .toInt(),
                                        maxHeight: 800.h.toInt(),
                                      ),
                                    )
                                  ],
                                ),
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
                                borderRadius: BorderRadius.circular(17.r),
                              ),
                              child: Hero(
                                tag: "image$index",
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(16.r),
                                      topLeft: Radius.circular(16.r)),
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
                                    width: MediaQuery.sizeOf(context).width,
                                    fit: BoxFit.cover,
                                    height: 340.h,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: WidgetOfDetail(hireModel: widget.hireModel),
              )
            ],
          ),
        ],
      ),
    );
  }
}
