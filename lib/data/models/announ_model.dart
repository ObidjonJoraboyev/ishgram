import 'package:equatable/equatable.dart';

class AnnounModel extends Equatable {
  final String docId;
  final String userId;
  final List<String> images;
  final String title;
  final String ownerName;
  final String number;
  final String description;
  final WorkCategory category;
  final int money;
  final String location;
  final num lat;
  final num long;
  final String timeInterval;
  final StatusAnnoun status;
  final int createdAt;
  final int updatedAt;
  final List<String> viewedUsers;
  final List<String> likedUsers;

  const AnnounModel({
    required this.docId,
    required this.userId,
    required this.title,
    required this.description,
    required this.money,
    required this.createdAt,
    required this.ownerName,
    required this.timeInterval,
    required this.images,
    required this.lat,
    required this.long,
    required this.number,
    required this.category,
    required this.updatedAt,
    required this.location,
    required this.viewedUsers,
    required this.status,
    required this.likedUsers,
  });

  AnnounModel copyWith({
    String? title,
    String? ownerName,
    String? docId,
    String? description,
    int? money,
    String? timeInterval,
    List<String>? images,
    double? lat,
    double? long,
    bool? isFavourite,
    String? number,
    String? location,
    int? createdAt,
    int? updatedAt,
    List<String>? countView,
    WorkCategory? category,
    StatusAnnoun? status,
    List<String>? likedUsers,
    List<String>? viewedUsers,
    String? userId,
  }) {
    return AnnounModel(
      ownerName: ownerName ?? this.ownerName,
      docId: docId ?? this.docId,
      title: title ?? this.title,
      description: description ?? this.description,
      money: money ?? this.money,
      timeInterval: timeInterval ?? this.timeInterval,
      images: images ?? this.images,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      number: number ?? this.number,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      location: location ?? this.location,
      viewedUsers: viewedUsers ?? this.viewedUsers,
      status: status ?? this.status,
      likedUsers: likedUsers ?? this.likedUsers,
      userId: userId ?? this.userId,
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
      "image": images.map((img) => img.toString()).toList(),
      "lat": lat,
      "long": long,
      "number": number,
      "category": category.name,
      "countView": viewedUsers.map((e) => e.toString()).toList(),
      "location": location,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "status": status.name,
      "likedUsers": likedUsers.map((e) => e.toString()).toList(),
      "userId": userId,
    };
  }

  Map<String, dynamic> toJsonForUpdate() {
    return {
      "owner_name": ownerName,
      "title": title,
      "description": description,
      "money": money,
      "timeInterval": timeInterval,
      "image": images.map((img) => img.toString()).toList(),
      "lat": lat,
      "long": long,
      "number": number,
      "category": category.name,
      "countView": viewedUsers.map((e) => e.toString()).toList(),
      "location": location,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "status": status.name,
      "likedUsers": likedUsers.map((e) => e.toString()).toList(),
      "userId": userId,
    };
  }

  Map<String, dynamic> formData() => {
        "user_id": userId,
        "title": title,
        "owner_name": ownerName,
        "phone": number,
        "description": description,
        "category": category.name, // or medium, hard
        "money": money,
        "address": location,
        "lat": lat,
        "long": long,
        "time_interval": timeInterval,
        "images": images.map((e) => e.toString()).toList,
      };

  Map<String, dynamic> toJsonForPost() {
    return {
      "address": location,
      "category": category.name,
      "description": description,
      "images": images,
      "lat": lat,
      "long": long,
      "money": money,
      "owner_name": ownerName,
      "phone": number,
      "status": status.name,
      "time_interval": timeInterval,
      "title": title,
      "user_id": userId
    };
  }

  factory AnnounModel.fromJson(Map<String, dynamic> json) {
    return AnnounModel(
      docId: json["id"] as String? ?? "",
      userId: json["user_id"] as String? ?? "",
      title: json["title"] as String? ?? "",
      ownerName: json["owner_name"] as String? ?? "",
      number: json["phone"] as String? ?? "",
      description: json["description"] as String? ?? "",
      category: enumFromString(json["category"] as String? ?? ""),
      money: (json["money"] as int? ?? 0),
      location: json["address"] as String? ?? "",
      lat: json["location"]["lat"] as num? ?? 0.0,
      long: json["location"]["long"] as num? ?? 0.0,
      timeInterval: json["time_interval"] as String? ?? "",
      status: enumFromString2(json["status"] as String? ?? ""),
      viewedUsers: (json["viewed_users"] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      images: (json["images"] as List? ?? []).map((e) => e.toString()).toList(),
      createdAt: json["created_at"] as int? ?? 0,
      updatedAt: json["updated_at"] as int? ?? 0,
      likedUsers: const [],
    );
  }

  static WorkCategory enumFromString(String value) {
    return WorkCategory.values
        .firstWhere((type) => type.toString() == 'WorkCategory.$value');
  }

  static StatusAnnoun enumFromString2(String value) {
    return StatusAnnoun.values
        .firstWhere((type) => type.toString() == 'StatusAnnoun.$value');
  }

  static const AnnounModel initial = AnnounModel(
    ownerName: "",
    title: '',
    description: '',
    money: 0,
    timeInterval: '',
    images: [],
    lat: 0.0,
    long: 0.0,
    number: '',
    category: WorkCategory.easy,
    docId: '',
    createdAt: 0,
    updatedAt: 0,
    location: '',
    viewedUsers: [],
    status: StatusAnnoun.pure,
    likedUsers: [],
    userId: '',
  );

  @override
  List<Object?> get props => [
        title,
        description,
        money,
        timeInterval,
        images,
        lat,
        long,
        number,
        category,
        createdAt,
        updatedAt,
        location,
        viewedUsers,
        status,
        likedUsers,
        userId,
      ];
}

enum WorkCategory { easy, medium, hard }

enum StatusAnnoun { active, done, returned, pure, deleted, waiting }
