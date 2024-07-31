import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/announ_bloc/announ_bloc.dart';
import 'package:ish_top/blocs/announ_bloc/announ_state.dart';
import 'package:ish_top/data/models/announ_model.dart';
import 'package:ish_top/ui/tab/announ/widgets/announ_item.dart';

class QrUserAnnounsScree extends StatefulWidget {
  const QrUserAnnounsScree({super.key, required this.statusAnnoun});

  final StatusAnnoun statusAnnoun;

  @override
  State<QrUserAnnounsScree> createState() => _QrUserAnnounsScreeState();
}

class _QrUserAnnounsScreeState extends State<QrUserAnnounsScree> {
  List<AnnounModel> announs = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AnnounBloc, AnnounState>(
      listener: (context, state) {},
      builder: (context, state) {
        announs = state.qrHires
            .where((c) => c.status == widget.statusAnnoun)
            .toList();
        return Scaffold(
          backgroundColor: CupertinoColors.systemGrey6,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
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
            scrolledUnderElevation: 0,
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            backgroundColor: Colors.white.withOpacity(.9),
            title: Text("hires".tr()),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: ListView(
              children: [
                ...List.generate(announs.length, (index) {
                  return HiringItem(
                      hires: announs[index],
                      voidCallback: () {},
                      scrollController: ScrollController(),
                      context1: context);
                })
              ],
            ),
          ),
        );
      },
    );
  }
}
