import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/blocs/image/image_bloc.dart';
import 'package:ish_top/blocs/image/image_state.dart';
import 'package:ish_top/data/models/announcement.dart';
import 'package:ish_top/ui/tab/announcement/add_announcement/widgets/text_field_widget.dart';
import '../../../../blocs/announcement_bloc/hire_bloc.dart';
import '../../../../blocs/announcement_bloc/hire_event.dart';
import '../../../../utils/utility_functions.dart';

class AddHireScreen extends StatefulWidget {
  const AddHireScreen({super.key});

  @override
  State<AddHireScreen> createState() => _AddHireScreenState();
}

class _AddHireScreenState extends State<AddHireScreen> {
  final TextEditingController nameCtrl = TextEditingController();

  final TextEditingController numberCtrl = TextEditingController();

  final TextEditingController ownerCtrl = TextEditingController();

  final TextEditingController descriptionCtrl = TextEditingController();

  int takenImages = 0;
  AnnouncementModel hireModel = AnnouncementModel.initial;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGrey5,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("add_hire".tr()),
      ),
      body: BlocConsumer<ImageBloc, ImageUploadState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.formStatus != FormStatus.uploading) {
            return ListView(
              children: [
                GlobalTextFiled(controller: nameCtrl, labelText: "work_name",maxLines: 1,),
                GlobalTextFiled(
                    controller: descriptionCtrl, labelText: "about_work",maxLength: 200,),
                GlobalTextFiled(controller: ownerCtrl, labelText: "your_name",maxLines: 1,),
                GlobalTextFiled(
                    controller: numberCtrl, labelText: "phone_number",maxLines: 1,isPhone: true,),
                TextButton(
                  onPressed: () async {
                    hireModel = hireModel.copyWith(
                      ownerName: ownerCtrl.text,
                      title: nameCtrl.text,
                      description: descriptionCtrl.text,
                      image: context.read<ImageBloc>().state.images,
                      isActive: false,
                      number: numberCtrl.text,
                      createdAt: DateTime.now().millisecondsSinceEpoch,
                    );
                    context.read<AnnouncementBloc>().add(
                          AnnouncementAddEvent(hireModel: hireModel),
                        );
                  },
                  child: Text("add".tr()),
                ),
                TextButton(
                  onPressed: () async {
                    takeAnImage(context);
                  },
                  child: const Text("Image"),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
      ),
    );
  }
}
