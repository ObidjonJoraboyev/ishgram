import 'package:equatable/equatable.dart';
import 'package:ish_top/data/models/announcement.dart';

import '../image/formstatus.dart';

class UserImageUploadState extends Equatable {
  final String downloadImage;

  final double progress;
  final ImageModel images;
  final FormStatusImage formStatus;

  const UserImageUploadState({
    required this.images,
    required this.downloadImage,
    required this.formStatus,
    required this.progress,
  });

  static UserImageUploadState imageUploadState = UserImageUploadState(
    progress: 0,
    downloadImage: "",
    formStatus: FormStatusImage.pure,
    images: ImageModel(
      imageUrl: '',
      imageDocId: '',
    ),
  );

  UserImageUploadState copyWith({
    String? downloadImage,
    FormStatusImage? formStatus,
    ImageModel? images,
    double? progress,
  }) {
    return UserImageUploadState(
      progress: progress ?? this.progress,
      downloadImage: downloadImage ?? this.downloadImage,
      formStatus: formStatus ?? this.formStatus,
      images: images ?? this.images,
    );
  }

  @override
  List<Object?> get props => [
        downloadImage,
        formStatus,
        images,
        progress,
      ];
}
