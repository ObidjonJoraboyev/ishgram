import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/announcement_bloc/hire_state.dart';
import 'package:ish_top/blocs/connectivity/connectivity_bloc.dart';
import 'package:ish_top/blocs/connectivity/connectivity_state.dart';
import 'package:ish_top/data/models/announcement_model.dart';
import 'package:ish_top/ui/tab/announcement/widgets/hiring_item.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import '../../../../blocs/announcement_bloc/hire_bloc.dart';

class HireScreen extends StatefulWidget {
  const HireScreen(
      {super.key,
      required this.context,
      required this.focus,
      required this.controller});
  final BuildContext context;
  final FocusNode focus;
  final TextEditingController controller;
  @override
  State<HireScreen> createState() => _HireScreenState();
}

class _HireScreenState extends State<HireScreen> {
  final ScrollController scrollController = ScrollController();
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.sizeOf(context).width;
    height = MediaQuery.sizeOf(context).height;
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: CupertinoColors.systemGrey5,
        body: BlocConsumer<ConnectBloc, ConnectState>(
          listener: (context, state) {},
          builder: (context, state) {
            return BlocBuilder<AnnouncementBloc, AnnounState>(
              builder: (BuildContext context, AnnounState state) {
                List<AnnouncementModel> hires = state.allHires
                    .where((element) => element.title
                        .toLowerCase()
                        .contains(widget.controller.text.toLowerCase()))
                    .toList();
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: ListView(
                    children: [
                      ...List.generate(hires.length, (index) {
                        return HiringItem(
                          context1: widget.context,
                          voidCallback: () {
                            widget.focus.unfocus();
                            setState(() {});
                          },
                          hires: hires[index],
                          scrollController: scrollController,
                        );
                      })
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
