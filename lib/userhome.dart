import 'package:flutter/material.dart';
import 'therapists.dart';

// COLORS
class SukoonColors {
  static const deep = Color(0xFF0A3D42);
  static const teal = Color(0xFF0D5C63);
  static const mid = Color(0xFF44A1A0);
  static const light = Color(0xFF78CDD7);
  static const cream = Color(0xFFFAFAF6);
  static const muted = Color(0xFF607B7D);
}

// HOME
class UserHome extends StatelessWidget {
  const UserHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SukoonColors.cream,

      appBar: AppBar(
        backgroundColor: SukoonColors.teal,
        elevation: 0,
        title: const Text(
          'Sukoon',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0D5C63), Color(0xFF44A1A0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(20),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Your journey to inner peace begins here ✨',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            _buildSection(
              context,
              'Therapists',
              const [
                (Color(0xFF0D5C63), Color(0xFF44A1A0), Icons.psychology_outlined),
                (Color(0xFF247B7B), Color(0xFF78CDD7), Icons.groups_outlined),
                (
                  Color(0xFF44A1A0),
                  Color(0xFF0D5C63),
                  Icons.volunteer_activism_outlined,
                ),
              ],
              onTitleTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const Therapists(),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            _buildSection(
              context,
              'Activities',
              const [
                (Color(0xFF0A3D42), Color(0xFF44A1A0), Icons.spa_outlined),
                (
                  Color(0xFF247B7B),
                  Color(0xFF44A1A0),
                  Icons.self_improvement_outlined,
                ),
                (
                  Color(0xFF44A1A0),
                  Color(0xFF78CDD7),
                  Icons.nature_people_outlined,
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<(Color, Color, IconData)> tiles, {
    VoidCallback? onTitleTap,
  }) {
    final titleStyle = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: SukoonColors.deep,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: onTitleTap == null
              ? Text(title, style: titleStyle)
              : Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTitleTap,
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(title, style: titleStyle),
                    ),
                  ),
                ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 170,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: tiles.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final (c1, c2, icon) = tiles[i];
              return Container(
                width: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    colors: [c1, c2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white.withOpacity(0.95),
                  size: 48,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
