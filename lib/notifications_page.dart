import 'package:flutter/material.dart';
import 'theme.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<_Notif> _today = [
    _Notif(icon: Icons.calendar_today_rounded, iconColor: Color(0xFF4CAF50),
        title: 'Reminder!', body: 'Doctor appointment today at 6:30pm, need to pick up files on the way.',
        time: '25 min', isUnread: true),
    _Notif(icon: Icons.check_circle_rounded, iconColor: SukoonColors.teal,
        title: 'Payment Successful', body: 'Your payment of 600 EGP has been successfully processed.',
        time: '1 hr', isUnread: true),
  ];

  final List<_Notif> _yesterday = [
    _Notif(icon: Icons.star_rounded, iconColor: Colors.amber,
        title: 'Rate your experience', body: 'How was your session with Dr. Sarah? Tap to leave a review.',
        time: '1 day', isUnread: false),
    _Notif(icon: Icons.local_activity_rounded, iconColor: SukoonColors.mid,
        title: 'New Class Available', body: 'Aerial Yoga class is now available for booking. Limited spots!',
        time: '1 day', isUnread: false),
    _Notif(icon: Icons.medical_services_outlined, iconColor: SukoonColors.deep,
        title: 'Session Confirmed', body: 'Your session with Dr. Ann Grace on Tuesday has been confirmed.',
        time: '2 days', isUnread: false),
  ];

  int get _unreadCount => _today.where((n) => n.isUnread).length;

  void _markAllRead() => setState(() {
        for (final n in _today) {
          n.isUnread = false;
        }
      });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [SukoonColors.deep, SukoonColors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.notifications_rounded, color: Colors.white, size: 26),
                const SizedBox(width: 10),
                const Text('Notifications',
                    style: TextStyle(color: Colors.white, fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                if (_unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(12)),
                    child: Text('$_unreadCount',
                        style: const TextStyle(color: Colors.white,
                            fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: _markAllRead,
                  child: const Text('Mark all read',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                _SectionLabel('TODAY'),
                const SizedBox(height: 8),
                ..._today.map((n) => _NotifCard(
                      notif: n,
                      onDismiss: () => setState(() => _today.remove(n)),
                    )),
                const SizedBox(height: 16),
                _SectionLabel('YESTERDAY'),
                const SizedBox(height: 8),
                ..._yesterday.map((n) => _NotifCard(
                      notif: n,
                      onDismiss: () => setState(() => _yesterday.remove(n)),
                    )),
                const SizedBox(height: 16),
                // Empty state
                if (_today.isEmpty && _yesterday.isEmpty)
                  const _EmptyNotifs(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Notif {
  final IconData icon;
  final Color iconColor;
  final String title, body, time;
  bool isUnread;
  _Notif({required this.icon, required this.iconColor, required this.title,
      required this.body, required this.time, this.isUnread = false});
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
          color: SukoonColors.muted, letterSpacing: 1));
}

class _NotifCard extends StatelessWidget {
  final _Notif notif;
  final VoidCallback onDismiss;
  const _NotifCard({required this.notif, required this.onDismiss});

  @override
  Widget build(BuildContext context) => Dismissible(
        key: ValueKey(notif.title + notif.time),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              color: Colors.red.shade400,
              borderRadius: BorderRadius.circular(14)),
          child: const Icon(Icons.delete_outline_rounded,
              color: Colors.white, size: 24),
        ),
        onDismissed: (_) => onDismiss(),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: notif.isUnread
                ? SukoonColors.teal.withValues(alpha: 0.05)
                : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: notif.isUnread
                  ? SukoonColors.teal.withValues(alpha: 0.25)
                  : Colors.grey.shade200,
            ),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6, offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                    color: notif.iconColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle),
                child: Icon(notif.icon, color: notif.iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                        child: Text(notif.title,
                            style: TextStyle(fontSize: 14,
                                fontWeight: notif.isUnread
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                color: SukoonColors.deep)),
                      ),
                      Text(notif.time,
                          style: const TextStyle(fontSize: 11,
                              color: SukoonColors.muted)),
                    ]),
                    const SizedBox(height: 4),
                    Text(notif.body,
                        style: const TextStyle(fontSize: 13,
                            color: SukoonColors.muted, height: 1.4)),
                  ],
                ),
              ),
              if (notif.isUnread)
                Container(
                  width: 8, height: 8,
                  margin: const EdgeInsets.only(left: 6, top: 4),
                  decoration: const BoxDecoration(
                      color: SukoonColors.teal, shape: BoxShape.circle),
                ),
            ],
          ),
        ),
      );
}

class _EmptyNotifs extends StatelessWidget {
  const _EmptyNotifs();
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            Icon(Icons.notifications_off_outlined,
                size: 56, color: SukoonColors.muted.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            const Text("You're all caught up!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                    color: SukoonColors.muted)),
            const SizedBox(height: 6),
            const Text('No new notifications',
                style: TextStyle(fontSize: 13, color: SukoonColors.muted)),
          ],
        ),
      );
}
