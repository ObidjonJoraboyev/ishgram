import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String name;
  final String password;
  final String lastName;
  final List<String> allHiring;
  final List<String> likedHiring;
  final int age;
  final int updatedAt;
  final int createdAt;
  final String number;
  final String docId;
  final String image;
  final String location;
  final String region;
  final String fcm;
  final String bio;
  final double lat;
  final double long;
  final double rating;

  const UserModel({
    required this.location,
    required this.age,
    required this.docId,
    required this.name,
    required this.number,
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
    required this.likedHiring,
  });

  UserModel copyWith({
    String? name,
    String? lastName,
    String? number,
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
    List<String>? likedHiring,
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
      number: number ?? this.number,
      lastName: lastName ?? this.lastName,
      image: image ?? this.image,
      region: region ?? this.region,
      rating: rating ?? this.rating,
      bio: bio ?? this.bio,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      allHiring: allHiring ?? this.allHiring,
      likedHiring: likedHiring ?? this.likedHiring,
    );
  }

  Map<String, dynamic> toJson() => {
        "password": password,
        "city": location,
        "age": age,
        "doc_id": docId,
        "fcm": fcm,
        "name": name,
        "number": number,
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
        "likedHiring": likedHiring
      };

  Map<String, dynamic> toJsonForUpdate() => {
        "password": password,
        "city": location,
        "age": age,
        "doc_id": docId,
        "fcm": fcm,
        "name": name,
        "number": number,
        "last_name": lastName,
        "image": image,
        "lat": lat,
        "long": long,
        "rating": rating,
        "bio": bio,
        "updatedAt": updatedAt,
        "createdAt": createdAt,
        "announcements": allHiring,
        "likedHiring": likedHiring,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      password: json["password"] as String? ?? "",
      location: json["city"] as String? ?? "",
      age: json["age"] as int? ?? 0,
      image: json["image"] as String? ?? "",
      docId: json["doc_id"] as String? ?? "",
      number: json["number"] as String? ?? "",
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
      allHiring: json["announcements"] as List<String>? ?? [],
      likedHiring: json["likedHiring"] as List<String>? ?? [],
    );
  }

  static UserModel initial = const UserModel(
    password: "",
    age: 0,
    location: "",
    fcm: "",
    docId: "",
    name: "",
    number: "",
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
    likedHiring: [],
  );

  @override
  List<Object?> get props => [
        password,
        fcm,
        name,
        number,
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
        likedHiring
      ];
}
