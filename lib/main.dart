import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'splash_screen.dart';
import 'Signin.dart';
import 'Signup.dart';
import 'userhome.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait + landscape but avoid unnecessary rotations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Transparent status/nav bar for edge-to-edge feel
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(const SukoonApp());
}

class SukoonApp extends StatelessWidget {
  const SukoonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sukoon',
      debugShowCheckedModeBanner: false,
      theme: sukoonTheme(),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/signin': (_) => const Signin(),
        '/signup': (_) => const Signup(),
        '/home': (_) => const UserHome(),
      },
    );
  }
}
