import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sukoon_app/therapist_form.dart';
import 'package:sukoon_app/therapist_home.dart';
import 'dart:convert';
import 'signup.dart';
import 'userhome.dart';

class therapist_signin extends StatefulWidget {
  const therapist_signin({super.key});

  @override
  State<therapist_signin> createState() => _SigninState();
}

class _SigninState extends State<therapist_signin> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_form.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final url =
        "http://localhost/sukoon_website/therapist/therapist_signin.php";
    print("→ Attempting login → $url");
    print("→ Username: ${_usernameController.text.trim()}");

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
              'Accept': 'application/json',
            },
            body: {
              'username': _usernameController.text.trim(),
              'password': _passwordController.text,
            },
          )
          .timeout(const Duration(seconds: 10));

      print("← Status: ${response.statusCode}");
      print("← Response body: ${response.body}");
      print("← Response length: ${response.body.length}");

      if (!mounted) return;

      // Check if response is HTML (error page)
      if (response.body.trim().startsWith('<')) {
        print("!!! ERROR: Server returned HTML instead of JSON !!!");
        _showSnackBar(
          "Server error: Received HTML instead of JSON",
          isError: true,
        );
        return;
      }

      if (response.statusCode != 200) {
        _showSnackBar("Server error (${response.statusCode})", isError: true);
        return;
      }

      // Parse JSON
      Map<String, dynamic> data;
      try {
        data = jsonDecode(response.body);
      } catch (e) {
        print("JSON parse failed: $e");
        print("Raw response: ${response.body}");
        _showSnackBar("Invalid response from server", isError: true);
        return;
      }

      // DEBUG: Print all fields with their types
      print("=== RECEIVED DATA TYPES ===");
      data.forEach((key, value) {
        print("Field: $key, Value: $value, Type: ${value.runtimeType}");
      });
      print("===========================");

      if (data['status'] == null) {
        _showSnackBar("Unexpected response format", isError: true);
        return;
      }

      if (data['status'] == 'success') {
        final prefs = await SharedPreferences.getInstance();

        // Handle user_id (could be String or int)
        int userId = 0;
        if (data['user_id'] != null) {
          if (data['user_id'] is int) {
            userId = data['user_id'];
          } else if (data['user_id'] is String) {
            userId = int.tryParse(data['user_id']) ?? 0;
          } else if (data['user_id'] is double) {
            userId = (data['user_id'] as double).toInt();
          }
        }

        // Handle all other fields safely
        String username = data['username']?.toString() ?? '';
        String email = data['email']?.toString() ?? '';
        String firstname = data['firstname']?.toString() ?? '';
        String lastname = data['lastname']?.toString() ?? '';
        String phone = data['phone']?.toString() ?? '';
        String certificate = data['certificate']?.toString() ?? '';
        String workplace = data['workplace']?.toString() ?? '';
        String image = data['image']?.toString() ?? '';
        String language = data['language']?.toString() ?? '';

        // Print what we're saving
        print("=== SAVING TO SHARED PREFERENCES ===");
        print("  user_id: $userId (${userId.runtimeType})");
        print("  username: $username");
        print("  email: $email");
        print("  firstname: $firstname");
        print("  lastname: $lastname");
        print("====================================");

        // Save to SharedPreferences
        await prefs.setInt('user_id', userId);
        await prefs.setString('username', username);
        await prefs.setString('user_email', email);
        await prefs.setString('user_firstname', firstname);
        await prefs.setString('user_lastname', lastname);
        await prefs.setString('user_phone', phone);
        await prefs.setString('user_certificate', certificate);
        await prefs.setString('user_workplace', workplace);
        await prefs.setString('user_image', image);
        await prefs.setString('user_language', language);

        if (!mounted) return;

        _showSnackBar(
          "Welcome back, ${firstname.isNotEmpty ? firstname : 'User'}!",
          isError: false,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const TherapistHomePage()),
        );
      } else {
        _showSnackBar(
          data['message']?.toString() ?? "Login failed",
          isError: true,
        );
      }
    } catch (e) {
      print("Login exception: $e");
      if (mounted) {
        _showSnackBar("Connection failed: ${e.toString()}", isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? Colors.red.shade700 : const Color(0xFF0D5C63),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFA),
      body: Column(
        children: [
          // Header gradient + logo
          Container(
            width: double.infinity,
            height: 300,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0D5C63),
                  Color(0xFF247B7B),
                  Color(0xFF44A1A0),
                ],
                stops: [0.0, 0.4954, 0.9908],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Image.asset(
                  'lib/images/logo_2.png',
                  width: 184,
                  height: 184,
                  fit: BoxFit.contain,
                  errorBuilder:
                      (_, __, ___) => const Icon(
                        Icons.image_not_supported,
                        color: Colors.white,
                        size: 80,
                      ),
                ),
              ),
            ),
          ),

          // Form area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 28, 28, 36),
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Sign In",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0D5C63),
                      ),
                    ),
                    const SizedBox(height: 24),

                    TextFormField(
                      controller: _usernameController,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your username";
                        }
                        if (value.trim().length < 3) {
                          return "Username is too short";
                        }
                        return null;
                      },
                      decoration: _inputStyle("Username"),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      validator:
                          (value) =>
                              value?.isEmpty ?? true
                                  ? "Password is required"
                                  : null,
                      decoration: _inputStyle("Password").copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: const Color(0xFF247B7B),
                          ),
                          onPressed:
                              () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Forgot password feature coming soon",
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Color(0xFF0D5C63),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSignIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF247B7B),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child:
                            _isLoading
                                ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.8,
                                  ),
                                )
                                : const Text(
                                  "Sign In",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Or divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade400)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "OR",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade400)),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Social buttons row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _socialIcon("images/google.png"),
                        const SizedBox(width: 20),
                        _socialIcon("images/facebook.png"),
                        const SizedBox(width: 20),
                        _socialIcon("images/apple-logo.png"),
                      ],
                    ),

                    const SizedBox(height: 40),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Color(0xFF0D5C63)),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const Signup()),
                            );
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Color(0xFF0D5C63),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF0D5C63)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF247B7B)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF247B7B)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF0D5C63), width: 1.8),
      ),
    );
  }

  Widget _socialIcon(String path) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF0D5C63).withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Image.asset(
          path,
          errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
        ),
      ),
    );
  }
}
