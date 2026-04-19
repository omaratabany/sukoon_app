import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _age = TextEditingController();

  String? _selectedGender;
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
    _location.dispose();
    _username.dispose();
    _age.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_form.currentState!.validate()) return;

    if (_selectedGender == null) {
      _showSnackbar("Please select a gender.", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final url = "http://10.0.2.2/sukoon_website/user/signup.php";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          "firstname": _firstname.text.trim(),
          "lastname": _lastname.text.trim(),
          "username": _username.text.trim(),
          "age": _age.text.trim(),
          "phone_number": _phone.text.trim(),
          "gender": _selectedGender!,
          "location": _location.text.trim(),
          "email": _email.text.trim(),
          "password": _password.text,
        },
      );

      if (!mounted) return;

      final data = jsonDecode(response.body);

      if (data["status"] == "success") {
        _showSnackbar("Account created! Please sign in.", isError: false);

        await Future.delayed(const Duration(seconds: 1));

        if (!mounted) return;

        Navigator.pushReplacementNamed(context, '/signin');
      } else {
        _showSnackbar(data["message"] ?? "Signup failed", isError: true);
      }
    } catch (e) {
      _showSnackbar("Connection error", isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : const Color(0xFF0D5C63),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFA),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 220,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0D5C63),
                  Color(0xFF247B7B),
                  Color(0xFF44A1A0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: const Center(
              child: Text(
                "Create Account",
                style: TextStyle(color: Colors.white, fontSize: 26),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    _buildField(_email, "Email"),
                    _buildField(_firstname, "First Name"),
                    _buildField(_lastname, "Last Name"),
                    _buildField(_username, "Username"),
                    _buildField(
                      _age,
                      "Age",
                      keyboardType: TextInputType.number,
                    ),
                    _buildField(_phone, "Phone"),
                    _buildField(_location, "Location"),

                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      hint: const Text("Select Gender"),
                      items:
                          ["Male", "Female"]
                              .map(
                                (g) =>
                                    DropdownMenuItem(value: g, child: Text(g)),
                              )
                              .toList(),
                      onChanged: (val) => setState(() => _selectedGender = val),
                    ),

                    const SizedBox(height: 10),

                    _buildPassword(_password, "Password", _obscurePassword, () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    }),

                    _buildPassword(
                      _confirmPassword,
                      "Confirm Password",
                      _obscureConfirm,
                      () {
                        setState(() => _obscureConfirm = !_obscureConfirm);
                      },
                      validator:
                          (v) =>
                              v == _password.text
                                  ? null
                                  : "Passwords do not match",
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _signup,
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text("Sign Up"),
                    ),

                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/signin');
                      },
                      child: const Text("Already have an account? Sign in"),
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

  Widget _buildField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (v) => v!.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildPassword(
    TextEditingController controller,
    String label,
    bool obscure,
    VoidCallback toggle, {
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator ?? (v) => v!.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: IconButton(
            icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: toggle,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
