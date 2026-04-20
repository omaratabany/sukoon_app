// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'theme.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _form = GlobalKey<FormState>();
  final _firstname = TextEditingController();
  final _lastname = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _phone = TextEditingController();
  final _location = TextEditingController();
  final _username = TextEditingController();
  final _age = TextEditingController();

  String? _selectedGender;
  bool _isLoading = false;
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    for (final c in [
      _firstname, _lastname, _email, _password,
      _confirmPassword, _phone, _location, _username, _age,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_form.currentState!.validate()) return;
    if (_selectedGender == null) {
      _snack('Please select a gender.', error: true);
      return;
    }
    setState(() => _isLoading = true);
    try {
      final res = await http.post(
        Uri.parse('http://10.0.2.2/sukoon_website/user/signup.php'),
        body: {
          'firstname': _firstname.text.trim(),
          'lastname': _lastname.text.trim(),
          'username': _username.text.trim(),
          'age': _age.text.trim(),
          'phone_number': _phone.text.trim(),
          'gender': _selectedGender!,
          'location': _location.text.trim(),
          'email': _email.text.trim(),
          'password': _password.text,
        },
      );
      if (!mounted) return;
      final data = jsonDecode(res.body);
      if (data['status'] == 'success') {
        _snack('Account created! Please sign in.');
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/signin');
      } else {
        _snack(data['message'] ?? 'Signup failed', error: true);
      }
    } catch (_) {
      _snack('Connection error', error: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? Colors.red : SukoonColors.teal,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width > 700;
    final hPad = isWide ? size.width * 0.28 : 24.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Teal header background
          Container(
            height: size.height * 0.3,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [SukoonColors.deep, SukoonColors.teal],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.3,
            width: size.width,
            child: CustomPaint(painter: MountainPainter()),
          ),
          // White form card
          Positioned(
            top: size.height * 0.2,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
            ),
          ),
          // Logo + title in header
          Positioned(
            top: size.height * 0.04,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Image.asset(
                  'lib/images/logo_2.png',
                  height: 52,
                  errorBuilder: (_, __, ___) => const Text(
                    'سُكُون',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Sign Up',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          // Form
          Positioned.fill(
            top: size.height * 0.24,
            child: Form(
              key: _form,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // First + Last name row
                    Row(
                      children: [
                        Expanded(child: _field(_firstname, 'First Name')),
                        const SizedBox(width: 12),
                        Expanded(child: _field(_lastname, 'Last Name')),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Phone + Gender row
                    Row(
                      children: [
                        Expanded(
                          child: _field(_phone, 'Phone Number',
                              keyboardType: TextInputType.phone),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedGender,
                            hint: const Text('Gender'),
                            decoration: const InputDecoration(),
                            items: ['Female', 'Male']
                                .map((g) => DropdownMenuItem(
                                    value: g, child: Text(g)))
                                .toList(),
                            onChanged: (v) =>
                                setState(() => _selectedGender = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _field(_location, 'Location'),
                    const SizedBox(height: 12),
                    _field(_username, 'Username'),
                    const SizedBox(height: 12),
                    _field(_age, 'Age',
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 12),
                    _field(_email, 'Email',
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 12),
                    _passField(_password, 'Password', _obscurePass,
                        () => setState(() => _obscurePass = !_obscurePass)),
                    const SizedBox(height: 12),
                    _passField(
                      _confirmPassword,
                      'Confirm Password',
                      _obscureConfirm,
                      () => setState(
                          () => _obscureConfirm = !_obscureConfirm),
                      validator: (v) => v == _password.text
                          ? null
                          : 'Passwords do not match',
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signup,
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white),
                              )
                            : const Text('Create Account',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already Have An Account? ',
                            style: TextStyle(
                                color: SukoonColors.muted, fontSize: 14)),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(
                              context, '/signin'),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                                color: SukoonColors.teal,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
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

  Widget _field(TextEditingController c, String hint,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: c,
      keyboardType: keyboardType,
      decoration: InputDecoration(hintText: hint),
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
    );
  }

  Widget _passField(
    TextEditingController c,
    String hint,
    bool obscure,
    VoidCallback toggle, {
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: c,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: IconButton(
          icon: Icon(
            obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: SukoonColors.muted,
            size: 20,
          ),
          onPressed: toggle,
        ),
      ),
      validator: validator ??
          (v) => (v == null || v.isEmpty) ? 'Required' : null,
    );
  }
}
