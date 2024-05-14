import 'package:equatable/equatable.dart';

class ImageUploadState extends Equatable {
  final String downloadImage;
  final List<String> images;
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
    List<String>? images,
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
