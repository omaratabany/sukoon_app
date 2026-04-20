// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'theme.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width > 700;
    final hPad = isWide ? size.width * 0.28 : 28.0;

    return Scaffold(
      backgroundColor: SukoonColors.teal,
      body: Stack(
        children: [
          // Gradient header
          Container(
            height: size.height * 0.48,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [SukoonColors.deep, SukoonColors.teal],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Mountain silhouette
          SizedBox(
            height: size.height * 0.48,
            width: size.width,
            child: CustomPaint(painter: MountainPainter()),
          ),
          // White card
          Positioned(
            top: size.height * 0.36,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
              ),
            ),
          ),
          // Logo + title
          Positioned(
            top: size.height * 0.08,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Image.asset(
                  'lib/images/logo_2.png',
                  height: 70,
                  errorBuilder: (_, __, ___) => const _LogoFallback(),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          // Form
          Positioned.fill(
            top: size.height * 0.40,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(hPad, 28, hPad, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _InputField(
                    controller: _emailController,
                    hint: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 14),
                  _InputField(
                    controller: _passwordController,
                    hint: 'Password',
                    obscureText: _obscure,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) =>
                        Navigator.pushReplacementNamed(context, '/home'),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: SukoonColors.muted,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                          foregroundColor: SukoonColors.muted),
                      child: const Text('Forget Password?',
                          style: TextStyle(fontSize: 13)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/home'),
                      child: const Text('Sign In',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const _OrDivider(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SocialBtn(
                          color: const Color(0xFFEA4335),
                          child: const Text('G',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFEA4335)))),
                      const SizedBox(width: 16),
                      _SocialBtn(
                          color: const Color(0xFF1877F2),
                          child: const Icon(Icons.facebook_rounded,
                              color: Color(0xFF1877F2), size: 26)),
                      const SizedBox(width: 16),
                      _SocialBtn(
                          color: Colors.black,
                          child: const Icon(Icons.apple,
                              color: Colors.black, size: 26)),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't Have An Account? ",
                          style: TextStyle(
                              color: SukoonColors.muted, fontSize: 14)),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushReplacementNamed(context, '/signup'),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                              color: SukoonColors.teal,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoFallback extends StatelessWidget {
  const _LogoFallback();

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const Text(
            'سُكُون',
            style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'serif'),
          ),
          const Text(
            'SUKOON',
            style: TextStyle(
                color: Colors.white70, fontSize: 13, letterSpacing: 4),
          ),
        ],
      );
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffixIcon;

  const _InputField({
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(hintText: hint, suffixIcon: suffixIcon),
      );
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) => const Row(
        children: [
          Expanded(child: Divider()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Text('Or', style: TextStyle(color: SukoonColors.muted)),
          ),
          Expanded(child: Divider()),
        ],
      );
}

class _SocialBtn extends StatelessWidget {
  final Color color;
  final Widget child;
  const _SocialBtn({required this.color, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: color.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: child),
      );
}
