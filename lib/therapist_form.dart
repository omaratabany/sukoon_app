import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddAppointment extends StatefulWidget {
  const AddAppointment({super.key});

  @override
  State<AddAppointment> createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _feeController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF0D5C63),
                onPrimary: Colors.white,
                onSurface: Color(0xFF0D5C63),
              ),
            ),
            child: child!,
          ),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_form.currentState!.validate()) return;
    if (_selectedDate == null) {
      _showSnackBar("Please select a date", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final therapistId = prefs.getInt('user_id') ?? 0;

    if (therapistId == 0) {
      _showSnackBar("Session expired. Please sign in again.", isError: true);
      setState(() => _isLoading = false);
      return;
    }

    final url = "http://localhost/sukoon_website/therapist/therapist_form.php";
    final dateStr =
        "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";

    print("→ Submitting appointment → $url");
    print(
      "→ date: $dateStr, fee: ${_feeController.text}, duration: ${_durationController.text}, therapist_id: $therapistId",
    );

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
              'Accept': 'application/json',
            },
            body: {
              'date': dateStr,
              'fee': _feeController.text.trim(),
              'duration': _durationController.text.trim(),
              'therapist_id': therapistId.toString(),
            },
          )
          .timeout(const Duration(seconds: 10));

      print("← Status: ${response.statusCode}");
      print("← Body: ${response.body}");

      if (!mounted) return;

      if (response.body.trim().startsWith('<')) {
        _showSnackBar(
          "Server error: Received HTML instead of JSON",
          isError: true,
        );
        return;
      }

      Map<String, dynamic> data;
      try {
        data = jsonDecode(response.body);
      } catch (e) {
        _showSnackBar("Invalid response from server", isError: true);
        return;
      }

      if (data['status'] == 'success') {
        _showSnackBar("Appointment added successfully!", isError: false);
        // Clear form
        _feeController.clear();
        _durationController.clear();
        setState(() => _selectedDate = null);
      } else {
        _showSnackBar(
          data['message']?.toString() ?? "Failed to add appointment",
          isError: true,
        );
      }
    } catch (e) {
      print("Exception: $e");
      if (mounted) {
        _showSnackBar("Connection failed: ${e.toString()}", isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
          // Header
          Container(
            width: double.infinity,
            height: 200,
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
                  width: 130,
                  height: 130,
                  fit: BoxFit.contain,
                  errorBuilder:
                      (_, __, ___) => const Icon(
                        Icons.image_not_supported,
                        color: Colors.white,
                        size: 60,
                      ),
                ),
              ),
            ),
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 28, 28, 36),
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Add Appointment",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0D5C63),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Date picker
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF247B7B)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Color(0xFF247B7B),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _selectedDate == null
                                  ? "Select Date"
                                  : "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}",
                              style: TextStyle(
                                color:
                                    _selectedDate == null
                                        ? Colors.grey.shade500
                                        : const Color(0xFF0D5C63),
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Fee
                    TextFormField(
                      controller: _feeController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty)
                          return "Please enter session fee";
                        if (double.tryParse(value.trim()) == null)
                          return "Enter a valid number";
                        return null;
                      },
                      decoration: _inputStyle("Session Fee"),
                    ),
                    const SizedBox(height: 16),

                    // Duration
                    TextFormField(
                      controller: _durationController,
                      textInputAction: TextInputAction.done,
                      validator:
                          (value) =>
                              value == null || value.trim().isEmpty
                                  ? "Please enter duration"
                                  : null,
                      decoration: _inputStyle("Duration (e.g. 60 mins)"),
                    ),
                    const SizedBox(height: 32),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSubmit,
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
                                  "Add Session",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
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
}
