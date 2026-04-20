import 'package:flutter/material.dart';

class SukoonColors {
  SukoonColors._();
  static const deep = Color(0xFF0A3D42);
  static const teal = Color(0xFF0D5C63);
  static const mid = Color(0xFF44A1A0);
  static const light = Color(0xFF78CDD7);
  static const cream = Color(0xFFF6F8F8);
  static const muted = Color(0xFF607B7D);
  static const inputFill = Color(0xFFF2F4F4);
}

class MountainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.65)
      ..lineTo(size.width * 0.18, size.height * 0.38)
      ..lineTo(size.width * 0.36, size.height * 0.58)
      ..lineTo(size.width * 0.54, size.height * 0.28)
      ..lineTo(size.width * 0.72, size.height * 0.52)
      ..lineTo(size.width, size.height * 0.32)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);

    final paint2 = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..style = PaintingStyle.fill;

    final path2 = Path()
      ..moveTo(0, size.height * 0.78)
      ..lineTo(size.width * 0.22, size.height * 0.55)
      ..lineTo(size.width * 0.42, size.height * 0.7)
      ..lineTo(size.width * 0.6, size.height * 0.45)
      ..lineTo(size.width * 0.78, size.height * 0.63)
      ..lineTo(size.width, size.height * 0.5)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(MountainPainter _) => false;
}

ThemeData sukoonTheme() => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: SukoonColors.teal,
        primary: SukoonColors.teal,
      ),
      scaffoldBackgroundColor: SukoonColors.cream,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: SukoonColors.teal,
        titleTextStyle: TextStyle(
          color: SukoonColors.teal,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: SukoonColors.teal.withValues(alpha: 0.12),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
                color: SukoonColors.teal, fontWeight: FontWeight.w600);
          }
          return const TextStyle(color: SukoonColors.muted);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: SukoonColors.teal);
          }
          return const IconThemeData(color: SukoonColors.muted);
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SukoonColors.teal,
          foregroundColor: Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 15),
          textStyle:
              const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SukoonColors.inputFill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: SukoonColors.teal, width: 1.5),
        ),
        hintStyle: const TextStyle(color: SukoonColors.muted),
      ),
    );
