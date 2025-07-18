import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  @override
  Widget build(BuildContext context) {
          return Scaffold(
            backgroundColor: Color(0xFFF5F5F7),
            appBar: AppBar(
              backgroundColor: Color(0xFFF5F5F7),
              leading: Icon(Icons.arrow_back),
              title: Text(
                "Home",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              actions: [
                Builder(
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
                const SizedBox(
                  width: 20,
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Creating Itinerary...',
                      style: GoogleFonts.inter(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 480,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          backgroundColor: Colors.grey,
                          color: Color(0xFF065F46),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          "Curating a perfect plan for you...",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Color(0xFF065F46).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/followupLogo.png"),
                        const SizedBox(width: 8),
                        Text("Follow up to refine",
                            style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 90),
                      Image.asset(
                        "assets/images/oflineLogo.png",
                        width: 15,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        "Save Offline",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      }