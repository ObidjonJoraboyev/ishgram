import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ish_top/data/models/announcement.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.hireModel});

  final AnnouncementModel hireModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGrey5,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "about_work".tr(),
          style: const TextStyle(color: Colors.black, shadows: [
            Shadow(color: Colors.white, blurRadius: 10),
          ]),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(hireModel.title),
            Text(hireModel.description),
            Text(hireModel.number),
          ],
        ),
      ),
    );
  }
}
