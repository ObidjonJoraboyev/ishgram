import 'package:equatable/equatable.dart';
import 'package:ish_top/utils/utility_functions.dart';

class UserModel extends Equatable {
  final String docId;
  final String name;
  final String lastName;
  final int age;
  final String phone;
  final String image;
  final String color;
  final num rating;
  final String bio;
  final String address;
  final String region;
  final num lat;
  final num long;
  final int createdAt;
  final List<String> likedAnnouns;
  final bool isPrivate;
  final String password;
  final String username;

  const UserModel({
    required this.address,
    required this.age,
    required this.color,
    required this.docId,
    required this.name,
    required this.phone,
    required this.lastName,
    required this.image,
    required this.lat,
    required this.long,
    required this.rating,
    required this.region,
    required this.bio,
    required this.createdAt,
    required this.likedAnnouns,
    required this.isPrivate,
    required this.password,
    required this.username,
  });

  UserModel copyWith({
    String? name,
    String? lastName,
    String? phone,
    String? color,
    String? docId,
    String? image,
    String? userId,
    String? region,
    double? lat,
    double? long,
    double? rating,
    int? age,
    String? bio,
    int? createdAt,
    String? address,
    List<String>? likedAnnouns,
    bool? isPrivate,
    String? password,
    String? username,
  }) {
    return UserModel(
      lat: lat ?? this.lat,
      long: long ?? this.long,
      age: age ?? this.age,
      docId: docId ?? this.docId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      lastName: lastName ?? this.lastName,
      image: image ?? this.image,
      region: region ?? this.region,
      rating: rating ?? this.rating,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      likedAnnouns: likedAnnouns ?? this.likedAnnouns,
      color: color ?? this.color,
      isPrivate: isPrivate ?? this.isPrivate,
      address: address ?? this.address,
      password: password ?? this.password,
      username: username ?? this.username,
    );
  }

  Map<String, dynamic> toJson() => {
        "city": address,
        "age": age,
        "doc_id": docId,
        "name": name,
        "number": phone,
        "last_name": lastName,
        "image": image,
        "lat": lat,
        "long": long,
        "region": region,
        "rating": rating,
        "bio": bio,
        "createdAt": createdAt,
        "likedHiring": likedAnnouns.map((e) => e.toString()).toList(),
        "color": color,
        "isPrivate": isPrivate,
        "username": username,
      };

  Map<String, dynamic> toJsonForApi() => {
        "age": age,
        "color": color,
        "first_name": name,
        "last_name": lastName,
        "location": {"lat": lat, "long": long},
        "phone": replaceString(phone),
        "password": password
      };

  Map<String, dynamic> toJsonForUpdate() => {
        "address": address,
        "age": age,
        "bio": bio,
        "color": color,
        "first_name": name,
        "id": docId,
        "is_private": isPrivate,
        "last_name": lastName,
        "liked_announcements": likedAnnouns.map((e) => e.toString()).toList(),
        "location": {"lat": lat, "long": long},
        "phone": replaceString(phone),
        "photo_url": image,
        "rating": rating,
        "region": region,
        "username": username,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      docId: json["id"] as String? ?? "",
      name: json["first_name"] as String? ?? "",
      lastName: json["last_name"] as String? ?? "",
      age: json["age"] as int? ?? 0,
      phone: json["phone"] as String? ?? "",
      image: json["photo_url"] as String? ?? "",
      color: json["color"] as String? ?? "",
      rating: json["rating"] as num? ?? 0,
      bio: json["bio"] as String? ?? "",
      address: json["address"] as String? ?? "",
      region: json["region"] as String? ?? "",
      lat: json["location"]["lat"] as num? ?? 0,
      long: json["location"]["long"] as num? ?? 0,
      isPrivate: json["is_private"] as bool? ?? false,
      createdAt: json["created_at"] as int? ?? 0,
      likedAnnouns: (json["likedHiring"] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      password: json["password"] as String? ?? "",
      username: json["username"] as String? ?? "",
    );
  }

  static UserModel initial = const UserModel(
    age: 0,
    address: "",
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
    createdAt: 0,
    likedAnnouns: [],
    color: "",
    isPrivate: false,
    password: '',
    username: '',
  );

  @override
  List<Object?> get props => [
        name,
        phone,
        lastName,
        image,
        docId,
        age,
        address,
        lat,
        long,
        region,
        rating,
        bio,
        createdAt,
        likedAnnouns,
        color,
        isPrivate,
        password,
        username,
      ];
}
