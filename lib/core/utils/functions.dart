import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openGoogleMaps({
  double? lat,
  double? lng,
  String? query,
  String? location, // Add a parameter for the location string
}) async {
  // If location string is provided, parse it to lat and lng
  if (location != null && location.contains(',')) {
    final coords = location.split(',');
    try {
      lat = double.parse(coords[0].trim());
      lng = double.parse(coords[1].trim());
    } catch (e) {
      throw 'Invalid location format: $location';
    }
  }

  // Construct the Google Maps URL
  String googleMapsUrl;
  if (query != null) {
    // For a search query
    googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}';
  } else if (lat != null && lng != null) {
    // For a specific location
    googleMapsUrl = 'geo:$lat,$lng?q=$lat,$lng';
  } else {
    // Default: Open Google Maps without specific location
    googleMapsUrl = 'https://www.google.com/maps';
  }

  final Uri url = Uri.parse(googleMapsUrl);

  // Check if the URL can be launched
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    // Fallback to web browser if the app is not installed
    final webUrl = Uri.parse('https://www.google.com/maps');
    if (await canLaunchUrl(webUrl)) {
      await launchUrl(webUrl, mode: LaunchMode.platformDefault);
    } else {
      throw 'Could not launch Google Maps';
    }
  }
}

  Future<void> saveTripOffline(String tripJson , BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final trips = prefs.getStringList('offline_trips') ?? [];
    trips.add(tripJson);
    await prefs.setStringList('offline_trips', trips);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trip saved for offline use!')),
      );
    }
  }