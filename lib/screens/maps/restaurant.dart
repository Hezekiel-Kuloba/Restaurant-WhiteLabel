import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RestaurantsMapScreen extends StatefulWidget {
  const RestaurantsMapScreen({Key? key}) : super(key: key);

  @override
  _RestaurantsMapScreenState createState() => _RestaurantsMapScreenState();
}

class _RestaurantsMapScreenState extends State<RestaurantsMapScreen> {
  GoogleMapController? mapController;
  Position? currentPosition;
  final Set<Marker> _markers = {};
  String googleAPIKey =
      "AIzaSyASW8XiIi7YmqYMdondZb_NaorWcRnyN7A"; // Set your Google API Key here

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    mapController?.dispose();
    debugPrint("Disposing mapController.");
    super.dispose();
  }

  void _moveToCurrentLocation() {
    if (mapController != null && currentPosition != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(currentPosition!.latitude, currentPosition!.longitude),
        ),
      );
    } else {
      debugPrint(
          "Cannot move to current location, mapController or currentPosition is null.");
    }
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission;
    try {
      // Check location permissions
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Location permissions are denied.')));
          return;
        }
      }

      // If permissions are granted, get the location
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _moveToCurrentLocation();
        _getNearbyRestaurants(
            currentPosition!.latitude, currentPosition!.longitude);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get current location: $e')));
    }
  }

  Future<void> _getNearbyRestaurants(double lat, double lng) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=1500&type=restaurant&key=$googleAPIKey";
    try {
      final response = await http.get(Uri.parse(url));
      final json = jsonDecode(response.body);
      if (json['status'] == 'OK') {
        for (var result in json['results']) {
          final placeId = result['place_id'];
          final name = result['name'];
          final lat = result['geometry']['location']['lat'];
          final lng = result['geometry']['location']['lng'];
          _markers.add(
            Marker(
              markerId: MarkerId(placeId),
              position: LatLng(lat, lng),
              infoWindow: InfoWindow(
                title: name,
                snippet: "Click to see details",
                onTap: () => _showRestaurantDetails(result),
              ),
            ),
          );
        }
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to fetch restaurants: ${json['status']}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch restaurants: $e')));
    }
  }

  void _showRestaurantDetails(Map restaurant) {
    final name = restaurant['name'];
    final address = restaurant['vicinity'];
    final distance = _calculateDistance(
      currentPosition!.latitude,
      currentPosition!.longitude,
      restaurant['geometry']['location']['lat'],
      restaurant['geometry']['location']['lng'],
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Address: $address"),
              Text("Distance: ${distance.toStringAsFixed(2)} km"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  double _calculateDistance(
      double startLat, double startLng, double endLat, double endLng) {
    const p = 0.017453292519943295;
    final a = 0.5 -
        cos((endLat - startLat) * p) / 2 +
        cos(startLat * p) *
            cos(endLat * p) *
            (1 - cos((endLng - startLng) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants Near You'),
        centerTitle: true,
      ),
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    currentPosition!.latitude, currentPosition!.longitude),
                zoom: 14,
              ),
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  mapController = controller;
                });
                debugPrint("Map created successfully.");
              },
            ),
    );
  }
}
