import 'package:flutter/material.dart';
import 'theme.dart';

class Assessments extends StatefulWidget {
  const Assessments({super.key});

  @override
  State<Assessments> createState() => _AssessmentsState();
}

class _AssessmentsState extends State<Assessments> {
  final _searchController = TextEditingController();
  String _query = '';

  static const _items = [
    _AssessmentData(
      icon: Icons.psychology_outlined,
      tag: 'Personality',
      title: 'What is MBTI test?',
      description:
          'Understand your personality type by exploring how you think, communicate, and make decisions. Supports personal growth and self-awareness.',
      cta: 'Ready to know more about your personality?',
      duration: '15 min',
      color: Color(0xFF0A3D42),
    ),
    _AssessmentData(
      icon: Icons.favorite_outline_rounded,
      tag: 'Mental Health',
      title: 'Why take this test?',
      description:
          'Explores how stress and anxiety may be affecting your daily life. Offers a snapshot of where you may be struggling so you can take steps toward balance.',
      cta: 'Ready to know more about your mental health?',
      duration: '10 min',
      color: Color(0xFF0D5C63),
    ),
    _AssessmentData(
      icon: Icons.sentiment_dissatisfied_outlined,
      tag: 'Anxiety',
      title: 'Anxiety & Stress Scale',
      description:
          'A validated questionnaire to measure current anxiety and stress levels, helping you identify triggers and patterns in your daily life.',
      cta: 'Ready to understand your stress levels?',
      duration: '8 min',
      color: Color(0xFF247B7B),
    ),
    _AssessmentData(
      icon: Icons.cloud_outlined,
      tag: 'Depression',
      title: 'Depression Screening (PHQ-9)',
      description:
          'A clinically validated 9-question tool that identifies symptoms of depression and measures severity to guide next steps.',
      cta: 'Ready to take a step toward clarity?',
      duration: '5 min',
      color: Color(0xFF44A1A0),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _query.toLowerCase();
    final filtered = q.isEmpty
        ? _items
        : _items
            .where((a) =>
                a.title.toLowerCase().contains(q) ||
                a.tag.toLowerCase().contains(q))
            .toList();

    return Scaffold(
      backgroundColor: SukoonColors.cream,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Assessments'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search assessments...',
                prefixIcon: const Icon(Icons.search, color: SukoonColors.muted),
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
          Expanded(
            child: filtered.isEmpty
                ? _EmptySearch(query: _query)
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (_, i) => _AssessmentCard(data: filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _AssessmentData {
  final IconData icon;
  final String tag, title, description, cta, duration;
  final Color color;
  const _AssessmentData({
    required this.icon, required this.tag, required this.title,
    required this.description, required this.cta, required this.duration,
    required this.color,
  });
}

class _AssessmentCard extends StatefulWidget {
  final _AssessmentData data;
  const _AssessmentCard({required this.data});

  @override
  State<_AssessmentCard> createState() => _AssessmentCardState();
}

class _AssessmentCardState extends State<_AssessmentCard> {
  bool _started = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coloured header strip
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: d.color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                Icon(d.icon, color: Colors.white, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(d.title,
                      style: const TextStyle(color: Colors.white,
                          fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.timer_outlined, color: Colors.white70, size: 12),
                      const SizedBox(width: 3),
                      Text(d.duration,
                          style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: d.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(d.tag,
                      style: TextStyle(color: d.color, fontSize: 11,
                          fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 10),
                Text(d.description,
                    style: const TextStyle(fontSize: 13,
                        color: SukoonColors.muted, height: 1.55)),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: SukoonColors.cream,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: d.color.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    children: [
                      Text(d.cta,
                          style: const TextStyle(fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: SukoonColors.deep),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () => setState(() => _started = !_started),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: _started ? SukoonColors.mid : d.color),
                          child: Text(_started ? 'In Progress...' : 'Start test'),
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
    );
  }
}

class _EmptySearch extends StatelessWidget {
  final String query;
  const _EmptySearch({required this.query});
  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.search_off_rounded, size: 52,
              color: SukoonColors.muted.withValues(alpha: 0.5)),
          const SizedBox(height: 12),
          Text('No results for "$query"',
              style: const TextStyle(color: SukoonColors.muted, fontSize: 15)),
        ]),
      );
}
