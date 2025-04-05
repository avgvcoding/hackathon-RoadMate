import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/place_model.dart';

class PlacesService {
  final String apiKey =
      ''; // Replace with your web service enabled API key

  Future<List<Place>> getNearbyPlaces(LatLng location) async {
    final String url = 'https://places.googleapis.com/v1/places:searchNearby';

    final Map<String, dynamic> bodyData = {
      'includedTypes': [
        'car_repair'
      ], // Change this to the appropriate type (e.g., "auto_repair" or "mechanic")
      'maxResultCount': 7,
      'locationRestriction': {
        'circle': {
          'center': {
            'latitude': location.latitude,
            'longitude': location.longitude,
          },
          'radius': 10000.0, // 10km in meters
        }
      }
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': apiKey,
        'X-Goog-FieldMask':
            'places.displayName,places.formattedAddress,places.location'
      },
      body: jsonEncode(bodyData),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final results = jsonResponse['places'] as List;
      return results.map((place) => Place.fromJson(place)).toList();
    } else {
      throw Exception('Failed to load nearby places: ${response.body}');
    }
  }
}
