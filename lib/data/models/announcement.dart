import 'package:equatable/equatable.dart';

class AnnouncementModel extends Equatable {
  final String title;
  final String description;
  final String money;
  final String timeInterval;
  final List<dynamic> image;
  final bool isActive;
  final double lat;
  final double long;
  final String number;
  final WorkCategory category;
  final String docId;
  final String ownerName;
  final String createdAt;
  final String updatedAt;
  final String location;
  final int countView;
  final bool isFavourite;

  const AnnouncementModel({
    required this.createdAt,
    required this.ownerName,
    required this.title,
    required this.docId,
    required this.description,
    required this.money,
    required this.timeInterval,
    required this.image,
    required this.isActive,
    required this.lat,
    required this.long,
    required this.number,
    required this.category,
    required this.updatedAt,
    required this.location,
    required this.countView,
    required this.isFavourite,
  });

  AnnouncementModel copyWith({
    String? title,
    String? ownerName,
    String? docId,
    String? description,
    String? money,
    String? timeInterval,
    List<String>? image,
    bool? isActive,
    double? lat,
    double? long,
    bool? isFavourite,
    String? number,
    String? location,
    String? createdAt,
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
      isActive: isActive ?? this.isActive,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      number: number ?? this.number,
      category: category ?? this.category,
      isFavourite: isFavourite ?? this.isFavourite,
      countView: countView ?? this.countView,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
      "image": image,
      "isActive": isActive,
      "lat": lat,
      "long": long,
      "number": number,
      "category": category.name,
      "isFavourite": isFavourite,
      "countView": countView,
      "location": location,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
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
      "isActive": isActive,
      "lat": lat,
      "long": long,
      "number": number,
      "category": category.name,
      "isFavourite": isFavourite,
      "countView": countView,
      "location": location,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      ownerName: json["owner_name"] as String? ?? "",
      docId: json["doc_id"] as String? ?? "",
      title: json["title"] as String,
      description: json["description"] as String,
      money: json["money"] as String? ?? "",
      timeInterval: json["timeInterval"] as String,
      image: json["image"] as List? ?? [],
      isActive: json["isActive"] as bool,
      lat: json["lat"] as double,
      long: json["long"] as double,
      number: json["number"] as String,
      location: json["location"] as String,
      createdAt: json["createdAt"] as String,
      updatedAt: json["updatedAt"] as String? ?? "",
      countView: json["countView"] as int? ?? 0,
      isFavourite: json["isFavourite"] as bool? ?? false,
      category: enumFromString(
        json["category"] as String? ?? "",
      ),
    );
  }

  static WorkCategory enumFromString(String value) {
    return WorkCategory.values
        .firstWhere((type) => type.toString() == 'WorkCategory.$value');
  }

  static const AnnouncementModel initial = AnnouncementModel(
    ownerName: "",
    title: 'salom',
    description: '',
    money: "",
    timeInterval: '',
    image: [],
    isActive: false,
    lat: 0.0,
    long: 0.0,
    number: '',
    category: WorkCategory.easy,
    docId: '',
    createdAt: '',
    updatedAt: '',
    location: '',
    countView: 1,
    isFavourite: false,
  );

  @override
  List<Object?> get props => [
        title,
        description,
        money,
        timeInterval,
        image,
        isActive,
        lat,
        long,
        number,
        category,
      ];
}

enum WorkCategory { easy, medium, hard }
