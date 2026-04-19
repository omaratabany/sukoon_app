import 'package:flutter/material.dart';

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
class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SukoonColors.cream,

      // 🔥 CLEAN MODERN APP BAR
      appBar: AppBar(
        backgroundColor: SukoonColors.teal,
        elevation: 0,
        title: const Text(
          "Sukoon",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // 🔥 HERO CARD (clean instead of raw image)
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
                      "Your journey to inner peace begins here ✨",
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

            // 🔥 SECTION 1
            _buildSection("Therapists", const [
              (Color(0xFF0D5C63), Color(0xFF44A1A0), Icons.psychology_outlined),
              (Color(0xFF247B7B), Color(0xFF78CDD7), Icons.groups_outlined),
              (Color(0xFF44A1A0), Color(0xFF0D5C63), Icons.volunteer_activism_outlined),
            ]),

            const SizedBox(height: 25),

            // 🔥 SECTION 2
            _buildSection("Activities", const [
              (Color(0xFF0A3D42), Color(0xFF44A1A0), Icons.spa_outlined),
              (Color(0xFF247B7B), Color(0xFF44A1A0), Icons.self_improvement_outlined),
              (Color(0xFF44A1A0), Color(0xFF78CDD7), Icons.nature_people_outlined),
            ]),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // 🔥 SECTION BUILDER (gradient tiles — add real photos under lib/images/ + pubspec when ready)
  Widget _buildSection(
    String title,
    List<(Color, Color, IconData)> tiles,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: SukoonColors.deep,
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
                child: Icon(icon, color: Colors.white.withOpacity(0.95), size: 48),
              );
            },
          ),
        ),
      ],
    );
  }
}
