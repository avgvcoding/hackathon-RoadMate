import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MechanicScreen extends StatefulWidget {
  const MechanicScreen({Key? key}) : super(key: key);

  @override
  _MechanicScreenState createState() => _MechanicScreenState();
}

class _MechanicScreenState extends State<MechanicScreen> {
  bool _isLoading = true;
  List<dynamic> _mechanics = [];
  LatLng? _userLocation;
  final Set<Marker> _markers = {};
  // ignore: unused_field
  late GoogleMapController _mapController;

  // Replace with your actual Google Places API key.
  final String apiKey = 'AIzaSyA1qSgbW21nTPHh0WNCDCMn8hyshpflmYo';

  @override
  void initState() {
    super.initState();
    _fetchMechanics();
  }

  Future<void> _fetchMechanics() async {
    try {
      // Get user's current location.
      Position position = await _determinePosition();
      _userLocation = LatLng(position.latitude, position.longitude);

      // Build the text search request for "car mechanic shop".
      final String url = 'https://places.googleapis.com/v1/places:searchText';

      final Map<String, dynamic> bodyData = {
        "textQuery": "car mechanic",
        "locationBias": {
          "circle": {
            "center": {
              "latitude": _userLocation!.latitude,
              "longitude": _userLocation!.longitude,
            },
            "radius": 10000.0
          }
        },
        "pageSize": 6
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': apiKey,
          'X-Goog-FieldMask':
              'places.displayName,places.formattedAddress,places.location,places.photos,places.internationalPhoneNumber'
        },
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final results = jsonResponse['places'] as List;
        _mechanics = results;

        // Add a marker for each mechanic if location data is available.
        for (var mechanic in _mechanics) {
          if (mechanic.containsKey('location') &&
              mechanic['location'] != null) {
            double lat = mechanic['location']['latitude'];
            double lng = mechanic['location']['longitude'];
            _markers.add(
              Marker(
                markerId: MarkerId(mechanic['displayName']?['text'] ?? ''),
                position: LatLng(lat, lng),
                infoWindow: InfoWindow(
                  title: mechanic['displayName']?['text'] ?? '',
                  snippet: mechanic['formattedAddress'] ?? '',
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
              ),
            );
          }
        }
      } else {
        throw Exception('Failed to load mechanics: ${response.body}');
      }
    } catch (e) {
      print('Error fetching mechanics: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Get the user's current position.
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

  // Launch Google Maps for a given query.
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

  // Build a URL to fetch a photo using the photo reference.
  String _buildPhotoUrl(String photoReference) {
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Car Mechanic'),
        backgroundColor: const Color.fromARGB(255, 130, 138, 255),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _mechanics.length + 1,
              itemBuilder: (context, index) {
                if (index < _mechanics.length) {
                  final mechanic = _mechanics[index];
                  // Safely extract mechanic details.
                  String name = mechanic['displayName']?['text'] ?? 'Unnamed';
                  String address =
                      mechanic['formattedAddress'] ?? 'No address available';
                  String phone = mechanic['internationalPhoneNumber'] ??
                      'No contact number';
                  String photoUrl = '';

                  if (mechanic.containsKey('photos') &&
                      mechanic['photos'] is List &&
                      mechanic['photos'].isNotEmpty) {
                    var photoData = mechanic['photos'][0];
                    // Check for both possible keys.
                    String? photoReference = photoData['photoReference'] ??
                        photoData['photo_reference'];
                    if (photoReference != null) {
                      photoUrl = _buildPhotoUrl(photoReference);
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                      elevation: 4,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          _openInGoogleMaps(name);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color.fromARGB(255, 255, 255, 255),
                                const Color.fromARGB(255, 182, 255, 240)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header row with icon and title.
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.build,
                                      color: Color.fromARGB(255, 55, 143, 0),
                                      size: 28,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Car Mechanic',
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
                                // Display mechanic photo if available.
                                if (photoUrl.isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      photoUrl,
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                if (photoUrl.isNotEmpty)
                                  const SizedBox(height: 12),
                                // Mechanic details.
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
                                            name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            address,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.phone,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                phone,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                            ],
                                          )
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
                    ),
                  );
                } else {
                  // Display a map with markers for the mechanics.
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 238, 125, 125),
                            width: 1),
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
