import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/announ_bloc/announ_bloc.dart';
import 'package:ish_top/blocs/announ_bloc/announ_event.dart';
import 'package:ish_top/blocs/announ_bloc/announ_state.dart';
import 'package:ish_top/blocs/user/user_bloc.dart';
import 'package:ish_top/blocs/user/user_event.dart';
import 'package:ish_top/blocs/user/user_state.dart';
import 'package:ish_top/data/models/announ_model.dart';
import 'package:ish_top/data/models/user_model.dart';
import 'package:ish_top/ui/start_chat/start_chat_screen.dart';
import 'package:ish_top/ui/tab/announ/widgets/announ_item.dart';
import 'package:ish_top/ui/tab/announ/widgets/search_item.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController workCtrl = TextEditingController();
  final TextEditingController workerCtrl = TextEditingController();
  FocusNode focusNode = FocusNode();

  List<UserModel> users = [];
  List<AnnounModel> announs = [];
  String selectedSearching = "work";

  @override
  void initState() {
    context.read<UserBloc>().add(GetAllUsers());
    context.read<AnnounBloc>().add(AnnounGetEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {},
      builder: (context, stateUser) {
        users = stateUser.users
            .where((c) => c.name.contains(workerCtrl.text))
            .toList();
        return BlocConsumer<AnnounBloc, AnnounState>(
          listener: (context, state) {},
          builder: (context, stateAnn) {
            announs = stateAnn.allHires
                .where((v) => v.title.contains(workCtrl.text))
                .toList();
            return Scaffold(
              backgroundColor: CupertinoColors.systemGrey6,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                scrolledUnderElevation: 0,
                titleSpacing: 0,
                centerTitle: false,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 18.sp,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: SearchItem(
                        controller:
                            selectedSearching == "work" ? workCtrl : workerCtrl,
                        focus: focusNode,
                        valueChanged: (v) {
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                elevation: 0,
                bottom: PreferredSize(
                  preferredSize: Size(
                    MediaQuery.sizeOf(context).width,
                    0.6.h,
                  ),
                  child: Container(
                    height: 0.6.h,
                    width: double.infinity,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
                flexibleSpace: ClipRect(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        color: Colors.white.withOpacity(.8),
                      ),
                    ),
                  ),
                ),
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.w),
                child: RefreshIndicator.adaptive(
                  strokeWidth: 12,
                  onRefresh: () async {
                    selectedSearching == "work"
                        ? context.read<AnnounBloc>().add(AnnounGetEvent())
                        : context.read<UserBloc>().add(GetAllUsers());
                  },
                  child: Column(
                    children: [
                      10.getH(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: CupertinoSlidingSegmentedControl(
                                children: <Object, Widget>{
                                  "work": Text("work".tr()),
                                  "worker": Text("workers".tr()),
                                },
                                onValueChanged: (v) {
                                  setState(() {
                                    selectedSearching = v.toString();
                                  });
                                },
                                groupValue: selectedSearching,
                              ),
                            ),
                          ],
                        ),
                      ),
                      10.getH(),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          switchInCurve: Curves.linear,
                          switchOutCurve: Curves.linear,
                          child: selectedSearching == "work"
                              ? ListView.builder(
                                  key: const ValueKey<String>('work'),
                                  itemCount: announs.length,
                                  itemBuilder: (context, index) {
                                    return HiringItem(
                                      hires: announs[index],
                                      voidCallback: () {},
                                      scrollController: ScrollController(),
                                      context1: context,
                                    );
                                  },
                                )
                              : ListView.builder(
                                  key: const ValueKey<String>('worker'),
                                  itemCount: users.length,
                                  itemBuilder: (context, index) {
                                    UserModel userModel = users[index];
                                    return Column(
                                      children: [
                                        CupertinoListTile(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.h, horizontal: 15.w),
                                          subtitle: userModel.bio.isNotEmpty
                                              ? Text(userModel.bio)
                                              : const SizedBox(),
                                          additionalInfo:
                                              Text(userModel.rating.toString()),
                                          leadingSize: 30.sp,
                                          leading: SizedBox(
                                            height: 90.sp,
                                            width: 90.sp,
                                            child: GestureDetector(
                                              child: userModel.image.isEmpty
                                                  ? Container(
                                                      width: 90.sp,
                                                      height: 90.sp,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        gradient:
                                                            LinearGradient(
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                          colors: [
                                                            Color(
                                                              int.tryParse(userModel
                                                                          .color) !=
                                                                      null
                                                                  ? int.parse(
                                                                      userModel
                                                                          .color)
                                                                  : CupertinoColors
                                                                      .activeBlue
                                                                      .value,
                                                            ).withOpacity(.6),
                                                            Color(
                                                              int.tryParse(userModel
                                                                          .color) !=
                                                                      null
                                                                  ? int.parse(
                                                                      userModel
                                                                          .color)
                                                                  : CupertinoColors
                                                                      .activeBlue
                                                                      .value,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      child: userModel
                                                              .name.isNotEmpty
                                                          ? Center(
                                                              child: Text(
                                                                userModel
                                                                    .name[0]
                                                                    .toUpperCase(),
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        16.sp,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                    )
                                                  : Padding(
                                                      padding: EdgeInsets.zero,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              userModel.image,
                                                          height: 80.w,
                                                          width: 80.w,
                                                          fit: BoxFit.cover,
                                                          placeholder: (b, w) {
                                                            return Shimmer
                                                                .fromColors(
                                                              baseColor:
                                                                  Colors.white,
                                                              highlightColor:
                                                                  Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          .3),
                                                              child: Container(
                                                                height: 80.h,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16)),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    StartChatScreen(
                                                  userModel: userModel,
                                                ),
                                              ),
                                            );
                                          },
                                          title: Text(users[index].name),
                                        ),
                                        Container(
                                          color: CupertinoColors.systemGrey,
                                          width: double.infinity,
                                          height: 0.3,
                                        )
                                      ],
                                    );
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
