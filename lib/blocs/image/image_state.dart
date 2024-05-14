import 'package:equatable/equatable.dart';
import 'package:ish_top/data/models/announcement.dart';

class ImageUploadState extends Equatable {
  final String downloadImage;
  final List<ImageModel> images;
  final FormStatus formStatus;

  const ImageUploadState({
    required this.images,
    required this.downloadImage,
    required this.formStatus,
  });

  static ImageUploadState imageUploadState = const ImageUploadState(
      downloadImage: "", formStatus: FormStatus.pure, images: []);

  ImageUploadState copyWith({
    String? downloadImage,
    FormStatus? formStatus,
    List<ImageModel>? images,
  }) {
    return ImageUploadState(
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
      ];
}

enum FormStatus {
  pure,
  uploading,
  success,
  error,
}
