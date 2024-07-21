import 'package:equatable/equatable.dart';
import 'formstatus.dart';

class ImageUploadState extends Equatable {
  final String downloadImage;

  final double progress;
  final List<String> images;
  final FormStatusImage formStatus;

  const ImageUploadState({
    required this.images,
    required this.downloadImage,
    required this.formStatus,
    required this.progress,
  });

  static ImageUploadState imageUploadState = const ImageUploadState(
      progress: 0,
      downloadImage: "",
      formStatus: FormStatusImage.pure,
      images: []);

  ImageUploadState copyWith({
    String? downloadImage,
    FormStatusImage? formStatus,
    List<String>? images,
    double? progress,
  }) {
    return ImageUploadState(
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
