import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme.dart';
import 'therapists.dart';
import 'assessments.dart';
import 'activities.dart';
import 'notifications_page.dart';
import 'profile_page.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  int _tab = 0;

  void _onTabTap(int i) {
    HapticFeedback.selectionClick();
    setState(() => _tab = i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SukoonColors.cream,
      body: IndexedStack(
        index: _tab,
        children: [
          _HomeContent(onNavTap: _onTabTap),
          const NotificationsPage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: _SukoonBottomNav(
        currentIndex: _tab,
        onTap: _onTabTap,
      ),
    );
  }
}

// ─── Bottom Navigation ─────────────────────────────────────────────────────

class _SukoonBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _SukoonBottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Container(
      height: 68 + bottom,
      padding: EdgeInsets.only(bottom: bottom),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [SukoonColors.deep, SukoonColors.teal, SukoonColors.mid],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, -3)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded,
              label: 'Home', isActive: currentIndex == 0, onTap: () => onTap(0)),
          _NavItem(icon: Icons.notifications_outlined, activeIcon: Icons.notifications_rounded,
              label: 'Notifications', isActive: currentIndex == 1, onTap: () => onTap(1)),
          _NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded,
              label: 'Profile', isActive: currentIndex == 2, onTap: () => onTap(2)),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon, activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _NavItem({required this.icon, required this.activeIcon,
      required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isActive ? 42 : 28,
                height: isActive ? 42 : 28,
                decoration: BoxDecoration(
                  color: isActive ? Colors.white.withValues(alpha: 0.22) : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(isActive ? activeIcon : icon,
                    color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.65),
                    size: isActive ? 22 : 20),
              ),
              const SizedBox(height: 3),
              Text(label,
                  style: TextStyle(
                    fontSize: 10,
                    color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.65),
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
                  )),
            ],
          ),
        ),
      );
}

// ─── Home Content ──────────────────────────────────────────────────────────

class _HomeContent extends StatelessWidget {
  final ValueChanged<int> onNavTap;
  const _HomeContent({required this.onNavTap});

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning ☀️';
    if (h < 17) return 'Good afternoon 🌤️';
    return 'Good evening 🌙';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width > 700;
    final hPad = isWide ? size.width * 0.08 : 20.0;

    return SafeArea(
      child: Column(
        children: [
          // ── App bar ──
          Container(
            padding: EdgeInsets.fromLTRB(hPad, 10, 12, 10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [SukoonColors.deep, SukoonColors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Image.asset(
                  'lib/images/logo_2.png',
                  height: 52,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const _LogoText(),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined,
                      color: Colors.white, size: 24),
                  onPressed: () => onNavTap(1),
                  tooltip: 'Notifications',
                ),
                IconButton(
                  icon: const Icon(Icons.person_outline_rounded,
                      color: Colors.white, size: 24),
                  onPressed: () => onNavTap(2),
                  tooltip: 'Profile',
                ),
              ],
            ),
          ),

          // ── Body ──
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting banner
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 24),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [SukoonColors.teal, SukoonColors.mid],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_greeting,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 14)),
                        const SizedBox(height: 4),
                        const Text('How are you feeling today?',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _MoodChip(emoji: '😊', label: 'Great'),
                            _MoodChip(emoji: '😌', label: 'Calm'),
                            _MoodChip(emoji: '😔', label: 'Low'),
                            _MoodChip(emoji: '😰', label: 'Anxious'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Quote card
                  Padding(
                    padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: SukoonColors.teal.withValues(alpha: 0.2)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 3)),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: SukoonColors.teal.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.format_quote_rounded,
                                color: SukoonColors.teal, size: 22),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              '"You don\'t have to control your thoughts. You just have to stop letting them control you."',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: SukoonColors.muted,
                                  fontStyle: FontStyle.italic,
                                  height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Sections
                  Padding(
                    padding: EdgeInsets.fromLTRB(hPad, 24, hPad, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionHeader(label: 'Assessments:'),
                        const SizedBox(height: 10),
                        _SectionCard(
                          icon: Icons.assignment_outlined,
                          label: 'Explore our Assessments',
                          subtitle: 'MBTI, anxiety, depression screening',
                          color: const Color(0xFF0A3D42),
                          onTap: () => _push(context, const Assessments()),
                        ),
                        const SizedBox(height: 20),
                        _SectionHeader(label: 'Activities:'),
                        const SizedBox(height: 10),
                        _SectionCard(
                          icon: Icons.directions_run_rounded,
                          label: 'Explore our Activities',
                          subtitle: 'Classes, camps, support groups',
                          color: const Color(0xFF0D5C63),
                          onTap: () => _push(context, const Activities()),
                        ),
                        const SizedBox(height: 20),
                        _SectionHeader(label: 'Doctors:'),
                        const SizedBox(height: 10),
                        _SectionCard(
                          icon: Icons.medical_services_outlined,
                          label: 'Explore our Doctors',
                          subtitle: 'Book a therapist session',
                          color: const Color(0xFF247B7B),
                          onTap: () => _push(context, const Therapists()),
                        ),
                        const SizedBox(height: 28),

                        // Quick tips
                        _SectionHeader(label: 'Quick Tips:'),
                        const SizedBox(height: 10),
                        const _TipsRow(),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

class _LogoText extends StatelessWidget {
  const _LogoText();
  @override
  Widget build(BuildContext context) => const Text(
        'سُكُون',
        style: TextStyle(color: Colors.white, fontSize: 22,
            fontWeight: FontWeight.bold),
      );
}

class _MoodChip extends StatelessWidget {
  final String emoji, label;
  const _MoodChip({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
              Text(label,
                  style: const TextStyle(color: Colors.white, fontSize: 12,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      );
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});
  @override
  Widget build(BuildContext context) => Text(label,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
          color: SukoonColors.deep));
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final Color color;
  final VoidCallback onTap;
  const _SectionCard({required this.icon, required this.label,
      required this.subtitle, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          height: 84,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.4),
                  blurRadius: 12, offset: const Offset(0, 4)),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.15),
                  borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(18)),
                ),
                child: Icon(icon, color: Colors.white, size: 36),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: const TextStyle(color: Colors.white,
                            fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Text(subtitle,
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 12)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.white.withValues(alpha: 0.7), size: 16),
              ),
            ],
          ),
        ),
      );
}

class _TipsRow extends StatelessWidget {
  const _TipsRow();

  static const _tips = [
    (icon: Icons.bedtime_outlined, title: 'Sleep Well',
        body: '7–9 hrs improves mood and focus significantly'),
    (icon: Icons.self_improvement_rounded, title: 'Breathe',
        body: '4-7-8 breathing calms anxiety in minutes'),
    (icon: Icons.directions_walk_rounded, title: 'Move Daily',
        body: '20 min walk boosts serotonin naturally'),
  ];

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 130,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: _tips.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, i) {
            final t = _tips[i];
            return Container(
              width: 155,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8, offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(t.icon, color: SukoonColors.teal, size: 26),
                  const SizedBox(height: 8),
                  Text(t.title,
                      style: const TextStyle(fontSize: 13,
                          fontWeight: FontWeight.bold, color: SukoonColors.deep)),
                  const SizedBox(height: 4),
                  Text(t.body,
                      style: const TextStyle(fontSize: 11,
                          color: SukoonColors.muted, height: 1.4),
                      maxLines: 3, overflow: TextOverflow.ellipsis),
                ],
              ),
            );
          },
        ),
      );
}
