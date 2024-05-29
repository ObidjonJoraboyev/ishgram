import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String docId;
  final String name;
  final String lastName;
  final int age;
  final String phone;
  final String password;
  final String image;
  final String color;
  final double rating;
  final String bio;
  final String location;
  final String region;
  final double lat;
  final double long;
  final int createdAt;
  final int updatedAt;
  final List<String> allHiring;
  final List<String> savedHiring;
  final String fcm;

  const UserModel({
    required this.location,
    required this.age,
    required this.color,
    required this.docId,
    required this.name,
    required this.phone,
    required this.lastName,
    required this.image,
    required this.fcm,
    required this.password,
    required this.lat,
    required this.long,
    required this.rating,
    required this.region,
    required this.bio,
    required this.updatedAt,
    required this.createdAt,
    required this.allHiring,
    required this.savedHiring,
  });

  UserModel copyWith({
    String? name,
    String? lastName,
    String? phone,
    String? color,
    String? docId,
    String? image,
    String? userId,
    String? fcm,
    String? password,
    String? region,
    double? lat,
    double? long,
    double? rating,
    int? age,
    String? bio,
    int? updatedAt,
    int? createdAt,
    String? location,
    List<String>? announcements,
    List<String>? savedHiring,
    List<String>? allHiring,
  }) {
    return UserModel(
      password: password ?? this.password,
      fcm: fcm ?? this.fcm,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      location: location ?? this.location,
      age: age ?? this.age,
      docId: docId ?? this.docId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      lastName: lastName ?? this.lastName,
      image: image ?? this.image,
      region: region ?? this.region,
      rating: rating ?? this.rating,
      bio: bio ?? this.bio,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      allHiring: allHiring ?? this.allHiring,
      savedHiring: savedHiring ?? this.savedHiring,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toJson() => {
        "password": password,
        "city": location,
        "age": age,
        "doc_id": docId,
        "fcm": fcm,
        "name": name,
        "number": phone,
        "last_name": lastName,
        "image": image,
        "lat": lat,
        "long": long,
        "region": region,
        "rating": rating,
        "bio": bio,
        "updatedAt": updatedAt,
        "createdAt": createdAt,
        "announcements": allHiring,
        "likedHiring": savedHiring,
        "color": color
      };

  Map<String, dynamic> toJsonForUpdate() => {
        "password": password,
        "city": location,
        "age": age,
        "doc_id": docId,
        "fcm": fcm,
        "name": name,
        "number": phone,
        "last_name": lastName,
        "image": image,
        "lat": lat,
        "long": long,
        "rating": rating,
        "bio": bio,
        "updatedAt": updatedAt,
        "createdAt": createdAt,
        "announcements": allHiring,
        "likedHiring": savedHiring,
        "color": color
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      password: json["password"] as String? ?? "",
      location: json["city"] as String? ?? "",
      age: json["age"] as int? ?? 0,
      image: json["image"] as String? ?? "",
      docId: json["doc_id"] as String? ?? "",
      phone: json["number"] as String? ?? "",
      lastName: json["last_name"] as String? ?? "",
      name: json["name"] as String? ?? "",
      fcm: json["fcm"] as String? ?? "",
      lat: json["lat"] as double? ?? 0,
      long: json["long"] as double? ?? 0,
      region: json["region"] as String? ?? "",
      rating: json["rating"] as double? ?? 0,
      bio: json["bio"] as String? ?? "",
      updatedAt: json["updatedAt"] as int? ?? 0,
      createdAt: json["createdAt"] as int? ?? 0,
      allHiring: (json["announcements"] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      savedHiring: (json["likedHiring"] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      color: json["color"] as String? ?? "",
    );
  }

  static UserModel initial = const UserModel(
    password: "",
    age: 0,
    location: "",
    fcm: "",
    docId: "",
    name: "",
    phone: "",
    lastName: "",
    image: "",
    lat: 0,
    long: 0,
    region: "",
    rating: 0,
    bio: "",
    updatedAt: 0,
    createdAt: 0,
    allHiring: [],
    savedHiring: [],
    color: "",
  );

  @override
  List<Object?> get props => [
        password,
        fcm,
        name,
        phone,
        lastName,
        image,
        docId,
        age,
        location,
        lat,
        long,
        region,
        rating,
        bio,
        updatedAt,
        createdAt,
        allHiring,
        savedHiring,
        color
      ];
}
