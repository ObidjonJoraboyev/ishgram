import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../blocs/image/formstatus.dart';
import '../../../../../blocs/image/image_bloc.dart';
import '../../../../../blocs/image/image_event.dart';
import '../../../../../blocs/image/image_state.dart';

class GenerateImage extends StatefulWidget {
  const GenerateImage({super.key, required this.state});

  final ImageUploadState state;

  @override
  State<GenerateImage> createState() => _GenerateImageState();
}

class _GenerateImageState extends State<GenerateImage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(
          widget.state.images.length,
          (index) => ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Padding(
              padding: EdgeInsets.all(8.0.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: CupertinoContextMenu(
                  enableHapticFeedback: false,
                  actions: [
                    CupertinoContextMenuAction(
                      onPressed: () async {
                        context.read<ImageBloc>().add(
                              ImageRemoveEvent(
                                context,
                                docId: widget.state.images[index].imageDocId,
                              ),
                            );
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      isDestructiveAction: true,
                      trailingIcon: CupertinoIcons.delete,
                      child: const Text('Delete'),
                    ),
                  ],
                  child: CachedNetworkImage(
                    imageUrl: widget.state.images[index].imageUrl,
                    fit: BoxFit.cover,
                    width: 150.w,
                    height: 150.w,
                    placeholder: (s, w) {
                      return Padding(
                        padding: const EdgeInsets.all(0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: 150.w,
                            color: CupertinoColors.white,
                            child: (widget.state.formStatus ==
                                        FormStatusImage.uploading) &&
                                    (index == 0)
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : const Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
