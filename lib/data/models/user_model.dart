import 'package:equatable/equatable.dart';
import 'package:ish_top/utils/utility_functions.dart';

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
  final List<String> allAnnoun;
  final List<String> savedAnnoun;
  final String fcm;
  final bool isPrivate;

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
    required this.allAnnoun,
    required this.savedAnnoun,
    required this.isPrivate,
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
    List<String>? savedAnnoun,
    List<String>? allAnnoun,
    bool? isPrivate,
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
      allAnnoun: allAnnoun ?? this.allAnnoun,
      savedAnnoun: savedAnnoun ?? this.savedAnnoun,
      color: color ?? this.color,
      isPrivate: isPrivate ?? this.isPrivate,
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
        "announcements": allAnnoun.map((e) => e.toString()).toList(),
        "likedHiring": savedAnnoun.map((e) => e.toString()).toList(),
        "color": color,
        "isPrivate": isPrivate,
      };

  Map<String, dynamic> toJsonForApi() => {
        "age": age,
        "color": color,
        "first_name": name,
        "last_name": lastName,
        "location": {"lat": lat, "long": long},
        "password": password,
        "phone": replaceString(phone),
      };

  Map<String, dynamic> toJsonForUpdate() => {
        "address": location,
        "age": age,
        "bio": bio,
        "color": color,
        "first_name": name,
        "id": docId,
        "is_private": isPrivate,
        "last_name": lastName,
        "location": {"lat": lat, "long": long},
        "password": password,
        "phone": replaceString(phone),
        "photo_url": image,
        "rating": rating,
        "region": region,
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
      allAnnoun: (json["announcements"] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      savedAnnoun: (json["likedHiring"] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      color: json["color"] as String? ?? "",
      isPrivate: json["isPrivate"] as bool? ?? false,
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
    allAnnoun: [],
    savedAnnoun: [],
    color: "",
    isPrivate: false,
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
        allAnnoun,
        savedAnnoun,
        color,
        isPrivate,
      ];
}
