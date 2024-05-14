import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/data/models/announcement.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../../../blocs/announcement_bloc/hire_bloc.dart';
import 'detail_screen.dart';

class HireScreen extends StatefulWidget {
  const HireScreen({super.key});

  @override
  State<HireScreen> createState() => _HireScreenState();
}

class _HireScreenState extends State<HireScreen>
    with SingleTickerProviderStateMixin {
  FocusNode focus = FocusNode();
  final TextEditingController controller = TextEditingController();
  String text = "";

  final user = FirebaseAuth.instance.currentUser;

  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );

    animation = Tween<double>(begin: 0, end: 16).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.linear,
        reverseCurve: Curves.linear,
      ),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {});
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.sizeOf(context).width;
    height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: CupertinoColors.systemGrey5,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: CupertinoColors.systemGrey5,
        title: Text("hires".tr()),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 50),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 14, left: 12, bottom: 8, right: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 1,
                              blurRadius: 16,
                              color:
                                  CupertinoColors.systemGrey4.withOpacity(.5),
                            )
                          ],
                        ),
                        child: CupertinoTextField(
                          controller: controller,
                          onChanged: (v) {
                            text = v;
                            setState(() {});
                          },
                          prefix: Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Icon(
                              Icons.search,
                              color: Colors.black.withOpacity(.4),
                            ),
                          ),
                          onTap: () {
                            animationController.forward();
                            animationController.isCompleted
                                ? animationController.stop()
                                : null;
                            focus.requestFocus();
                            setState(() {});
                          },
                          cursorColor: Colors.blue,
                          focusNode: focus,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          placeholder: "search".tr(),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: CupertinoColors.systemGrey6,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ZoomTapAnimation(
                    onTap: () {
                      text = "";
                      controller.text = "";
                      setState(() {});
                      animationController.reverse();
                      focus.unfocus();
                    },
                    child: Text(
                      "cancel".tr(),
                      style: TextStyle(
                          color: Colors.blue, fontSize: animation.value),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(right: focus.hasFocus ? 12 : 0))
                ],
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<AnnouncementBloc, List<AnnouncementModel>>(
        builder: (BuildContext context, List<AnnouncementModel> state) {
          List<AnnouncementModel> hires = state
              .where((element) =>
                  element.title.toLowerCase().contains(text.toLowerCase()))
              .toList();
          return GridView.count(
            crossAxisCount: 1,
            childAspectRatio: 0.8,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            children: [
              ...List.generate(
                hires.length,
                (index1) => ZoomTapAnimation(
                  end: 1,
                  begin: 1,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          hireModel: hires[index1],
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
                            color: CupertinoColors.systemGrey.withOpacity(.1))
                      ],
                      color: CupertinoColors.white.withOpacity(.9),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 300,
                          child: hires[index1].image.isNotEmpty
                              ? PageView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    ...List.generate(
                                      hires[index1].image.length,
                                      (index) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: CachedNetworkImage(
                                            placeholder: (context, st) {
                                              return Image.asset(
                                                "assets/images/back.webp",
                                                height: 100,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                            errorWidget: (BuildContext context,
                                                String st, a) {
                                              return Image.asset(
                                                "assets/images/back.webp",
                                                height: 100,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                            imageUrl: hires[index1]
                                                .image
                                                .firstOrNull
                                                .toString(),
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : const Text("hvbk"),
                        ),
                        Text(
                          hires[index1].title,
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.w500),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          hires[index1].money,
                          style: TextStyle(
                              fontSize: 19.sp, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Text(
                              DateFormat("HH:mm").format(
                                DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(
                                    hires[index1].createdAt.toString(),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
