import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:sukoon_app/therapist_form.dart';

// ─────────────────────────────────────────────
//  Replace this import with your actual path
//  import 'add_appointment.dart';
// ─────────────────────────────────────────────

class TherapistHomePage extends StatefulWidget {
  const TherapistHomePage({super.key});

  @override
  State<TherapistHomePage> createState() => _TherapistHomePageState();
}

class _TherapistHomePageState extends State<TherapistHomePage>
    with SingleTickerProviderStateMixin {
  // ── State ──────────────────────────────────
  String _therapistName = "Therapist";
  List<Map<String, dynamic>> _bookings = [];
  bool _isLoadingBookings = false;
  String? _bookingError;

  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  // ── Palette (matches AddAppointment) ───────
  static const _teal = Color(0xFF0D5C63);
  static const _midTeal = Color(0xFF247B7B);
  static const _lightTeal = Color(0xFF44A1A0);
  static const _bg = Color(0xFFFFFFFA);

  // ── Lifecycle ──────────────────────────────
  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _loadTherapistInfo();
    _fetchBookings();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ── Data Loading ───────────────────────────
  Future<void> _loadTherapistInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('username') ?? "Therapist";
    if (mounted) setState(() => _therapistName = name);
  }

  Future<void> _fetchBookings() async {
    setState(() {
      _isLoadingBookings = true;
      _bookingError = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final therapistId = prefs.getInt('user_id') ?? 0;

      if (therapistId == 0) {
        setState(
          () => _bookingError = "Session expired. Please sign in again.",
        );
        return;
      }

      final url =
          "http://localhost/sukoon_website/therapist/get_bookings.php?therapist_id=$therapistId";

      final response = await http
          .get(Uri.parse(url), headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;

      if (response.body.trim().startsWith('<')) {
        setState(
          () => _bookingError = "Server error: unexpected HTML response.",
        );
        return;
      }

      final data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        final List raw = data['bookings'] ?? [];
        setState(() {
          _bookings = raw.cast<Map<String, dynamic>>();
        });
        _fadeCtrl.forward();
      } else {
        setState(
          () =>
              _bookingError =
                  data['message']?.toString() ?? "Failed to load bookings.",
        );
      }
    } catch (e) {
      if (mounted) setState(() => _bookingError = "Connection failed: $e");
    } finally {
      if (mounted) setState(() => _isLoadingBookings = false);
    }
  }

  // ── UI Helpers ─────────────────────────────
  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFF2E7D5E);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'cancelled':
        return const Color(0xFFDC2626);
      default:
        return _midTeal;
    }
  }

  Color _statusBg(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFFD1FAE5);
      case 'pending':
        return const Color(0xFFFEF3C7);
      case 'cancelled':
        return const Color(0xFFFEE2E2);
      default:
        return const Color(0xFFE0F2F1);
    }
  }

  // ── Build ───────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _buildHeader(),
          _buildActionButtons(),
          _buildBookingsSectionTitle(),
          Expanded(child: _buildBookingsList()),
        ],
      ),
    );
  }

  // ── Header ──────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_teal, _midTeal, _lightTeal],
          stops: [0.0, 0.4954, 0.9908],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'lib/images/logo_2.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                    errorBuilder:
                        (_, __, ___) => const Icon(
                          Icons.spa,
                          color: Colors.white,
                          size: 40,
                        ),
                  ),
                  // Notification bell (cosmetic; wire up as needed)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                "Welcome back,",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 15,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _therapistName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              // Summary pill
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${_bookings.length} booking${_bookings.length == 1 ? '' : 's'} total",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Action Buttons ──────────────────────────
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: _ActionCard(
              icon: Icons.add_circle_outline_rounded,
              label: "Add\nAppointment",
              color: _teal,
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    // ── Replace with your actual AddAppointment widget ──
                    builder: (_) => const AddAppointment(),
                  ),
                );
                // Refresh bookings when returning
                _fetchBookings();
              },
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _ActionCard(
              icon: Icons.calendar_month_rounded,
              label: "View\nBookings",
              color: _midTeal,
              onTap: _fetchBookings,
            ),
          ),
        ],
      ),
    );
  }

  // ── Section Title ───────────────────────────
  Widget _buildBookingsSectionTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Your Bookings",
            style: TextStyle(
              color: _teal,
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
          GestureDetector(
            onTap: _fetchBookings,
            child: const Row(
              children: [
                Icon(Icons.refresh_rounded, color: _midTeal, size: 18),
                SizedBox(width: 4),
                Text(
                  "Refresh",
                  style: TextStyle(
                    color: _midTeal,
                    fontSize: 13,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Bookings List ───────────────────────────
  Widget _buildBookingsList() {
    if (_isLoadingBookings) {
      return const Center(child: CircularProgressIndicator(color: _midTeal));
    }

    if (_bookingError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: _lightTeal,
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                _bookingError!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _teal,
                  fontFamily: 'Inter',
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _fetchBookings,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text("Try Again"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _midTeal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_busy_rounded,
              color: _lightTeal.withOpacity(0.5),
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              "No bookings yet",
              style: TextStyle(
                color: _teal,
                fontFamily: 'Inter',
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Add an appointment to get started",
              style: TextStyle(
                color: _midTeal.withOpacity(0.7),
                fontFamily: 'Inter',
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return FadeTransition(
      opacity: _fadeAnim,
      child: RefreshIndicator(
        color: _teal,
        onRefresh: _fetchBookings,
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          itemCount: _bookings.length,
          itemBuilder: (context, index) {
            final b = _bookings[index];
            return _BookingCard(
              patientName: b['patient_name']?.toString() ?? "Patient",
              date: b['date']?.toString() ?? "—",
              fee: b['fee']?.toString() ?? "—",
              duration: b['duration']?.toString() ?? "—",
              status: b['status']?.toString(),
              statusColor: _statusColor(b['status']?.toString()),
              statusBg: _statusBg(b['status']?.toString()),
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Reusable Action Card
// ─────────────────────────────────────────────
class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.25)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.10),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Booking Card
// ─────────────────────────────────────────────
class _BookingCard extends StatelessWidget {
  final String patientName, date, fee, duration;
  final String? status;
  final Color statusColor, statusBg;

  const _BookingCard({
    required this.patientName,
    required this.date,
    required this.fee,
    required this.duration,
    this.status,
    required this.statusColor,
    required this.statusBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF247B7B).withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D5C63).withOpacity(0.07),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: patient name + status badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: const Color(
                          0xFF44A1A0,
                        ).withOpacity(0.15),
                        child: Text(
                          patientName.isNotEmpty
                              ? patientName[0].toUpperCase()
                              : "P",
                          style: const TextStyle(
                            color: Color(0xFF0D5C63),
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          patientName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF0D5C63),
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (status != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status!.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 14),
            const Divider(height: 1, color: Color(0xFFE0F2F1)),
            const SizedBox(height: 14),

            // Info row (wraps on narrow widths to avoid overflow)
            Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _InfoChip(icon: Icons.calendar_today_rounded, label: date),
                _InfoChip(icon: Icons.attach_money_rounded, label: '$fee EGP'),
                _InfoChip(icon: Icons.timer_outlined, label: duration),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Small info chip inside booking card
// ─────────────────────────────────────────────
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF247B7B)),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF0D5C63),
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Placeholder — replace with your AddAppointment import
// ─────────────────────────────────────────────
class _AddAppointmentPlaceholder extends StatelessWidget {
  const _AddAppointmentPlaceholder();

  @override
  Widget build(BuildContext context) {
    // TODO: Replace this entire widget with:
    // import 'add_appointment.dart';
    // and use AddAppointment() directly in the Navigator.push above.
    return const Scaffold(
      body: Center(child: Text("AddAppointment widget goes here")),
    );
  }
}
