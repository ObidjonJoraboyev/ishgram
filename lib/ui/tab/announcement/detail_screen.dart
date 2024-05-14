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
        child: ListView(
          children: [
            SizedBox(
              height: 300,
              child: PageView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...List.generate(
                    hireModel.image.length,
                    (index) => Image.network(
                      hireModel.image[index],
                      width: MediaQuery.sizeOf(context).width,
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
            ),
            Text(hireModel.title),
            Text(hireModel.description),
            Text(hireModel.number),
            Text(hireModel.image.length.toString()),
          ],
        ),
      ),
    );
  }
}
