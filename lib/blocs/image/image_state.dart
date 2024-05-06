import 'package:equatable/equatable.dart';

class ImageUploadState extends Equatable {
  final String downloadImage;

  const ImageUploadState({required this.downloadImage});

  @override
  List<Object?> get props => [downloadImage];
}
