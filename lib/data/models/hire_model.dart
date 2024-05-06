import 'package:equatable/equatable.dart';

class HireModel extends Equatable {
  final String title;
  final String description;
  final int money;
  final String timeInterval;
  final List<String> image;
  final bool isActive;
  final double lat;
  final double long;
  final String number;
  final WorkCategory category;
  final String docId;
  final String ownerName;

  const HireModel({
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
  });

  HireModel copyWith({
    String? title,
    String? ownerName,
    String? docId,
    String? description,
    int? money,
    String? timeInterval,
    List<String>? image,
    bool? isActive,
    double? lat,
    double? long,
    String? number,
    WorkCategory? category,
  }) {
    return HireModel(
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
    };
  }

  factory HireModel.fromJson(Map<String, dynamic> json) {
    return HireModel(
      ownerName: json["owner_name"] as String? ?? "",
      docId: json["doc_id"] as String? ?? "",
      title: json["title"] as String,
      description: json["description"] as String,
      money: json["money"] as int,
      timeInterval: json["timeInterval"] as String,
      image: json["image"] as List<String>? ?? [],
      isActive: json["isActive"] as bool,
      lat: json["lat"] as double,
      long: json["long"] as double,
      number: json["number"] as String,
      category: enumFromString(json["category"] as String),
    );
  }

  static WorkCategory enumFromString(String value) {
    return WorkCategory.values
        .firstWhere((type) => type.toString() == 'WorkCategory.$value');
  }

  static const HireModel initial = HireModel(
    ownerName: "",
    title: 'salom',
    description: '',
    money: 0,
    timeInterval: '',
    image: [],
    isActive: false,
    lat: 0.0,
    long: 0.0,
    number: '',
    category: WorkCategory.easy,
    docId: '',
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
