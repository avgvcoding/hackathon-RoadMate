import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../models/place_model.dart';

class PoliceScreen extends StatefulWidget {
  const PoliceScreen({Key? key}) : super(key: key);

  @override
  _PoliceScreenState createState() => _PoliceScreenState();
}

class _PoliceScreenState extends State<PoliceScreen> {
  bool _isLoading = true;
  List<Place> _policeStations = [];
  LatLng? _userLocation;
  final Set<Marker> _markers = {};
  // ignore: unused_field
  late GoogleMapController _mapController;

  // Replace with your web service enabled API key
  final String apiKey = 'AIzaSyA1qSgbW21nTPHh0WNCDCMn8hyshpflmYo';

  @override
  void initState() {
    super.initState();
    _fetchPoliceStations();
  }

  Future<void> _fetchPoliceStations() async {
    try {
      // Get user's current location.
      Position position = await _determinePosition();
      _userLocation = LatLng(position.latitude, position.longitude);

      // Prepare API request to fetch nearby police stations.
      final String url = 'https://places.googleapis.com/v1/places:searchNearby';

      final Map<String, dynamic> bodyData = {
        'includedTypes': ['police'],
        'maxResultCount': 5,
        'locationRestriction': {
          'circle': {
            'center': {
              'latitude': _userLocation!.latitude,
              'longitude': _userLocation!.longitude,
            },
            'radius': 10000.0, // 10 km in meters
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
        _policeStations = results.map((json) => Place.fromJson(json)).toList();

        // Add markers for each police station using red markers.
        for (var station in _policeStations) {
          _markers.add(
            Marker(
              markerId: MarkerId(station.displayName),
              position: LatLng(station.lat, station.lng),
              infoWindow: InfoWindow(
                title: station.displayName,
                snippet: station.formattedAddress,
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
            ),
          );
        }
      } else {
        throw Exception('Failed to load police stations: ${response.body}');
      }
    } catch (e) {
      print('Error fetching police stations: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Determine the user's current position.
  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    return await Geolocator.getCurrentPosition();
  }

  // Launch Google Maps with the given place name.
  Future<void> _openInGoogleMaps(String query) async {
    final encodedQuery = Uri.encodeComponent(query);
    final googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$encodedQuery';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Police Stations'),
        backgroundColor: const Color.fromARGB(255, 130, 138, 255),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _policeStations.length + 1,
              itemBuilder: (context, index) {
                // Display police station cards first.
                if (index < _policeStations.length) {
                  final station = _policeStations[index];
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          _openInGoogleMaps(station.displayName);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header row with an icon and station title.
                              Row(
                                children: const [
                                  Icon(
                                    Icons.local_police,
                                    color: Color.fromARGB(255, 54, 86, 244),
                                    size: 28,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Police Station',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Colors.grey,
                                height: 16,
                              ),
                              // Police station details.
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          station.displayName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          station.formattedAddress,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  // Then, display the map with markers inside a rectangular box.
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade400, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _userLocation == null
                          ? const Center(child: CircularProgressIndicator())
                          : GoogleMap(
                              onMapCreated: (controller) {
                                _mapController = controller;
                              },
                              initialCameraPosition: CameraPosition(
                                target: _userLocation!,
                                zoom: 12,
                              ),
                              markers: _markers,
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              gestureRecognizers: <Factory<
                                  OneSequenceGestureRecognizer>>{
                                Factory<OneSequenceGestureRecognizer>(
                                    () => EagerGestureRecognizer()),
                              },
                            ),
                    ),
                  );
                }
              },
            ),
    );
  }
}
