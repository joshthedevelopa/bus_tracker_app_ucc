import '../imports.dart';

class Direction {
  final Location origin, destination;
  final List<PointLatLng> polyLines;
  final LatLngBounds bounds;
  final int totalDuration, totalDistance;

  const Direction({
    required this.origin,
    required this.destination,
    required this.polyLines,
    required this.bounds,
    required this.totalDistance,
    required this.totalDuration,
  });

  static Direction? fromMap(Map map) {
    if ((map["routes"] as List).isEmpty) return null;
    final Map data = Map<String, dynamic>.from(map['routes'][0]);

    // Bounds
    final southwest = data['bounds']['southwest'];
    final northeast = data['bounds']['northeast'];
    final LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(southwest['lat'], southwest['lng']),
      northeast: LatLng(northeast['lat'], northeast['lng']),
    );

    // Duration & Distance
    int duration = 0;
    int distance = 0;
    Map legs = {};

    if ((data['legs'] as List).isNotEmpty) {
      legs = data['legs'][0];

      duration = legs['duration']['value'];
      distance = legs['distance']['value'];
    }

    return Direction(
      origin: Location(
        title: legs['start_address'],
        coordinates: LatLng(
          legs['start_location']['lat'],
          legs['start_location']['lng'],
        ),
      ),
      destination: Location(
        title: legs['end_address'],
        coordinates: LatLng(
          legs['end_location']['lat'],
          legs['end_location']['lng'],
        ),
      ),
      polyLines: PolylinePoints().decodePolyline(
        data['overview_polyline']['points'],
      ),
      bounds: bounds,
      totalDistance: distance,
      totalDuration: duration,
    );
  }
}
