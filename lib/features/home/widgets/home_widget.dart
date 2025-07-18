import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_travel_ai_app/features/loading/pages/loading_page.dart';
import 'package:flutter_travel_ai_app/features/profile/pages/profile_page.dart';
import 'package:flutter_travel_ai_app/features/result/cubit/result_cubit.dart';
import 'package:flutter_travel_ai_app/features/result/pages/result_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_travel_ai_app/features/offlinedb/widgets/offlinedb_widget.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  TextEditingController _message = TextEditingController();
  List<String> _offlineItineraries = [];

  @override
  void initState() {
    super.initState();
    _loadOfflineItineraries();
  }

  Future<void> _loadOfflineItineraries() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _offlineItineraries = prefs.getStringList('offline_trips') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F7),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: BlocBuilder<ResultCubit, ResultState>(
          builder: (context, state) {
            if (state is ResultLoading) {
              return const LoadingPage();
            } else if (state is ResultLoaded) {
              return ResultPage(
                  response: state.response, userQuery: _message.text);
            }
          return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Builder(
                          builder: (context) {
                            final user = FirebaseAuth.instance.currentUser;
                            final displayName = user?.displayName ?? user?.email?.split('@').first ?? 'User';
                            return Text(
                              'Hey $displayName 👋',
                              style: GoogleFonts.inter(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF065F46)),
                            );
                          },
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProfilePage()));
                        },
                        child: Builder(
                          builder: (context) {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null && user.photoURL != null) {
                              return CircleAvatar(
                                backgroundImage: NetworkImage(user.photoURL!),
                                backgroundColor: Color(0xFF065F46),
                              );
                            } else {
                              final avatarLetter = (user?.displayName != null && user!.displayName!.isNotEmpty)
                                  ? user.displayName![0].toUpperCase()
                                  : (user?.email != null && user!.email!.isNotEmpty ? user.email![0].toUpperCase() : 'U');
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Text(
                    "What’s your vision for this trip?",
                    style: GoogleFonts.inter(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: double.infinity,
                    // Removed fixed height to allow expansion
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Color(0xFF3BAB8C), width: 1.5)),
                    child: TextField(
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.mic,
                            color: Color(0xFF065F46),
                          ),
                          contentPadding: EdgeInsets.all(8),
                          hintText: "Type your message",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          )),
                      controller: _message,
                    ),
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<ResultCubit>(context)
                          .getTheResponse(query: _message.text);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Color(0xFF065F46),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Create My Itinerary",
                          style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 18,
                              color: Color(0xFFFFFAF7)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Offline Saved Itineraries",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _offlineItineraries.isEmpty
                      ? Text(
                          "No offline itineraries saved.",
                          style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _offlineItineraries.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final trip = _offlineItineraries[index];
                            String title = "";
                            try {
                              final decoded = trip;
                              // Try to extract trip_name first
                              if (decoded.contains('"trip_name"')) {
                                final match = RegExp('"trip_name"\\s*:\\s*"([^"]+)"').firstMatch(decoded);
                                if (match != null) title = match.group(1)!;
                              }
                              // Fallback to title if trip_name is not found
                              if (title.isEmpty && decoded.contains('"title"')) {
                                final match = RegExp('"title"\\s*:\\s*"([^"]+)"').firstMatch(decoded);
                                if (match != null) title = match.group(1)!;
                              }
                              // Fallback: show first 30 chars
                              if (title.isEmpty) {
                                title = decoded.length > 30 ? decoded.substring(0, 30) + '...' : decoded;
                              }
                            } catch (_) {
                              // fallback: show first 30 chars
                              title = trip.length > 30 ? trip.substring(0, 30) + '...' : trip;
                            }
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => OfflineTripDetailPage(tripJson: trip),
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                height: 41,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    Icon(
                                      Icons.circle,
                                      color: Color(0xFF35AF8D),
                                      size: 10,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        title,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
