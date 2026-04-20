import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'theme.dart';
import 'therapist_profile.dart';

class Therapists extends StatefulWidget {
  const Therapists({super.key});

  @override
  State<Therapists> createState() => _TherapistsState();
}

class _TherapistsState extends State<Therapists> {
  List<Map<String, dynamic>> _all = [];
  bool _isLoading = true;
  String? _error;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetch() async {
    if (!mounted) return;
    setState(() { _isLoading = true; _error = null; });
    try {
      final res = await http
          .get(Uri.parse('http://localhost/sukoon_website/user/therapists.php'),
              headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;

      if (res.statusCode != 200) {
        setState(() => _error = 'Server error (${res.statusCode})');
        return;
      }

      final body = res.body.trim();
      if (body.startsWith('<')) {
        setState(() => _error = 'Server returned an unexpected response');
        return;
      }

      final data = jsonDecode(body) as Map<String, dynamic>;
      if (data['success'] == true) {
        final raw = data['data'] as List? ?? [];
        setState(() => _all = raw.whereType<Map<String, dynamic>>().toList());
      } else {
        setState(() => _error = (data['error'] as String?) ?? 'Failed to load');
      }
    } on FormatException {
      if (mounted) setState(() => _error = 'Invalid data received from server');
    } catch (e) {
      if (mounted) setState(() => _error = 'Connection failed. Check your network.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> get _filtered {
    if (_query.isEmpty) return _all;
    final q = _query.toLowerCase();
    return _all.where((t) {
      final name = '${t['firstname'] ?? ''} ${t['lastname'] ?? ''}'.toLowerCase();
      return name.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width > 700;
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: SukoonColors.cream,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Our Therapists'),
      ),
      body: Column(
        children: [
          // ── Search bar ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      hintText: 'Search therapist...',
                      prefixIcon: const Icon(Icons.search,
                          color: SukoonColors.muted, size: 20),
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close,
                                  color: SukoonColors.muted, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _query = '');
                              })
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                _FilterBtn(onTap: () {}),
              ],
            ),
          ),

          // ── Count row ──
          if (!_isLoading && _error == null)
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 0),
              child: Row(
                children: [
                  Text('${filtered.length} therapist${filtered.length == 1 ? '' : 's'} found',
                      style: const TextStyle(fontSize: 12,
                          color: SukoonColors.muted)),
                ],
              ),
            ),

          // ── Body ──
          Expanded(
            child: _isLoading
                ? const _LoadingGrid()
                : _error != null
                    ? _ErrorView(message: _error!, onRetry: _fetch)
                    : filtered.isEmpty
                        ? const _EmptyView()
                        : GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.all(isWide ? 24 : 14),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isWide ? 3 : 2,
                              childAspectRatio: 0.68,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: filtered.length,
                            itemBuilder: (_, i) =>
                                _TherapistCard(data: filtered[i]),
                          ),
          ),
        ],
      ),
    );
  }
}

// ── Therapist Card ────────────────────────────────────────────────────────

class _TherapistCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _TherapistCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final first = (data['firstname'] as String?) ?? '';
    final last = (data['lastname'] as String?) ?? '';
    final name = '$first $last'.trim().isEmpty ? 'Dr. Unknown' : '$first $last'.trim();
    final initials = (first.isNotEmpty && last.isNotEmpty)
        ? '${first[0]}${last[0]}'.toUpperCase()
        : 'DR';
    final imageUrl = data['image'] as String?;
    final specialty = (data['specialty'] as String?) ??
        (data['certificate'] as String?) ?? 'Therapist';

    final appointments = (data['appointments'] as List?) ?? [];
    final firstAppt = appointments.isNotEmpty
        ? (appointments.first as Map?)
        : null;
    final duration = (firstAppt?['duration'] as String?) ?? '60 Min';
    final feeRaw = firstAppt?['fee'];
    final fee = feeRaw != null ? '$feeRaw EGP' : '— EGP';
    final id = (data['therapist_id'] as int?) ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 32,
              backgroundColor: SukoonColors.teal,
              backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                  ? NetworkImage(imageUrl)
                  : null,
              onBackgroundImageError: imageUrl != null && imageUrl.isNotEmpty
                  ? (_, __) {}
                  : null,
              child: (imageUrl == null || imageUrl.isEmpty)
                  ? Text(initials,
                      style: const TextStyle(color: Colors.white,
                          fontSize: 17, fontWeight: FontWeight.bold))
                  : null,
            ),
            const SizedBox(height: 8),
            Text(name,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold,
                    color: SukoonColors.deep),
                textAlign: TextAlign.center,
                maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text(specialty,
                style: const TextStyle(fontSize: 11, color: SukoonColors.muted),
                maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_rounded, color: Colors.amber, size: 13),
                Icon(Icons.star_rounded, color: Colors.amber, size: 13),
                Icon(Icons.star_rounded, color: Colors.amber, size: 13),
                Icon(Icons.star_rounded, color: Colors.amber, size: 13),
                Icon(Icons.star_half_rounded, color: Colors.amber, size: 13),
              ],
            ),
            const SizedBox(height: 6),
            _InfoRow(Icons.access_time_rounded, duration),
            const SizedBox(height: 2),
            _InfoRow(Icons.monetization_on_outlined, fee),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => TherapistProfile(
                            therapistId: id, therapistName: name))),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: SukoonColors.teal,
                      side: const BorderSide(color: SukoonColors.teal),
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      textStyle: const TextStyle(fontSize: 10,
                          fontWeight: FontWeight.w600),
                    ),
                    child: const Text('View Profile'),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SukoonColors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                      textStyle: const TextStyle(fontSize: 10,
                          fontWeight: FontWeight.w600),
                    ),
                    child: const Text('Book Now'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoRow(this.icon, this.label);
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 11, color: SukoonColors.muted),
          const SizedBox(width: 3),
          Flexible(child: Text(label,
              style: const TextStyle(fontSize: 11, color: SukoonColors.muted),
              overflow: TextOverflow.ellipsis)),
        ],
      );
}

// ── Support widgets ───────────────────────────────────────────────────────

class _FilterBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _FilterBtn({required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50, width: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 6),
            ],
          ),
          child: const Icon(Icons.tune_rounded, color: SukoonColors.teal),
        ),
      );
}

class _LoadingGrid extends StatelessWidget {
  const _LoadingGrid();
  @override
  Widget build(BuildContext context) => GridView.builder(
        padding: const EdgeInsets.all(14),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.68,
            crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)]),
          child: const Center(child: CircularProgressIndicator(
              color: SukoonColors.teal, strokeWidth: 2)),
        ),
      );
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.wifi_off_rounded, size: 52, color: SukoonColors.muted),
            const SizedBox(height: 12),
            Text(message,
                style: const TextStyle(color: SukoonColors.muted, fontSize: 14),
                textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try Again'),
            ),
          ]),
        ),
      );
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();
  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.person_search_rounded, size: 52,
              color: SukoonColors.muted.withValues(alpha: 0.5)),
          const SizedBox(height: 12),
          const Text('No therapists found',
              style: TextStyle(color: SukoonColors.muted, fontSize: 15)),
        ]),
      );
}
