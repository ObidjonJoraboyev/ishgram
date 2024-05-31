class PlaceModel {
  PlaceModel({
    required this.placeName,
    required this.entrance,
    required this.flatNumber,
    required this.orientAddress,
    required this.stage,
    required this.lat,
    required this.long,
    this.id,
  });

  int? id;
  double lat;
  double long;
  final String placeName;
  final String entrance;
  final String stage;
  final String flatNumber;
  final String orientAddress;

  Map<String, dynamic> toJson() => {
        "place_id": id,
        "lat": lat.toString(),
        "long": long.toString(),
        "place_name": placeName.toString(),
        "place_entrance": entrance.toString(),
        "place_flatNumber": flatNumber.toString(),
        "place_orientAddress": orientAddress.toString(),
        "place_stage": stage.toString()
      };

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
        placeName: json["place_name"] as String? ?? "",
        entrance: json["place_entrance"] as String? ?? "",
        flatNumber: json["place_flatNumber"] as String? ?? "",
        orientAddress: json["place_orientAddress"] as String? ?? "",
        stage: json["place_stage"] as String? ?? "",
        lat: double.parse(json["lat"] as String? ?? "0.0"),
        id: json["place_id"] as int? ?? 0,
        long: double.parse(json["long"] as String? ?? "0.0"));
  }

  PlaceModel copyWith({
    int? id,
    double? lat,
    double? long,
    String? placeName,
    String? entrance,
    String? stage,
    String? flatNumber,
    String? orientAddress,
  }) =>
      PlaceModel(
        id: id ?? this.id,
        lat: lat ?? this.lat,
        long: long ?? this.long,
        placeName: placeName ?? this.placeName,
        entrance: entrance ?? this.entrance,
        stage: stage ?? this.stage,
        flatNumber: flatNumber ?? this.flatNumber,
        orientAddress: orientAddress ?? this.orientAddress,
      );
}
