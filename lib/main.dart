import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'Signin.dart';
import 'Signup.dart';
import 'userhome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/signin': (context) => const Signin(),
        '/signup': (context) => const Signup(),
        '/home': (context) => const UserHome(),
      },
    );
  }
}
