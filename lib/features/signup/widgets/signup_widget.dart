import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_travel_ai_app/features/home/pages/home_page.dart';

// Make sure to initialize Firebase in your main.dart before using this widget!
// import 'package:firebase_core/firebase_core.dart';
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

class SignupWidget extends StatefulWidget {
  const SignupWidget({super.key});

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  bool _isPasswordShown = false;
  bool _isConfirmPasswordShown = false;
  bool _rememberMe = false;
  bool _isLoading = false;
  String? _errorMessage;
  bool _showSignUp = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _loginWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
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
      // On success, you can navigate to your home page
    } catch (e) {
      setState(() {
        _errorMessage = 'Google sign-in failed: \\${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
      // On success, you can navigate to your home page
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Login failed: \\${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signUpWithEmailPassword() async {
    if (_password.text != _confirmPassword.text) {
      setState(() {
        _errorMessage = "Passwords do not match.";
      });
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );
      // On success, navigate to home page
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
        _errorMessage = 'Sign up failed: \\${e.toString()}';
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
                height: 70,
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
              Align(
                alignment: Alignment.center,
                child: Text(
                  _showSignUp ? 'Create your account' : 'Hi, Welcome Back',
                  style: const TextStyle(
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
                  _showSignUp ? "Sign up to get started" : "Login to your account",
                  style: const TextStyle(
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
                          _showSignUp ? "Sign up With Google" : "Sign in With Google",
                          style: const TextStyle(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      endIndent: 1,
                      color: Color(0xFFE6E8F0),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _showSignUp ? "or Sign up with Email" : "or Sign in with Email",
                    style: const TextStyle(fontFamily: 'Inter', color: Color(0xFF8F95B2)),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
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
                    decoration: const InputDecoration(
                        hintText: "Enter Your Email",
                        hintStyle: TextStyle(color: Colors.grey),
                        // You may want to use Icon(Icons.email) if asset missing
                        prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(13)),
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
                        hintText: _showSignUp ? "Create a Password" : "Enter Your Password",
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
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
              if (_showSignUp) ...[
                const SizedBox(height: 20),
                const Text(
                  "Confirm Password",
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
                      obscureText: !_isConfirmPasswordShown,
                      decoration: InputDecoration(
                          hintText: "Re-enter your password",
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordShown = !_isConfirmPasswordShown;
                              });
                            },
                            icon: Icon(_isConfirmPasswordShown
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(13)),
                      controller: _confirmPassword,
                    )),
              ],
              if (!_showSignUp)
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
                        activeColor: const Color(0xFF065F46),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      const Text(
                        "Remember Me",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                      const Spacer(),
                      const Text(
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
                  color: const Color(0xFF065F46),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextButton(
                  onPressed: _isLoading
                      ? null
                      : _showSignUp
                          ? _signUpWithEmailPassword
                          : _loginWithEmailPassword,
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Color(0xFFFFFAF7),
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          _showSignUp ? "Sign Up" : "Login",
                          style: const TextStyle(
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
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFF065F46)),
                ),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _showSignUp = !_showSignUp;
                      _errorMessage = null;
                    });
                  },
                  child: Text(
                    _showSignUp ? "Already have an account? Login" : "Sign Up",
                    style: const TextStyle(
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
