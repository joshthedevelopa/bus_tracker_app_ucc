import 'dart:convert';

import '../imports.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static Future<Map> getBusLocations() async {
    final Uri _uri = Uri(
      scheme: "https",
      host: "api.thingspeak.com",
      path: "channels/1581797/feeds.json",
      queryParameters: {"api_key": "8DSYWWRNGELJ10VA", "results": "2"},
    );

    try {
      List buses = [];
      List<http.Response> responses = await Future.wait([
        http.get(_uri),
      ]);

      for (http.Response response in responses) {
        Map data = jsonDecode(response.body);
        buses.add({
          "id": "1581797",
          "lng": (data['feeds'] as List).last['field2'],
          "lat": (data['feeds'] as List).last['field1'],
          "speed": (data['feeds'] as List).last['field4'],
        });
      }

      return {
        "status": "OK",
        "data": buses,
      };
    } catch (e) {
      print(e);
      return {"status": "ERROR"};
    }
  }

  static Future<Map> getDirection(LatLng origin, LatLng destination) async {
    print("${origin.latitude},${origin.longitude}");
    final Uri _uri = Uri(
      scheme: "https",
      host: "maps.googleapis.com",
      path: "maps/api/directions/json",
      queryParameters: {
        "origin": "${origin.latitude},${origin.longitude}",
        "destination": "${destination.latitude},${destination.longitude}",
        "key": googleApiKey,
      },
    );
    try {
      http.Response response = await http.get(_uri);

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        Map _map = jsonDecode(response.body);

        return {
          "status": "OK",
          "data": Direction.fromMap(_map),
        };
      }

      return {
        "status": "ERROR",
        "message": "There was an error in making the request!!!",
      };
    } catch (e) {
      return {
        "status": "ERROR",
        "message":
            "There was an error in making the request, This could be dure to internet access!!!",
      };
    }
  }
}
