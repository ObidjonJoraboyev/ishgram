class ImageModel {
  final String imageUrl;
  final String imageDocId;

  factory ImageModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ImageModel(
      imageUrl: json['imageUrl'],
      imageDocId: json['imageDocId'],
    );
  }

  Map<String, dynamic> toJson() => {
        "imageUrl": imageUrl,
        "imageDocId": imageDocId,
      };

  ImageModel({
    required this.imageUrl,
    required this.imageDocId,
  });
}
