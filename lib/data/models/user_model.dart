import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String name;
  final String password;
  final String lastName;
  final int age;
  final String number;
  final String docId;
  final String image;
  final String city;
  final String fcm;

  const UserModel({
    required this.city,
    required this.age,
    required this.docId,
    required this.name,
    required this.number,
    required this.lastName,
    required this.image,
    required this.fcm,
    required this.password,
  });

  UserModel copyWith(
      {String? name,
      String? lastName,
      String? number,
      String? docId,
      String? image,
      String? city,
      String? userId,
      String? fcm,
      String? password,
      int? age}) {
    return UserModel(
      password: password ?? this.password,
      fcm: fcm ?? this.fcm,
      city: city ?? this.city,
      age: age ?? this.age,
      docId: docId ?? this.docId,
      name: name ?? this.name,
      number: number ?? this.number,
      lastName: lastName ?? this.lastName,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toJson() => {
        "password": password,
        "city": city,
        "age": age,
        "doc_id": docId,
        "fcm": fcm,
        "name": name,
        "number": number,
        "last_name": lastName,
        "image": image,
      };

  Map<String, dynamic> toJsonForUpdate() => {
        "password": password,
        "city": city,
        "age": age,
        "doc_id": docId,
        "fcm": fcm,
        "name": name,
        "number": number,
        "last_name": lastName,
        "image": image,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      password: json["password"] as String? ?? "",
      city: json["city"] as String? ?? "",
      age: json["age"] as int? ?? 0,
      image: json["image"] as String? ?? "",
      docId: json["doc_id"] as String? ?? "",
      number: json["number"] as String? ?? "",
      lastName: json["last_name"] as String? ?? "",
      name: json["name"] as String? ?? "",
      fcm: json["fcm"] as String? ?? "",
    );
  }

  static UserModel initial = const UserModel(
      password: "",
      age: 0,
      city: "",
      fcm: "",
      docId: "",
      name: "",
      number: "1111111",
      lastName: "",
      image: "1111");

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
        city,
      ];
}
