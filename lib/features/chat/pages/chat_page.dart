import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_travel_ai_app/core/utils/functions.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_travel_ai_app/core/models/trip_day.dart';

class ChatPage extends StatefulWidget {
  final String initalQuery;
  final String aiResponse;
  const ChatPage(
      {super.key, required this.initalQuery, required this.aiResponse});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<TripDay>? tripDays;
  String? error;
  final TextEditingController _chatController = TextEditingController();

  // Gemini chat history
  final List<Map<String, String>> _chatHistory = [];
  bool _isLoading = false;
  final Gemini _gemini = Gemini.instance;

  @override
  void initState() {
    super.initState();
    _parseTripJson();
    // Add initial user and AI message to chat history
    _chatHistory.add({'role': 'user', 'text': widget.initalQuery});
    _chatHistory.add({'role': 'ai', 'text': widget.aiResponse});
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  void _parseTripJson() {
    try {
      String aiResponse = widget.aiResponse.trim();
      // Strip markdown code block if present
      if (aiResponse.startsWith('```json')) {
        aiResponse = aiResponse.substring(7);
      }
      if (aiResponse.startsWith('```')) {
        aiResponse = aiResponse.substring(3);
      }
      if (aiResponse.endsWith('```')) {
        aiResponse = aiResponse.substring(0, aiResponse.length - 3);
      }
      aiResponse = aiResponse.trim();

      final decoded = json.decode(aiResponse);
      List daysList;
      if (decoded is Map<String, dynamic> && decoded.containsKey('days')) {
        daysList = decoded['days'];
      } else if (decoded is List) {
        daysList = decoded;
      } else {
        setState(() {
          error = 'Invalid trip data format.';
        });
        return;
      }
      setState(() {
        tripDays =
            daysList.map<TripDay>((day) => TripDay.fromJson(day)).toList();
      });
    } catch (e) {
      setState(() {
        error = 'Failed to parse trip data.';
      });
    }
  }


  Widget _buildUserBubble(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildAIBubble(Widget child) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  Widget _buildDayCard(TripDay day, int dayIndex,
      {bool isLastDay = false, String? tripJson}) {
    // Use the last item's location as the primary location for the map
    String primaryLocation =
        day.items.isNotEmpty ? day.items.last.location : '';

    return _buildAIBubble(
      Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI avatar and title
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.orange[100],
                  radius: 16,
                  child: Image.asset(
                    "assets/images/message.png",
                    width: 80,
                    height: 80,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Itinera AI',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Spacer(),
                // Remove the Save Offline button from the title row if present
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Day ${dayIndex + 1}: ${day.summary}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            // Bullet points for items without individual location links
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: day.items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontSize: 18)),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black87),
                            children: [
                              TextSpan(
                                text: item.time.isNotEmpty
                                    ? '${item.time}: '
                                    : '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(text: item.activity),
                              if (item.location.isNotEmpty)
                                TextSpan(
                                  text: '\nLocation: ${item.location}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            // Action buttons
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Copy'),
                  ),
                  if (isLastDay && tripJson != null)
                    TextButton.icon(
                      onPressed: () => saveTripOffline(tripJson,context),
                      icon: const Icon(Icons.download_for_offline, size: 18),
                      label: const Text('Save Offline'),
                    ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Regenerate'),
                  ),
                ],
              ),
            ),
            // Map/travel info section with single location
            if (primaryLocation.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 14.0, bottom: 6),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.pin_drop,
                              color: Colors.red, size: 18),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () async {
                              if (primaryLocation.contains(',')) {
                                try {
                                  final coords = primaryLocation.split(',');
                                  final lat = double.parse(coords[0].trim());
                                  final lng = double.parse(coords[1].trim());
                                  await openGoogleMaps(lat: lat, lng: lng);
                                } catch (e) {
                                  print(
                                      'Invalid coordinate format: $primaryLocation');
                                  await openGoogleMaps(query: primaryLocation);
                                }
                              } else {
                                try {
                                  final locations = await locationFromAddress(
                                      primaryLocation);
                                  if (locations.isNotEmpty) {
                                    final placemark = locations.first;
                                    await openGoogleMaps(
                                        lat: placemark.latitude,
                                        lng: placemark.longitude);
                                  } else {
                                    await openGoogleMaps(
                                        query: primaryLocation);
                                  }
                                } catch (e) {
                                  print(
                                      'Geocoding failed for: $primaryLocation');
                                  await openGoogleMaps(query: primaryLocation);
                                }
                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Open in maps',
                                  style: TextStyle(
                                    color: Colors.blue[700],
                                    decoration: TextDecoration.underline,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.open_in_new,
                                    size: 16, color: Colors.blue),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        day.summary, // Placeholder, replace with actual travel info if available
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    ); 
  }



  Widget _buildChatHistory() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _chatHistory.length,
      itemBuilder: (context, index) {
        final entry = _chatHistory[index];
        if (entry['role'] == 'user') {
          return _buildUserBubble(entry['text'] ?? '');
        } else {
          // Special case: AI is thinking
          if (entry['text'] == '__thinking__') {
            return _buildAIBubble(
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.orange[100],
                      child: const Icon(Icons.emoji_emotions,
                          color: Colors.orange, size: 22),
                      radius: 16,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Itinera AI',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Thinking...',
                      style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.black54),
                    ),
                  ],
                ),
              ),
            );
          }
          String aiText = (entry['text'] ?? '').trim();
          String? jsonBlock;
          String? noteBlock;
          final jsonRegex = RegExp(r'```json([\s\S]*?)```', multiLine: true);
          final match = jsonRegex.firstMatch(aiText);
          if (match != null) {
            jsonBlock = match.group(1)?.trim();
            noteBlock = aiText.substring(match.end).trim();
          } else {
            final curlyIndex = aiText.indexOf('{');
            final endCurlyIndex = aiText.lastIndexOf('}');
            if (curlyIndex != -1 && endCurlyIndex > curlyIndex) {
              jsonBlock =
                  aiText.substring(curlyIndex, endCurlyIndex + 1).trim();
              noteBlock = aiText.substring(endCurlyIndex + 1).trim();
            }
          }
          if (jsonBlock != null && jsonBlock.isNotEmpty) {
            try {
              final decoded = json.decode(jsonBlock);
              if (decoded is Map<String, dynamic> &&
                  decoded.containsKey('days')) {
                final days = (decoded['days'] as List)
                    .map<TripDay>((day) => TripDay.fromJson(day))
                    .toList();
                // Only show Save Offline button for the last AI message with trip JSON
                bool isLastAITrip = false;
                for (int i = _chatHistory.length - 1; i >= 0; i--) {
                  final e = _chatHistory[i];
                  if (e['role'] == 'ai') {
                    String t = (e['text'] ?? '').trim();
                    final m = RegExp(r'```json([\s\S]*?)```', multiLine: true)
                        .firstMatch(t);
                    String? jb;
                    if (m != null) {
                      jb = m.group(1)?.trim();
                    } else {
                      final ci = t.indexOf('{');
                      final ei = t.lastIndexOf('}');
                      if (ci != -1 && ei > ci) {
                        jb = t.substring(ci, ei + 1).trim();
                      }
                    }
                    if (jb != null && jb.isNotEmpty) {
                      if (index == i) isLastAITrip = true;
                      break;
                    }
                  }
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...List.generate(
                      days.length,
                      (i) => _buildDayCard(
                        days[i],
                        i,
                        isLastDay: i == days.length - 1 && isLastAITrip,
                        tripJson: (i == days.length - 1 && isLastAITrip)
                            ? jsonBlock
                            : null,
                      ),
                    ),
                    if (noteBlock != null && noteBlock.isNotEmpty)
                      _buildAIBubble(
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text(noteBlock,
                              style: const TextStyle(fontSize: 16)),
                        ),
                      ),
                  ],
                );
              }
            } catch (_) {}
          }
          return _buildAIBubble(
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(entry['text'] ?? '',
                  style: const TextStyle(fontSize: 16)),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Trip Plan')),
        body: Center(child: Text(error!)),
      );
    }
    if (tripDays == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Trip Plan')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('7 days in Bali...'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF7F6F9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildChatHistory(),
            const SizedBox(height: 80),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(color: const Color(0xFF00695C), width: 1.5),
                  borderRadius: BorderRadius.circular(32),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: _chatController,
                  decoration: const InputDecoration(
                    hintText: 'Follow up to refine',
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  ),
                  style: const TextStyle(fontSize: 16),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF00695C),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _isLoading ? null : _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _chatHistory.add({'role': 'user', 'text': text});
      _isLoading = true;
      _chatController.clear();
      // Add temporary AI thinking message
      _chatHistory.add({'role': 'ai', 'text': '__thinking__'});
    });
    try {
      // Concatenate chat history for context
      final prompt = _chatHistory
              .map((e) =>
                  (e['role'] == 'user' ? 'User: ' : 'AI: ') + (e['text'] ?? ''))
              .join('\n') +
          '\nUser: $text';
      final response = await _gemini.text(prompt);
      setState(() {
        // Replace the last '__thinking__' message with the real response
        final idx = _chatHistory.lastIndexWhere(
            (e) => e['role'] == 'ai' && e['text'] == '__thinking__');
        if (idx != -1) {
          _chatHistory[idx] = {
            'role': 'ai',
            'text': response?.output ?? 'No response'
          };
        } else {
          _chatHistory
              .add({'role': 'ai', 'text': response?.output ?? 'No response'});
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        final idx = _chatHistory.lastIndexWhere(
            (e) => e['role'] == 'ai' && e['text'] == '__thinking__');
        if (idx != -1) {
          _chatHistory[idx] = {
            'role': 'ai',
            'text': "Oops! I couldn't generate an answer. Please try again."
          };
        } else {
          _chatHistory.add({
            'role': 'ai',
            'text': "Oops! I couldn't generate an answer. Please try again."
          });
        }
        _isLoading = false;
      });
    }
  }
}
