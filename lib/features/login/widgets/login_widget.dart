import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_travel_ai_app/features/signup/pages/signup_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_travel_ai_app/features/home/pages/home_page.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _rememberMe = false;
  bool _isPasswordShown = false;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _loginWithEmailPassword() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      // Use the new singleton instance and authenticate method
      final googleSignIn = GoogleSignIn.instance;
      GoogleSignInAccount? googleUser;
      if (googleSignIn.supportsAuthenticate()) {
        googleUser = await googleSignIn.authenticate();
      } else {
        throw Exception('Google Sign-In is not supported on this platform.');
      }
      if (googleUser == null) {
        setState(() {
          _isLoading = false;
        });
        return; // User cancelled
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF7),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png', width: 28, height: 28),
                  const SizedBox(width: 10),
                  const Text(
                    'Itinera AI',
                    style: TextStyle(
                      fontFamily: 'Helvetica Neue',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF065F46),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Hi, Welcome Back',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Login to your account",
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF8F95B2)),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: _isLoading ? null : _loginWithGoogle,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      border: Border.all(color: const Color(0xFFD8DAE5)),
                      color: const Color(0xFFFFFFFF),
                    ),
                    width: 300,
                    height: 57,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Googlelogo.png',
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Sign in With Google",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Color(0xFF081735),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      endIndent: 1,
                      color: Color(0xFFE6E8F0),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "or Sign in with Email",
                    style:
                        TextStyle(fontFamily: 'Inter', color: Color(0xFF8F95B2)),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      endIndent: 1,
                      color: Color(0xFFE6E8F0),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Email address",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                  height: 58,
                  width: 329,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xFFD8DAE5))),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Enter Your Email",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Image.asset("assets/images/emailLogo.png"),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(13)),
                    controller: _email,
                  )),
              const SizedBox(height: 20),
              const Text(
                "Password",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                  height: 58,
                  width: 329,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xFFD8DAE5))),
                  child: TextFormField(
                    obscureText: !_isPasswordShown,
                    decoration: InputDecoration(
                        hintText: "Enter Your Password",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        prefixIcon: Image.asset("assets/images/password.png"),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isPasswordShown = !_isPasswordShown;
                            });
                          },
                          icon: Icon(_isPasswordShown
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(13)),
                    controller: _password,
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (val) {
                        setState(() {
                          _rememberMe = !_rememberMe;
                        });
                      },
                      activeColor: Color(0xFF065F46),
                      side: BorderSide(color: Colors.grey),
                    ),
                    Text(
                      "Remember Me",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Forget your password?",
                      style: TextStyle(
                        fontFamily: "Inter",
                        color: Colors.red,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 25),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                ),
              Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  color: Color(0xFF065F46),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextButton(
                  onPressed: _isLoading ? null : _loginWithEmailPassword,
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Color(0xFFFFFAF7),
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          "Login",
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 18,
                            color: Color(0xFFFFFAF7),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Color(0xFF065F46)),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (context) => const SignupPage()),
                                    );
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 18,
                      color: Color(0xFF065F46),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
