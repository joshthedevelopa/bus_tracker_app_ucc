import '../imports.dart';

class Location {
  final String title;
  final LatLng coordinates;
  final String? description;
  final String? image;

  const Location({
    required this.title,
    required this.coordinates,
    this.description,
    this.image,
  });
}
