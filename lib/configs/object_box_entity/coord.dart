import 'package:google_maps_flutter/google_maps_flutter.dart';

class Coord {
  String address;
  double latitude;
  double longitude;

  Coord({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Coord.fromMap(Map<String, dynamic> map) {
    return Coord(
      address: map['address'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }
}
