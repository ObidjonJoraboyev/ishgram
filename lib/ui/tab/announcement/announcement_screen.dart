import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ish_top/blocs/announcement_bloc/hire_event.dart';
import 'package:ish_top/blocs/connectivity/connectivity_bloc.dart';
import 'package:ish_top/blocs/connectivity/connectivity_state.dart';
import 'package:ish_top/data/models/announcement.dart';
import 'package:ish_top/ui/tab/announcement/widgets/hiring_item.dart';
import 'package:ish_top/ui/tab/announcement/widgets/search_item.dart';
import 'package:ish_top/utils/size/size_utils.dart';
import '../../../blocs/announcement_bloc/hire_bloc.dart';

class HireScreen extends StatefulWidget {
  const HireScreen({super.key});

  @override
  State<HireScreen> createState() => _HireScreenState();
}

class _HireScreenState extends State<HireScreen>
    with SingleTickerProviderStateMixin {
  FocusNode focus = FocusNode();
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  int activeIndex = 0;

  bool check = false;
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
        backgroundColor: CupertinoColors.systemGrey5,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: CupertinoColors.systemGrey5,
          title: Text("hires".tr()),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {});
              },
            )
          ],
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 50),
            child: Column(
              children: [
                SearchItem(
                  controller: controller,
                  focus: focus,
                  valueChanged: (value) {
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
        body: BlocConsumer<ConnectBloc, ConnectState>(
          listener: (context, state) {},
          builder: (context, state) {
            return BlocBuilder<AnnouncementBloc, List<AnnouncementModel>>(
              builder: (BuildContext context, List<AnnouncementModel> state) {
                List<AnnouncementModel> hires = state
                    .where((element) => element.title
                        .toLowerCase()
                        .contains(controller.text.toLowerCase()))
                    .toList();
                return RefreshIndicator.adaptive(
                  onRefresh: () async {
                    context
                        .read<AnnouncementBloc>()
                        .add(AnnouncementGetEvent());
                    setState(() {});
                  },
                  child: Scrollbar(
                    thickness: 5.w,
                    controller: scrollController,
                    radius: const Radius.circular(19),
                    child: Column(
                      children: [
                        Expanded(
                          child: HiringItem(
                            voidCallback: () {
                              focus.unfocus();
                              setState(() {});
                            },
                            hires: hires,
                            scrollController: scrollController,
                          ),
                        ),
                      ],
                    ),
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
