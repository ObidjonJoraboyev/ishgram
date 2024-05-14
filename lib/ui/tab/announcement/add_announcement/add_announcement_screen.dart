import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/blocs/image/image_bloc.dart';
import 'package:ish_top/blocs/image/image_state.dart';
import 'package:ish_top/data/models/announcement.dart';
import 'package:ish_top/ui/tab/announcement/add_announcement/widgets/text_field_widget.dart';
import 'package:ish_top/utils/formatters/formatters.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
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
  final TextEditingController money = TextEditingController();

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
                SizedBox(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...List.generate(
                        state.images.length,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CupertinoContextMenu(
                              actions: <Widget>[
                                CupertinoContextMenuAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  isDefaultAction: true,
                                  trailingIcon:
                                      CupertinoIcons.doc_on_clipboard_fill,
                                  child: const Text('Copy'),
                                ),
                                CupertinoContextMenuAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  trailingIcon: CupertinoIcons.share,
                                  child: const Text('Share'),
                                ),
                                CupertinoContextMenuAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  trailingIcon: CupertinoIcons.heart,
                                  child: const Text('Favorite'),
                                ),
                                CupertinoContextMenuAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  isDestructiveAction: true,
                                  trailingIcon: CupertinoIcons.delete,
                                  child: const Text('Delete'),
                                ),
                              ],
                              child: CachedNetworkImage(
                                imageUrl: state.images[index].imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                              ),
                            ),
                          ),
                        ),
                      ),
                      ...List.generate(
                        5 - state.images.length,
                        (index) => ZoomTapAnimation(
                          onTap: () {
                            takeAnImage(context,
                                limit: 5 - state.images.length);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                width: 200,
                                height: 200,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GlobalTextFiled(
                  controller: nameCtrl,
                  labelText: "work_name",
                  maxLines: 1,
                  maxLength: 100,
                ),
                GlobalTextFiled(
                  controller: ownerCtrl,
                  labelText: "your_name",
                  maxLines: 1,
                  maxLength: 50,
                ),
                GlobalTextFiled(
                  controller: numberCtrl,
                  labelText: "phone_number",
                  maxLines: 1,
                  formatter: AppInputFormatters.phoneFormatter,
                  isPhone: true,
                ),
                GlobalTextFiled(
                  controller: descriptionCtrl,
                  labelText: "about_work",
                  maxLength: 500,
                ),
                GlobalTextFiled(
                  controller: money,
                  labelText: "Ish haqqi",
                  maxLength: 500,
                  isPhone: true,
                  formatter: AppInputFormatters.moneyFormatter,
                ),
                TextButton(
                  onPressed: () async {
                    hireModel = hireModel.copyWith(
                      ownerName: ownerCtrl.text,
                      title: nameCtrl.text,
                      description: descriptionCtrl.text,
                      image: context.read<ImageBloc>().state.images,
                      isActive: false,
                      money: money.text,
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
                    takeAnImage(context, limit: 5 - state.images.length);
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
