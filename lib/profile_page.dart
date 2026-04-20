import 'package:flutter/material.dart';
import 'theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ── Teal header ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [SukoonColors.deep, SukoonColors.teal],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('My Profile',
                          style: TextStyle(color: Colors.white, fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.settings_outlined,
                            color: Colors.white70, size: 22),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    children: [
                      Container(
                        width: 90, height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.15),
                          border: Border.all(color: Colors.white, width: 2.5),
                        ),
                        child: const Icon(Icons.person_rounded,
                            color: Colors.white, size: 52),
                      ),
                      Positioned(
                        bottom: 0, right: 0,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 28, height: 28,
                            decoration: const BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: const Icon(Icons.camera_alt_outlined,
                                color: SukoonColors.teal, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Nour Khalife',
                      style: TextStyle(color: Colors.white, fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('nourkhaliife@icloud.com',
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 16),
                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatBadge(label: 'Sessions', value: '12'),
                      Container(width: 1, height: 32,
                          color: Colors.white.withValues(alpha: 0.3)),
                      _StatBadge(label: 'Tests taken', value: '3'),
                      Container(width: 1, height: 32,
                          color: Colors.white.withValues(alpha: 0.3)),
                      _StatBadge(label: 'Activities', value: '7'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Menu groups ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _GroupLabel('Personal Info'),
                  const SizedBox(height: 8),
                  _MenuItem(icon: Icons.email_outlined, label: 'nourkhaliife@icloud.com',
                      trailing: null, onTap: () {}),
                  _MenuItem(icon: Icons.phone_outlined, label: '01027584104',
                      trailing: null, onTap: () {}),
                  _MenuItem(icon: Icons.location_on_outlined, label: 'Cairo, Egypt',
                      trailing: null, onTap: () {}),
                  _MenuItem(icon: Icons.badge_outlined, label: 'ID: 22011948',
                      trailing: null, onTap: () {}),

                  const SizedBox(height: 16),
                  _GroupLabel('Account'),
                  const SizedBox(height: 8),
                  _MenuItem(icon: Icons.payment_outlined, label: 'Payment Methods',
                      onTap: () {}),
                  _MenuItem(icon: Icons.history_rounded, label: 'Booking History',
                      onTap: () {}),
                  _MenuItem(icon: Icons.favorite_outline_rounded, label: 'Saved Therapists',
                      onTap: () {}),
                  _MenuItem(icon: Icons.language_rounded, label: 'Language',
                      trailing: const Text('English',
                          style: TextStyle(color: SukoonColors.muted, fontSize: 13)),
                      onTap: () {}),

                  const SizedBox(height: 16),
                  _GroupLabel('Support'),
                  const SizedBox(height: 8),
                  _MenuItem(icon: Icons.help_outline_rounded, label: 'Help Center',
                      onTap: () {}),
                  _MenuItem(icon: Icons.privacy_tip_outlined, label: 'Privacy Policy',
                      onTap: () {}),
                  _MenuItem(icon: Icons.info_outline_rounded, label: 'About Sukoon',
                      onTap: () {}),

                  const SizedBox(height: 16),
                  _MenuItem(
                    icon: Icons.logout_rounded,
                    label: 'Log out',
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    showArrow: false,
                    onTap: () => _confirmLogout(context),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: SukoonColors.muted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/signin');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red,
                foregroundColor: Colors.white),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label, value;
  const _StatBadge({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(value, style: const TextStyle(color: Colors.white,
              fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      );
}

class _GroupLabel extends StatelessWidget {
  final String text;
  const _GroupLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
          color: SukoonColors.muted, letterSpacing: 0.8));
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor, textColor;
  final bool showArrow;
  final Widget? trailing;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.textColor,
    this.showArrow = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6, offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: (iconColor ?? SukoonColors.teal).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor ?? SukoonColors.teal, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(label,
                    style: TextStyle(fontSize: 14,
                        color: textColor ?? SukoonColors.deep,
                        fontWeight: FontWeight.w500)),
              ),
              if (trailing != null) trailing!,
              if (showArrow && trailing == null)
                const Icon(Icons.chevron_right_rounded,
                    color: SukoonColors.muted, size: 20),
            ],
          ),
        ),
      );
}
