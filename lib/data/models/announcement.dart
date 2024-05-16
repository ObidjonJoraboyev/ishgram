import 'package:equatable/equatable.dart';

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

class AnnouncementModel extends Equatable {
  final String title;
  final String description;
  final String money;
  final String timeInterval;
  final List<ImageModel> image;
  final double lat;
  final double long;
  final String number;
  final WorkCategory category;
  final String docId;
  final String ownerName;
  final int createdAt;
  final String updatedAt;
  final String location;
  final int countView;
  final StatusAnnouncement status;

  const AnnouncementModel({
    required this.createdAt,
    required this.ownerName,
    required this.title,
    required this.docId,
    required this.description,
    required this.money,
    required this.timeInterval,
    required this.image,
    required this.lat,
    required this.long,
    required this.number,
    required this.category,
    required this.updatedAt,
    required this.location,
    required this.countView,
    required this.status,
  });

  AnnouncementModel copyWith({
    String? title,
    String? ownerName,
    String? docId,
    String? description,
    String? money,
    String? timeInterval,
    List<ImageModel>? image,
    double? lat,
    double? long,
    bool? isFavourite,
    String? number,
    String? location,
    int? createdAt,
    String? updatedAt,
    int? countView,
    WorkCategory? category,
  }) {
    return AnnouncementModel(
      ownerName: ownerName ?? this.ownerName,
      docId: docId ?? this.docId,
      title: title ?? this.title,
      description: description ?? this.description,
      money: money ?? this.money,
      timeInterval: timeInterval ?? this.timeInterval,
      image: image ?? this.image,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      number: number ?? this.number,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      location: location ?? this.location,
      countView: countView ?? this.countView,
      status: status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "doc_id": docId,
      "owner_name": ownerName,
      "title": title,
      "description": description,
      "money": money,
      "timeInterval": timeInterval,
      "image": image.map((img) => img.toJson()).toList(),
      "lat": lat,
      "long": long,
      "number": number,
      "category": category.name,
      "countView": countView,
      "location": location,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "status": status.name
    };
  }

  Map<String, dynamic> toJsonForUpdate() {
    return {
      "title": title,
      "owner_name": ownerName,
      "description": description,
      "money": money,
      "timeInterval": timeInterval,
      "image": image,
      "lat": lat,
      "long": long,
      "number": number,
      "category": category.name,
      "countView": countView,
      "location": location,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "status": status.name
    };
  }

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      ownerName: json["owner_name"] as String? ?? "",
      docId: json["doc_id"] as String? ?? "",
      title: json["title"] as String? ?? "",
      description: json["description"] as String? ?? "",
      money: json["money"] as String? ?? "",
      timeInterval: json["timeInterval"] as String? ?? "",
      image: (json["image"] as List<dynamic>?)
              ?.map((e) => ImageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      lat: json["lat"] as double? ?? 0.0,
      long: json["long"] as double? ?? 0.0,
      number: json["number"] as String? ?? "",
      location: json["location"] as String? ?? "",
      createdAt: json["createdAt"] as int? ?? 0,
      updatedAt: json["updatedAt"] as String? ?? "",
      countView: json["countView"] as int? ?? 0,
      category: enumFromString(
        json["category"] as String? ?? "",
      ),
      status: enumFromString2(
        json["status"] as String? ?? "",
      ),
    );
  }

  static WorkCategory enumFromString(String value) {
    return WorkCategory.values
        .firstWhere((type) => type.toString() == 'WorkCategory.$value');
  }

  static StatusAnnouncement enumFromString2(String value) {
    return StatusAnnouncement.values
        .firstWhere((type) => type.toString() == 'StatusAnnouncement.$value');
  }

  static const AnnouncementModel initial = AnnouncementModel(
    ownerName: "",
    title: '',
    description: '',
    money: "",
    timeInterval: '',
    image: [],
    lat: 0.0,
    long: 0.0,
    number: '',
    category: WorkCategory.easy,
    docId: '',
    createdAt: 0,
    updatedAt: '',
    location: '',
    countView: 0,
    status: StatusAnnouncement.pure,
  );

  @override
  List<Object?> get props => [
        title,
        description,
        money,
        timeInterval,
        image,
        lat,
        long,
        number,
        category,
        createdAt,
        updatedAt,
        location,
        countView,
        status,
      ];
}

enum WorkCategory { easy, medium, hard }

enum StatusAnnouncement { active, done, canceled, pure }
