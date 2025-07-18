import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class OfflinedbWidget extends StatefulWidget {
  const OfflinedbWidget({super.key});

  @override
  State<OfflinedbWidget> createState() => _OfflinedbWidgetState();
}

class _OfflinedbWidgetState extends State<OfflinedbWidget> {
  List<String> _offlineTrips = [];

  @override
  void initState() {
    super.initState();
    _loadOfflineTrips();
  }

  Future<void> _loadOfflineTrips() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _offlineTrips = prefs.getStringList('offline_trips') ?? [];
    });
  }

  Future<void> _deleteTrip(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _offlineTrips.removeAt(index);
      prefs.setStringList('offline_trips', _offlineTrips);
    });
  }

  String _extractTitle(String tripJson) {
    try {
      final decoded = json.decode(tripJson);
      if (decoded is Map<String, dynamic>) {
        if (decoded.containsKey('trip_name')) {
          return decoded['trip_name'];
        } else if (decoded.containsKey('title')) {
          return decoded['title'];
        }
      }
      // fallback: show first 30 chars
      return tripJson.length > 30 ? tripJson.substring(0, 30) + '...' : tripJson;
    } catch (_) {
      return tripJson.length > 30 ? tripJson.substring(0, 30) + '...' : tripJson;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Database'),
      ),
      body: _offlineTrips.isEmpty
          ? const Center(
              child: Text(
                'No offline data found.\nSave itineraries from the home page!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.separated(
              itemCount: _offlineTrips.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final tripJson = _offlineTrips[index];
                final title = _extractTitle(tripJson);
                return ListTile(
                  leading: const Icon(Icons.storage),
                  title: Text(title),
                  subtitle: Text('Tap to view details'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteTrip(index),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OfflineTripDetailPage(tripJson: tripJson),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class OfflineTripDetailPage extends StatelessWidget {
  final String tripJson;
  const OfflineTripDetailPage({super.key, required this.tripJson});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? trip;
    try {
      trip = json.decode(tripJson);
    } catch (_) {}
    if (trip == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Trip Details')),
        body: const Center(child: Text('Invalid trip data.')),
      );
    }
    final title = trip['trip_name'] ?? trip['title'] ?? 'Trip';
    final days = trip['days'] as List?;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: days == null
          ? const Center(child: Text('No days found in this trip.'))
          : ListView.builder(
              itemCount: days.length,
              itemBuilder: (context, dayIdx) {
                final day = days[dayIdx];
                final date = day['date'] ?? '';
                final summary = day['summary'] ?? '';
                final items = day['items'] as List?;
                return Card(
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Day ${dayIdx + 1}: $summary', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        if (date.isNotEmpty) Text(date, style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 8),
                        if (items != null)
                          ...items.map<Widget>((item) {
                            final time = item['time'] ?? '';
                            final activity = item['activity'] ?? '';
                            final location = item['location'] ?? '';
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: time.isNotEmpty ? Text(time, style: const TextStyle(fontWeight: FontWeight.bold)) : null,
                              title: Text(activity),
                              subtitle: location.isNotEmpty ? Text(location) : null,
                            );
                          }).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}