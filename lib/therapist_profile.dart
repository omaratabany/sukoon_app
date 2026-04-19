import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TherapistProfile extends StatefulWidget {
  final int therapistId;
  final String therapistName;

  const TherapistProfile({
    super.key,
    required this.therapistId,
    required this.therapistName,
  });

  @override
  State<TherapistProfile> createState() => _TherapistProfileState();
}

class _TherapistProfileState extends State<TherapistProfile> {
  Map<String, dynamic> _therapist = {};
  List<dynamic> _appointments = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTherapistProfile();
  }

  Future<void> _fetchTherapistProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print("Fetching therapist ID: ${widget.therapistId}");
      final url =
          "http://localhost/sukoon_website/therapist/therapist_profile.php?id=${widget.therapistId}";
      print("URL: $url");

      final response = await http
          .get(Uri.parse(url), headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 10));

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (!mounted) return;

      if (response.body.trim().startsWith('<')) {
        setState(() => _errorMessage = 'Server returned HTML instead of JSON');
        return;
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == true) {
          setState(() {
            _therapist = data['therapist'];
            _appointments = data['appointments'] ?? [];
          });
        } else {
          setState(
            () =>
                _errorMessage =
                    data['error'] ?? 'Failed to load therapist profile',
          );
        }
      } else {
        setState(() => _errorMessage = 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      print("Connection error: $e");
      if (mounted) setState(() => _errorMessage = 'Connection error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  String _getInitials() {
    if (_therapist.isNotEmpty && _therapist['initials'] != null) {
      return _therapist['initials'];
    }
    if (_therapist.isNotEmpty) {
      final first = _therapist['firstname'] ?? '';
      final last = _therapist['lastname'] ?? '';
      if (first.isNotEmpty && last.isNotEmpty) {
        return '${first[0]}${last[0]}'.toUpperCase();
      }
    }
    if (widget.therapistName.isNotEmpty) {
      final parts = widget.therapistName.split(' ');
      if (parts.length >= 2)
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      if (parts.isNotEmpty) return parts[0].substring(0, 1).toUpperCase();
    }
    return 'DR';
  }

  String _getFullName() {
    if (_therapist.isNotEmpty) {
      return _therapist['fullName'] ??
          '${_therapist['firstname'] ?? ''} ${_therapist['lastname'] ?? ''}'
              .trim();
    }
    return widget.therapistName;
  }

  String _getSpecialty() =>
      _therapist['specialty'] ?? _therapist['certificate'] ?? 'Therapist';
  String _getWorkplace() => _therapist['workplace'] ?? 'Private Practice';
  String _getEmail() => _therapist['email'] ?? '—';
  String _getPhone() => _therapist['phone'] ?? '—';
  String _getCertificate() => _therapist['certificate'] ?? '—';
  String _getLanguage() => _therapist['language'] ?? 'Arabic';

  int _getTotalBookings() {
    if (_therapist['totalBookings'] != null) return _therapist['totalBookings'];
    return _appointments.length;
  }

  // ── Build ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFA),
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: const Color(0xFF0D5C63),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF0D5C63)),
              )
              : _errorMessage != null
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchTherapistProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF247B7B),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back link
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xFF0D5C63),
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Back to Therapists',
                            style: TextStyle(
                              color: Color(0xFF0D5C63),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Page title
                    const Text(
                      'My Profile',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0D5C63),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Hero card
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF44A1A0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        children: [
                          // Avatar
                          Container(
                            width: 90,
                            height: 110,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D5C63),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                _getInitials(),
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          // Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getFullName(),
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _getSpecialty(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _getWorkplace(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Personal information
                    _sectionCard(
                      title: 'Personal information',
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildInfoItem(
                              'Education',
                              _getCertificate(),
                            ),
                          ),
                          Expanded(
                            child: _buildInfoItem(
                              'Extra knowledge',
                              _getSpecialty(),
                            ),
                          ),
                          Expanded(child: _buildInfoItem('Email', _getEmail())),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // History
                    _sectionCard(
                      title: 'History',
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildInfoItem(
                              'Bookings',
                              '${_getTotalBookings()} Total bookings',
                            ),
                          ),
                          Expanded(
                            child: _buildInfoItem('Language', _getLanguage()),
                          ),
                          Expanded(
                            child: _buildInfoItem(
                              'Joining Date',
                              _appointments.isNotEmpty
                                  ? _formatDate(_appointments.first['date'])
                                  : '—',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Book Now button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Booking with ${_getFullName()}'),
                              backgroundColor: const Color(0xFF247B7B),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D5C63),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Book Now',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  // ── Widgets ───────────────────────────────────────────────────────────────────

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF44A1A0), width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF44A1A0),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF44A1A0),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 13, color: Color(0xFF44A1A0)),
        ),
      ],
    );
  }

  // ── Date helpers ──────────────────────────────────────────────────────────────

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '—';
    try {
      final date = DateTime.parse(dateStr);
      final day = date.day;
      final suffix = _getDaySuffix(day);
      final month = _getMonthName(date.month);
      return '$day$suffix of $month ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
