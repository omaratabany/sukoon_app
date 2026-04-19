import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'therapist_profile.dart'; // Import the profile page

class Therapists extends StatefulWidget {
  const Therapists({super.key});

  @override
  State<Therapists> createState() => _TherapistsPageState();
}

class _TherapistsPageState extends State<Therapists> {
  List<dynamic> _therapists = [];
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTherapists();
  }

  Future<void> _fetchTherapists() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse("http://localhost/sukoon_website/user/therapists.php"),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            _therapists = data['data'];
          });
        } else {
          _errorMessage = data['error'] ?? 'Failed to load therapists';
        }
      } else {
        _errorMessage = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : const Color(0xFF0D5C63),
        behavior: SnackBarBehavior.floating,
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
            height: 59,
            color: const Color(0xFF0D5C63),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Image.asset(
                  'lib/images/logo_2.png',
                  height: 40,
                  errorBuilder:
                      (_, __, ___) => Container(
                        width: 80,
                        height: 40,
                        color: Colors.white24,
                        child: const Center(
                          child: Text(
                            'Sukoon',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          _fetchTherapists();
                        } else {
                          setState(() {});
                        }
                      },
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.white60),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                GestureDetector(
                  onTap: () {
                    _showMessage('Menu clicked');
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 24, height: 3, color: Colors.white),
                      const SizedBox(height: 5),
                      Container(width: 24, height: 3, color: Colors.white),
                      const SizedBox(height: 5),
                      Container(width: 24, height: 3, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child:
                _isLoading
                    ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF0D5C63),
                      ),
                    )
                    : _errorMessage != null
                    ? Center(
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
                            onPressed: _fetchTherapists,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF247B7B),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                    : SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'About our doctors',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF0D5C63),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Our therapists are certified, highly trained professionals who bring years of experience in supporting mental health and personal growth.',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF0D5C63),
                                        height: 1.6,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),

                              Flexible(
                                child: Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 268,
                                  ),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF78CDD7,
                                    ).withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Patient's reviews:",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF0D5C63),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF0D5C63),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            const Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'The help was amazing and very comforting',
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: Color(
                                                        0xFF0D5C63,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 2),
                                                  Text(
                                                    'Sunday, 11 November 2025  9:00 PM',
                                                    style: TextStyle(
                                                      fontSize: 6,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: Color(
                                                        0xFF0D5C63,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // Therapists grid
                          _therapists.isEmpty
                              ? const Center(
                                child: Text(
                                  'No therapists available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF0D5C63),
                                  ),
                                ),
                              )
                              : GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.82,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                    ),
                                itemCount: _therapists.length,
                                itemBuilder: (context, index) {
                                  final therapist = _therapists[index];
                                  final appointments =
                                      therapist['appointments'] ?? [];
                                  final hasAppointments =
                                      appointments.isNotEmpty;

                                  final firstApp =
                                      hasAppointments
                                          ? appointments.first
                                          : null;
                                  final duration =
                                      firstApp?['duration'] ?? '60 Minutes';
                                  final fee =
                                      firstApp?['fee'] != null
                                          ? '${firstApp['fee']} EGP'
                                          : '— EGP';

                                  final firstName =
                                      therapist['firstname'] ?? '';
                                  final lastName = therapist['lastname'] ?? '';
                                  final initials =
                                      (firstName.isNotEmpty &&
                                              lastName.isNotEmpty)
                                          ? '${firstName[0]}${lastName[0]}'
                                              .toUpperCase()
                                          : 'DR';

                                  return _buildTherapistCard(
                                    id: therapist['therapist_id'] ?? 0,
                                    name: '$firstName $lastName',
                                    initials: initials,
                                    duration: duration,
                                    fee: fee,
                                    appointments: appointments,
                                    hasAppointments: hasAppointments,
                                  );
                                },
                              ),
                        ],
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildTherapistCard({
    required int id,
    required String name,
    required String initials,
    required String duration,
    required String fee,
    required List appointments,
    required bool hasAppointments,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF44A1A0),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row with avatar and info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 62,
                height: 88,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D5C63),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    const Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 10),
                        Icon(Icons.star, color: Colors.amber, size: 10),
                        Icon(Icons.star, color: Colors.amber, size: 10),
                        Icon(Icons.star, color: Colors.amber, size: 10),
                        Icon(Icons.star, color: Colors.amber, size: 10),
                      ],
                    ),
                    const SizedBox(height: 4),
                    _buildMetaRow('Duration:', duration),
                    _buildMetaRow('Fees:', fee),
                  ],
                ),
              ),
            ],
          ),

          if (hasAppointments) ...[
            const SizedBox(height: 8),
            const Divider(color: Colors.white30),
            const SizedBox(height: 4),

            // Appointments section
            const Text(
              'Available Schedule',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),

            // Show up to 2 appointments (taller cards use more vertical space)
            ...appointments
                .take(2)
                .map<Widget>(
                  (app) => Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        _buildApptRow('Date:', app['date'] ?? 'N/A'),
                        _buildApptRow('Duration:', app['duration'] ?? 'N/A'),
                        _buildApptRow('Fee:', '${app['fee']} EGP'),
                      ],
                    ),
                  ),
                ),

            if (appointments.length > 2)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  '+${appointments.length - 2} more',
                  style: const TextStyle(
                    fontSize: 7,
                    fontStyle: FontStyle.italic,
                    color: Colors.white70,
                  ),
                ),
              ),
          ] else ...[
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'No upcoming slots available',
                style: TextStyle(
                  fontSize: 8,
                  fontStyle: FontStyle.italic,
                  color: Colors.white60,
                ),
              ),
            ),
          ],

          const SizedBox(height: 10),

          // Buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Navigate to therapist profile page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => TherapistProfile(
                              therapistId: id,
                              therapistName: name,
                            ),
                      ),
                    );
                  },
                  child: Container(
                    height: 17,
                    decoration: BoxDecoration(
                      color: const Color(0xFF78CDD7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'View profile',
                        style: TextStyle(fontSize: 7, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _showMessage('Booking appointment with $name');
                  },
                  child: Container(
                    height: 17,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D5C63),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Book now',
                        style: TextStyle(fontSize: 7, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetaRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 8,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0D5C63),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 8,
              fontStyle: FontStyle.italic,
              color: Color(0xFF0D5C63),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildApptRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 7,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 7,
              fontStyle: FontStyle.italic,
              color: Colors.white,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
