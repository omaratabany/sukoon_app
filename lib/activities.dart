import 'package:flutter/material.dart';
import 'theme.dart';

class Activities extends StatefulWidget {
  const Activities({super.key});

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  final _searchController = TextEditingController();
  String _query = '';
  int? _selected; // expanded category index

  static const _categories = [
    _Category(
      icon: Icons.school_outlined,
      label: 'Classes',
      subtitle: 'Yoga, meditation, fitness & more',
      color: Color(0xFF0A3D42),
      items: ['Aerial Yoga', 'Meditation Basics', 'Zumba', 'Pilates',
          'Flexibility Training', 'Acro Yoga'],
    ),
    _Category(
      icon: Icons.workspaces_outlined,
      label: 'WorkShops',
      subtitle: 'Skill-building & group sessions',
      color: Color(0xFF0D5C63),
      items: ['Stress Management', 'Mindful Communication', 'CBT Basics',
          'Art Therapy', 'Journaling Workshop'],
    ),
    _Category(
      icon: Icons.cabin_outlined,
      label: 'Camps',
      subtitle: 'Immersive wellness retreats',
      color: Color(0xFF247B7B),
      items: ['Weekend Wellness Retreat', 'Nature Detox Camp',
          'Youth Mental Health Camp', 'Family Bonding Camp'],
    ),
    _Category(
      icon: Icons.groups_outlined,
      label: 'Support Groups',
      subtitle: 'Peer-led community sessions',
      color: Color(0xFF44A1A0),
      items: ['Anxiety Support Circle', 'Grief & Loss Group',
          'Women\'s Wellness Group', 'Teen Mental Health', 'Parents Support Group'],
    ),
  ];

  List<_Category> get _filtered {
    if (_query.isEmpty) return _categories;
    final q = _query.toLowerCase();
    return _categories
        .where((c) =>
            c.label.toLowerCase().contains(q) ||
            c.items.any((i) => i.toLowerCase().contains(q)))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: SukoonColors.cream,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Activities'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search activities...',
                prefixIcon: const Icon(Icons.search, color: SukoonColors.muted),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, color: SukoonColors.muted, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const _EmptySearch()
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final cat = filtered[i];
                      final idx = _categories.indexOf(cat);
                      final isOpen = _selected == idx;
                      return _CategoryTile(
                        category: cat,
                        isOpen: isOpen,
                        onTap: () => setState(
                            () => _selected = isOpen ? null : idx),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _Category {
  final IconData icon;
  final String label, subtitle;
  final Color color;
  final List<String> items;
  const _Category({required this.icon, required this.label,
      required this.subtitle, required this.color, required this.items});
}

class _CategoryTile extends StatelessWidget {
  final _Category category;
  final bool isOpen;
  final VoidCallback onTap;
  const _CategoryTile({required this.category, required this.isOpen,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: category.color,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isOpen ? 0 : 18),
                  bottomRight: Radius.circular(isOpen ? 0 : 18),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        bottomLeft: Radius.circular(isOpen ? 0 : 18),
                      ),
                    ),
                    child: Icon(category.icon, color: Colors.white, size: 34),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(category.label,
                            style: const TextStyle(color: Colors.white,
                                fontSize: 16, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 3),
                        Text(category.subtitle,
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.75),
                                fontSize: 12)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: AnimatedRotation(
                      turns: isOpen ? 0.25 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(Icons.arrow_forward_ios_rounded,
                          color: Colors.white.withValues(alpha: 0.8), size: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isOpen)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: category.items.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, indent: 16, endIndent: 16),
              itemBuilder: (_, i) => ListTile(
                dense: true,
                leading: const Icon(Icons.arrow_right_rounded,
                    color: SukoonColors.teal, size: 22),
                title: Text(category.items[i],
                    style: const TextStyle(fontSize: 14,
                        color: SukoonColors.deep, fontWeight: FontWeight.w500)),
                trailing: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                      foregroundColor: SukoonColors.teal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      textStyle: const TextStyle(fontSize: 12,
                          fontWeight: FontWeight.w600)),
                  child: const Text('Book'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  const _EmptySearch();
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded,
                size: 52, color: SukoonColors.muted.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            const Text('No activities found',
                style: TextStyle(fontSize: 16, color: SukoonColors.muted)),
          ],
        ),
      );
}
