import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_travel_ai_app/features/login/pages/login_page.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late final User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    final displayName = user?.displayName ?? user?.email?.split('@').first ?? 'User';
    final email = user?.email ?? '';
    final avatarLetter = (user?.displayName != null && user!.displayName!.isNotEmpty)
        ? user!.displayName![0].toUpperCase()
        : (user?.email != null && user!.email!.isNotEmpty ? user!.email![0].toUpperCase() : 'U');

    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Builder(
                          builder: (context) {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null && user.photoURL != null) {
                              return CircleAvatar(
                                radius: 32,
                                backgroundImage: NetworkImage(user.photoURL!),
                                backgroundColor: Color(0xFF0B735F),
                              );
                            } else {
                              final avatarLetter = (user?.displayName != null && user!.displayName!.isNotEmpty)
                                  ? user.displayName![0].toUpperCase()
                                  : (user?.email != null && user!.email!.isNotEmpty ? user.email![0].toUpperCase() : 'U');
                              return CircleAvatar(
                                radius: 32,
                                backgroundColor: Color(0xFF0B735F),
                                child: Text(
                                  avatarLetter,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              email,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    // Request Tokens
                    const Text(
                      'Request Tokens',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: 0.1,
                            backgroundColor: Color(0xFFE9E9E9),
                            valueColor: AlwaysStoppedAnimation(Color(0xFF0B735F)),
                            minHeight: 8,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          '100/1000',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Response Tokens
                    const Text(
                      'Response Tokens',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: 0.075,
                            backgroundColor: Color(0xFFE9E9E9),
                            valueColor: AlwaysStoppedAnimation(Color(0xFFEB6A6A)),
                            minHeight: 8,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          '75/1000',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Total Cost
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Total Cost',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          ' 40.07 USD',
                          style: TextStyle(
                            color: Color(0xFF0B9B3B),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 48.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEB6A6A),
                foregroundColor: Colors.white,
                minimumSize: const Size(220, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                try {
                  // Attempt to sign out from Google as well
                  await GoogleSignIn.instance.signOut();
                } catch (e) {
                  // Ignore if GoogleSignIn is not available or fails
                }
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}