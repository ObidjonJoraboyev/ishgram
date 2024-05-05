import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/blocs/hire_bloc/hire_state.dart';
import 'package:ish_top/data/local/local_storage.dart';
import 'package:ish_top/data/models/hire_model.dart';
import 'package:ish_top/ui/auth/auth_screen.dart';
import 'package:ish_top/ui/tab/hire/add_hire_screen.dart';
import 'package:ish_top/ui/tab/hire/detail_screen.dart';

import '../../../blocs/hire_bloc/hire_bloc.dart';

class HireScreen extends StatefulWidget {
  const HireScreen({super.key});

  @override
  State<HireScreen> createState() => _HireScreenState();
}

class _HireScreenState extends State<HireScreen> {
  FocusNode focus = FocusNode();
  final TextEditingController controller = TextEditingController();
  String text = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGrey5,
      appBar: AppBar(
        backgroundColor: CupertinoColors.systemGrey5,
        title: const Text("Elonlar"),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () async {
              !StorageRepository.getBool(key: "isLogin")
                  ? showDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: const Text("Login"),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text(
                              'Orqaga',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: CupertinoColors.activeBlue),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                          ),
                          CupertinoDialogAction(
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: CupertinoColors.activeBlue),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          const AuthScreen()));
                            },
                          ),
                        ],
                        content: const Text(
                          "Siz e'lon qo'shish uchun login qilmagansiz.",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  : Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => AddHireScreen()));
            },
            icon: const Icon(CupertinoIcons.add),
          )
        ],
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
                                    CupertinoColors.systemGrey4.withOpacity(.5))
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
                          placeholder: " Qidirish",
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
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.blue),
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
      body: BlocBuilder<HireBloc, HireState>(
        builder: (BuildContext context, HireState state) {
          if (state is HireGetState) {
            List<HireModel> hires = state.hires
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
                              CupertinoPageRoute(
                                builder: (context) => DetailScreen(
                                  hireModel: hires[index],
                                ),
                              ),
                            );
                          },
                          title: Text(hires[index].title),
                          subtitle: Text(
                            hires[index].description,
                            style:
                                TextStyle(color: Colors.black.withOpacity(.5)),
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
          }
          if (state is HireLoadingState) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          return SizedBox(
            child: Text(
              state.runtimeType.toString(),
              style: const TextStyle(fontSize: 32, letterSpacing: 4),
            ),
          );
        },
      ),
    );
  }
}
