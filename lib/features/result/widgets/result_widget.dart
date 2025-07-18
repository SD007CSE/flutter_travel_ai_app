import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_travel_ai_app/core/models/ai_response.dart';
import 'package:flutter_travel_ai_app/core/utils/functions.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_travel_ai_app/features/chat/pages/chat_page.dart';
import 'package:flutter_travel_ai_app/features/home/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

// --- Itinerary Models ---
class Itinerary {
  final String title;
  final String startDate;
  final String endDate;
  final List<ItineraryDay> days;

  Itinerary({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.days,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      title: json['title'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      days: (json['days'] as List<dynamic>? ?? [])
          .map((e) => ItineraryDay.fromJson(e))
          .toList(),
    );
  }
}

class ItineraryDay {
  final String date;
  final String summary;
  final List<ItineraryItem> items;

  ItineraryDay({
    required this.date,
    required this.summary,
    required this.items,
  });

  factory ItineraryDay.fromJson(Map<String, dynamic> json) {
    return ItineraryDay(
      date: json['date'] ?? '',
      summary: json['summary'] ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => ItineraryItem.fromJson(e))
          .toList(),
    );
  }
}

class ItineraryItem {
  final String time;
  final String activity;
  final String location;

  ItineraryItem({
    required this.time,
    required this.activity,
    required this.location,
  });

  factory ItineraryItem.fromJson(Map<String, dynamic> json) {
    return ItineraryItem(
      time: json['time'] ?? '',
      activity: json['activity'] ?? '',
      location: json['location'] ?? '',
    );
  }
}
// --- End Itinerary Models ---

class ResultWidget extends StatefulWidget {
  final AiResponse response;
  final String userQuery;
  const ResultWidget(
      {super.key, required this.response, required this.userQuery});

  @override
  State<ResultWidget> createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget> {
  @override
  Widget build(BuildContext context) {
    final parts = widget.response.candidates.first.content.parts;
    String rawJson = parts.first.text;
    print('RAW JSON: ' + rawJson);
    // Remove markdown code block markers if present
    rawJson = rawJson.trim();
    if (rawJson.startsWith('```json')) {
      rawJson = rawJson.substring(7);
    }
    if (rawJson.startsWith('```')) {
      rawJson = rawJson.substring(3);
    }
    if (rawJson.endsWith('```')) {
      rawJson = rawJson.substring(0, rawJson.length - 3);
    }
    rawJson = rawJson.trim();
    Itinerary? itinerary;
    try {
      final decoded = jsonDecode(rawJson);
      itinerary = Itinerary.fromJson(decoded);
    } catch (e) {
      print('Invalid JSON received: ' + rawJson);
      return Center(child: Text('Invalid itinerary data received.'));
    }
    print('Parsed Itinerary: ' + itinerary.toString());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top bar
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                if (Navigator.of(context).canPop()) {
                                  Navigator.of(context).pop();
                                } else {
                                  // Replace HomePage() with your actual home page widget if different
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                  );
                                }
                              },
                            ),
                            const Text(
                              'Home',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                            const Spacer(),
                            Builder(
                              builder: (context) {
                                final user = FirebaseAuth.instance.currentUser;
                                if (user != null && user.photoURL != null) {
                                  return CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user.photoURL!),
                                    backgroundColor: Color(0xFF065F46),
                                  );
                                } else {
                                  final avatarLetter =
                                      (user?.displayName != null &&
                                              user!.displayName!.isNotEmpty)
                                          ? user.displayName![0].toUpperCase()
                                          : (user?.email != null &&
                                                  user!.email!.isNotEmpty
                                              ? user.email![0].toUpperCase()
                                              : 'U');
                                  return CircleAvatar(
                                    backgroundColor: Color(0xFF065F46),
                                    child: Text(
                                      avatarLetter,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Title
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Itinerary Created 🌴',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Cards for all days
                      // Cards for all days
                      // Cards for all days
                      ...itinerary!.days.asMap().entries.map((entry) {
                        final index = entry.key;
                        final day = entry.value;
                        // Use the last item's location as the primary location for the map
                        String primaryLocation =
                            day.items.isNotEmpty ? day.items.last.location : '';

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(18, 18, 18, 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Day title and summary
                                  Text(
                                    'Day ${index + 1}: ${day.summary}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Bullet points for items without individual location links
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: day.items.map((item) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 6.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('• ',
                                                style: TextStyle(fontSize: 18)),
                                            Expanded(
                                              child: Text(
                                                '${item.time.isNotEmpty ? item.time + ': ' : ''}${item.activity}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 18),
                                  // Bottom section: Single "Open in maps" link
                                  buildOpenInMapsLink(primaryLocation, day.summary),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF065F46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          final aiResponseText = widget.response.candidates
                              .first.content.parts.first.text;
                          debugPrint(
                              '${aiResponseText}<><><><><><><><><><><><><>><');
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                initalQuery: widget.userQuery,
                                aiResponse: aiResponseText,
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.chat_bubble_outline,
                            color: Colors.white),
                        label: Text(
                          'Follow up to refine',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0xFF065F46), width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {},
                        icon: Icon(Icons.download, color: Color(0xFF065F46)),
                        label: Text(
                          'Save Offline',
                          style:
                              TextStyle(fontSize: 18, color: Color(0xFF065F46)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOpenInMapsLink(String primaryLocation, String summary) {
    if (primaryLocation.isEmpty) return SizedBox.shrink();
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.red, size: 18),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () async {
                  if (primaryLocation.contains(',')) {
                    try {
                      final coords = primaryLocation.split(',');
                      final lat = double.parse(coords[0].trim());
                      final lng = double.parse(coords[1].trim());
                      await openGoogleMaps(lat: lat, lng: lng);
                    } catch (e) {
                      print('Invalid coordinate format: $primaryLocation');
                      await openGoogleMaps(query: primaryLocation);
                    }
                  } else {
                    try {
                      final locations = await locationFromAddress(primaryLocation);
                      if (locations.isNotEmpty) {
                        final placemark = locations.first;
                        await openGoogleMaps(
                          lat: placemark.latitude,
                          lng: placemark.longitude,
                        );
                      } else {
                        await openGoogleMaps(query: primaryLocation);
                      }
                    } catch (e) {
                      print('Geocoding failed for: $primaryLocation');
                      await openGoogleMaps(query: primaryLocation);
                    }
                  }
                },
                child: Row(
                  children: [
                    Text(
                      'Open in maps',
                      style: TextStyle(
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Icon(Icons.open_in_new, color: Color(0xFF1976D2), size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            summary, // Placeholder, replace with actual travel info if available
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
