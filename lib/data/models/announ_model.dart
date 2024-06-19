import 'package:equatable/equatable.dart';
import 'image_model.dart';

class AnnounModel extends Equatable {
  final String docId;
  final String userId;
  final List<ImageModel> image;
  final String title;
  final String ownerName;
  final String number;
  final String description;
  final WorkCategory category;
  final String money;
  final String location;
  final double lat;
  final double long;
  final String timeInterval;
  final StatusAnnoun status;
  final int createdAt;
  final int updatedAt;
  final List<String> viewedUsers;
  final List<String> likedUsers;
  final List<String> comments;

  const AnnounModel({
    required this.docId,
    required this.userId,
    required this.title,
    required this.description,
    required this.money,
    required this.createdAt,
    required this.ownerName,
    required this.timeInterval,
    required this.image,
    required this.lat,
    required this.long,
    required this.number,
    required this.category,
    required this.updatedAt,
    required this.location,
    required this.viewedUsers,
    required this.status,
    required this.likedUsers,
    required this.comments,
  });

  AnnounModel copyWith({
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
    int? updatedAt,
    List<String>? countView,
    WorkCategory? category,
    StatusAnnoun? status,
    List<String>? likedUsers,
    List<String>? comments,
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
      image: image ?? this.image,
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
      comments: comments ?? this.comments,
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
      "image": image.map((img) => img.toJson()).toList(),
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
      "comments": comments.map((e) => e.toString()).toList(),
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
      "image": image.map((img) => img.toJson()).toList(),
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
      "comments": comments.map((e) => e.toString()).toList(),
      "userId": userId,
    };
  }

  factory AnnounModel.fromJson(Map<String, dynamic> json) {
    return AnnounModel(
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
      updatedAt: json["updatedAt"] as int? ?? 0,
      viewedUsers:
          (json["countView"] as List? ?? []).map((e) => e.toString()).toList(),
      category: enumFromString(
        json["category"] as String? ?? "",
      ),
      status: enumFromString2(
        json["status"] as String? ?? "",
      ),
      likedUsers:
          (json["likedUsers"] as List? ?? []).map((e) => e.toString()).toList(),
      comments:
          (json["comments"] as List? ?? []).map((e) => e.toString()).toList(),
      userId: json["userId"] as String? ?? "",
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
    money: "",
    timeInterval: '',
    image: [],
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
    comments: [],
    userId: '',
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
        viewedUsers,
        status,
        likedUsers,
        comments,
        userId,
      ];
}

enum WorkCategory { easy, medium, hard }

enum StatusAnnoun { active, done, returned, pure, deleted,waiting }
