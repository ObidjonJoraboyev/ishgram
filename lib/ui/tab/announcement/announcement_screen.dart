import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/data/models/announcement.dart';
import '../../../blocs/announcement_bloc/hire_bloc.dart';
import 'detail_screen.dart';

class HireScreen extends StatefulWidget {
  const HireScreen({super.key});

  @override
  State<HireScreen> createState() => _HireScreenState();
}

class _HireScreenState extends State<HireScreen> {
  FocusNode focus = FocusNode();
  final TextEditingController controller = TextEditingController();
  String text = "";

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
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
                      padding: EdgeInsets.only(
                          top: 14,
                          left: 12,
                          bottom: 8,
                          right: focus.hasFocus ? 0 : 12),
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
                  focus.hasFocus
                      ? CupertinoTextSelectionToolbarButton(
                          child: Text(
                            "cancel".tr(),
                            style: const TextStyle(color: Colors.blue),
                          ),
                          onPressed: () {
                            text = "";
                            controller.text = "";
                            setState(() {});
                            focus.unfocus();
                          },
                        )
                      : const SizedBox(),
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
          return ListView(
            physics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.normal),
            children: [
              ...List.generate(
                hires.length,
                (index) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                hireModel: hires[index],
                              ),
                            ),
                          );
                        },
                        title: Text(hires[index].title),
                        subtitle: Text(
                          hires[index].description,
                          style: TextStyle(color: Colors.black.withOpacity(.5)),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 0.55,
                        color: Colors.black.withOpacity(.6),
                      )
                    ],
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }
}
