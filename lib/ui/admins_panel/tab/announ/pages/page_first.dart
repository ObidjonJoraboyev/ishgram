import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/announ_bloc/announ_bloc.dart';
import 'package:ish_top/blocs/announ_bloc/announ_state.dart';
import 'package:ish_top/blocs/connectivity/connectivity_bloc.dart';
import 'package:ish_top/blocs/connectivity/connectivity_state.dart';
import 'package:ish_top/data/models/announ_model.dart';
import 'package:ish_top/ui/admins_panel/tab/announ/widgets/announ_item_ipad.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import '../widgets/announ_item.dart';

class AdminHireScreen extends StatefulWidget {
  const AdminHireScreen(
      {super.key,
      required this.context,
      required this.focus,
      required this.controller,
      required this.statusAnnoun});

  final BuildContext context;
  final FocusNode focus;
  final TextEditingController controller;
  final StatusAnnoun statusAnnoun;

  @override
  State<AdminHireScreen> createState() => _AdminHireScreenState();
}

class _AdminHireScreenState extends State<AdminHireScreen> {
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
            return BlocBuilder<AnnounBloc, AnnounState>(
              builder: (BuildContext context, AnnounState state) {
                List<AnnounModel> hires = state.allHires
                    .where((element) =>
                        element.title
                            .toLowerCase()
                            .contains(widget.controller.text.toLowerCase()) &&
                        element.status == widget.statusAnnoun)
                    .toList();
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: ListView(
                    children: [
                      ...List.generate(
                        hires.length,
                        (index) {
                          return
                              //(width <400) &
                              //                           (hires.length % 2 != 0) &
                              //                           (hires.length <= index + 2)
                              1 == 1
                                  ? AdminHiringItem(
                                      context1: widget.context,
                                      voidCallback: () {
                                        widget.focus.unfocus();
                                        setState(() {});
                                      },
                                      hires: hires[index],
                                      scrollController: scrollController,
                                    )
                                  : AdminHiringItemIpad(
                                      context1: widget.context,
                                      voidCallback: () {
                                        widget.focus.unfocus();
                                        setState(() {});
                                      },
                                      announOne: hires[index],
                                      scrollController: scrollController,
                                      announTwo: null,
                                    );
                        },
                      )
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
