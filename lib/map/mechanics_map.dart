import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'places_service.dart';
import '../models/place_model.dart';

class MechanicsMap extends StatefulWidget {
  const MechanicsMap({Key? key}) : super(key: key);

  @override
  _MechanicsMapState createState() => _MechanicsMapState();
}

class _MechanicsMapState extends State<MechanicsMap> {
  late GoogleMapController _mapController;
  LatLng? _currentLocation;
  final Set<Marker> _markers = {};
  final PlacesService _placesService = PlacesService();
  Timer? _locationTimer;

  @override
  void initState() {
    super.initState();
    _initLocationAndMarkers();
    _startLocationTimer();
  }

  // Fetch initial location and markers.
  Future<void> _initLocationAndMarkers() async {
    try {
      // Get user's current location.
      Position position = await _determinePosition();
      _currentLocation = LatLng(position.latitude, position.longitude);

      // Fetch nearby places using PlacesService.
      List<Place> places =
          await _placesService.getNearbyPlaces(_currentLocation!);

      // Create markers for each place.
      for (var place in places) {
        _markers.add(
          Marker(
            markerId: MarkerId(place.displayName),
            position: LatLng(place.lat, place.lng),
            infoWindow: InfoWindow(
              title: place.displayName,
              snippet: place.formattedAddress,
            ),
          ),
        );
      }
      setState(() {});
    } catch (e) {
      print('Error loading markers: $e');
    }
  }

  // Start a timer to update the location every 10 seconds.
  void _startLocationTimer() {
    _locationTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _updateLocation();
    });
  }

  // Update the location and markers if there's a change.
  Future<void> _updateLocation() async {
    try {
      Position position = await _determinePosition();
      final newLocation = LatLng(position.latitude, position.longitude);

      if (_currentLocation == null || _currentLocation != newLocation) {
        setState(() {
          _currentLocation = newLocation;
        });

        // Animate the camera to the new location.
        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: newLocation, zoom: 12),
          ),
        );

        // Optionally re-fetch nearby markers based on the updated location.
        List<Place> places = await _placesService.getNearbyPlaces(newLocation);
        _markers.clear();
        for (var place in places) {
          _markers.add(
            Marker(
              markerId: MarkerId(place.displayName),
              position: LatLng(place.lat, place.lng),
              infoWindow: InfoWindow(
                title: place.displayName,
                snippet: place.formattedAddress,
              ),
            ),
          );
        }
        setState(() {});
      }
    } catch (e) {
      print('Error updating location: $e');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await _showLocationDisabledDialog();
      // Re-check after the dialog.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are still disabled.');
      }
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

  Future<void> _showLocationDisabledDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Force user to act.
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Required'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Location services are disabled.'),
                Text(
                    'Please enable location services in your device settings.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () async {
                Navigator.of(context).pop();
                await Geolocator.openLocationSettings();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: GoogleMap(
          onMapCreated: (controller) => _mapController = controller,
          initialCameraPosition: CameraPosition(
            target: _currentLocation!,
            zoom: 12,
          ),
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
            Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer()),
          },
        ),
      ),
    );
  }
}
