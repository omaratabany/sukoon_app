import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sukoon_app/Signup.dart';
import 'dart:convert';

class TherapistSignup extends StatefulWidget {
  const TherapistSignup({super.key});

  @override
  State<TherapistSignup> createState() => _PartnerSignupState();
}

class _PartnerSignupState extends State<TherapistSignup> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  // Therapist fields matching your database
  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _number =
      TextEditingController(); // Additional number
  final TextEditingController _certificate = TextEditingController();
  final TextEditingController _workplace = TextEditingController();
  final TextEditingController _username = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _firstname.dispose();
    _lastname.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _phone.dispose();
    _number.dispose();
    _certificate.dispose();
    _workplace.dispose();
    _username.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_form.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      debugPrint("Sending data to server...");

      final response = await http.post(
        Uri.parse(
          "http://localhost/sukoon_website/therapist/therapist_form.php",
        ),
        body: {
          "firstname": _firstname.text.trim(),
          "lastname": _lastname.text.trim(),
          "username": _username.text.trim(),
          "phone": _phone.text.trim(),
          "number": _number.text.trim(),
          "email": _email.text.trim(),
          "certificate": _certificate.text.trim(),
          "workplace": _workplace.text.trim(),
          "password": _password.text,
        },
      );

      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (data["status"] == "success") {
        _showSnackbar(
          "Therapist account created! Please sign in.",
          isError: false,
        );
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const TherapistSignup()),
        );
      } else {
        _showSnackbar(data["message"], isError: true);
      }
    } catch (e) {
      debugPrint("Connection error: $e");
      _showSnackbar("Connection error. Please try again.", isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? Colors.red.shade700 : const Color(0xFF0D5C63),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFA),
      body: Column(
        children: [
          // ── TOP: Gradient header with logo ──
          Container(
            width: double.infinity,
            height: 240,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0D5C63),
                  Color(0xFF247B7B),
                  Color(0xFF44A1A0),
                ],
                stops: [0.02, 0.47, 0.92],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Image.asset(
                  'lib/images/logo_2.png',
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      "Logo not found",
                      style: TextStyle(color: Colors.white),
                    );
                  },
                  width: 160,
                  height: 160,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // ── BOTTOM: Scrollable form ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // "Therapist Registration" title
                    const Text(
                      "Therapist Registration",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0D5C63),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Join as a mental health professional",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Email — full width
                    _buildField(
                      controller: _email,
                      label: "Email Address *",
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v!.isEmpty) return "Email is required";
                        if (!v.contains("@")) return "Enter a valid email";
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // First Name | Last Name
                    Row(
                      children: [
                        Expanded(
                          child: _buildField(
                            controller: _firstname,
                            label: "First Name *",
                            validator: (v) => v!.isEmpty ? "Required" : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildField(
                            controller: _lastname,
                            label: "Last Name *",
                            validator: (v) => v!.isEmpty ? "Required" : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Username | Phone
                    Row(
                      children: [
                        Expanded(
                          child: _buildField(
                            controller: _username,
                            label: "Username *",
                            validator: (v) => v!.isEmpty ? "Required" : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildField(
                            controller: _phone,
                            label: "Phone Number",
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Additional Number | Certificate
                    Row(
                      children: [
                        Expanded(
                          child: _buildField(
                            controller: _number,
                            label: "Additional Number",
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildField(
                            controller: _certificate,
                            label: "Certificate/License",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Workplace — full width
                    _buildField(
                      controller: _workplace,
                      label: "Workplace/Clinic",
                    ),
                    const SizedBox(height: 16),

                    // Password — full width
                    _buildPasswordField(
                      controller: _password,
                      label: "Password *",
                      obscure: _obscurePassword,
                      toggleObscure:
                          () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                      validator: (v) {
                        if (v!.isEmpty) return "Password is required";
                        if (v.length < 6) return "Minimum 6 characters";
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Confirm Password — full width
                    _buildPasswordField(
                      controller: _confirmPassword,
                      label: "Confirm Password *",
                      obscure: _obscureConfirm,
                      toggleObscure:
                          () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                          ),
                      validator: (v) {
                        if (v!.isEmpty) return "Please confirm password";
                        if (v != _password.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Create Account button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF247B7B),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: _isLoading ? null : _signup,
                        child:
                            _isLoading
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                                : const Text(
                                  "Register as Therapist",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFFFFFFA),
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // "Already Have An Account? Sign In"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: Color(0xFF0D5C63),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const Signup()),
                            );
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0D5C63),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "* Required fields",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
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

  // ── Text field styled to match Figma borders ──
  Widget _buildField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        color: Color(0xFF0D5C63),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: Color(0xFF0D5C63),
        ),
        filled: true,
        fillColor: const Color(0xFFFFFFFA),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF247B7B)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF0D5C63), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  // ── Password field with show/hide toggle ──
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback toggleObscure,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        color: Color(0xFF0D5C63),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: Color(0xFF0D5C63),
        ),
        filled: true,
        fillColor: const Color(0xFFFFFFFA),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: const Color(0xFF247B7B),
            size: 20,
          ),
          onPressed: toggleObscure,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF247B7B)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF0D5C63), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
