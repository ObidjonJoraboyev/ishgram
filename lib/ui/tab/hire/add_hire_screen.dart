import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/blocs/hire_bloc/hire_bloc.dart';
import 'package:ish_top/blocs/hire_bloc/hire_event.dart';
import 'package:ish_top/data/models/hire_model.dart';

class AddHireScreen extends StatelessWidget {
  AddHireScreen({super.key});

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController numberCtrl = TextEditingController();
  final TextEditingController ownerCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("add_hire".tr()),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: TextField(
              controller: nameCtrl,
              style: TextStyle(
                  color: Colors.white.withOpacity(.6),
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.end,
              cursorColor: Colors.white,
              cursorWidth: 3,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.white.withOpacity(.6)),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 16, top: 10, bottom: 10),
                  child: Text(
                    "work_name".tr(),
                    style: TextStyle(
                        shadows: [Shadow(blurRadius: 0.5)],
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 19),
                  ),
                ),
                contentPadding: const EdgeInsets.only(right: 12),
                fillColor: Colors.grey.withOpacity(.9),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0, color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0, color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: TextField(
              controller: descriptionCtrl,
              style: TextStyle(
                  color: Colors.white.withOpacity(.6),
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.end,
              cursorColor: Colors.white,
              cursorWidth: 3,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.white.withOpacity(.6)),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 16, top: 10, bottom: 10),
                  child: Text(
                    "about_work".tr(),
                    style: TextStyle(
                        shadows: [Shadow(blurRadius: 0.5)],
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 19),
                  ),
                ),
                contentPadding: const EdgeInsets.only(right: 12),
                fillColor: Colors.grey.withOpacity(.9),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0, color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0, color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: TextField(
              controller: ownerCtrl,
              style: TextStyle(
                  color: Colors.white.withOpacity(.6),
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.end,
              cursorColor: Colors.white,
              cursorWidth: 3,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.white.withOpacity(.6)),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 16, top: 10, bottom: 10),
                  child: Text(
                    "your_name".tr(),
                    style: TextStyle(
                        shadows: [Shadow(blurRadius: 0.5)],
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 19),
                  ),
                ),
                contentPadding: const EdgeInsets.only(right: 12),
                fillColor: Colors.grey.withOpacity(.9),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0, color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0, color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: TextField(
              controller: numberCtrl,
              style: TextStyle(
                  color: Colors.white.withOpacity(.6),
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.end,
              cursorColor: Colors.white,
              cursorWidth: 3,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.white.withOpacity(.6)),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 16, top: 10, bottom: 10),
                  child: Text(
                    "phone_number".tr(),
                    style: TextStyle(
                        shadows: [Shadow(blurRadius: 0.5)],
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 19),
                  ),
                ),
                contentPadding: const EdgeInsets.only(right: 12),
                fillColor: Colors.grey.withOpacity(.9),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0, color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0, color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          TextButton(
              onPressed: () async {
                context.read<HireBloc>().add(HireAddEvent(
                    hireModel: HireModel(
                        ownerName: ownerCtrl.text,
                        title: nameCtrl.text,
                        docId: "",
                        description: descriptionCtrl.text,
                        money: 0,
                        timeInterval: "",
                        image: "",
                        isActive: false,
                        lat: 1,
                        long: 0,
                        number: numberCtrl.text,
                        category: WorkCategory.easy)));
                Navigator.pop(context);
              },
              child: Text("add".tr()))
        ],
      ),
    );
  }
}
