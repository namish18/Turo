import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'books_page.dart';
import 'videos_page.dart';
import 'chatbot_page.dart';
import 'bottom_nav_bar.dart';

void main() {
  runApp(const TuroLiteApp());
}

class TuroLiteApp extends StatelessWidget {
  const TuroLiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Turo Lite',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.sourceCodeProTextTheme().apply(
          bodyColor: Colors.black,
          displayColor: Colors.black,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

/* ================= Splash Screen ================= */
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _overlayOpacity;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scaleAnim = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _overlayOpacity = Tween<double>(begin: 0, end: 0.9).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.65, 1.0)),
    );

    _ctrl.forward();

    Timer(const Duration(milliseconds: 2600), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomePage(),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (_, a, __, c) =>
              FadeTransition(opacity: a, child: c),
        ),
      );
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: ScaleTransition(
              scale: _scaleAnim,
              child: Image.asset(
                'assets/turo_lite_logo.png',
                width: 180,
                height: 180,
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _overlayOpacity,
            builder: (context, child) {
              return Opacity(
                opacity: _overlayOpacity.value,
                child: Container(
                  color: Colors.white.withAlpha(
                    (_overlayOpacity.value * 0.9 * 255).round(),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _overlayOpacity,
            builder: (context, child) {
              if (_overlayOpacity.value < 0.01) return const SizedBox.shrink();
              return SafeArea(
                child: Column(
                  children: [
                    const Spacer(flex: 3),
                    Image.asset('assets/turo_lite_logo.png',
                        width: 120, height: 120),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        "Your Smart Path to Limitless Learning",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sourceCodePro(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/* ================= Home Page ================= */
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final pages = [const BooksPage(), const VideosPage(), const ChatbotPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(child: pages[selectedIndex]),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 220,
            child: Container(
              color: Colors.white.withAlpha((0.95 * 255).round()),
              child: Column(
                children: [
                  const SizedBox(height: 14),
                  Image.asset('assets/turo_lite_logo.png', width: 90),
                  Text(
                    "Your Smart Path to Limitless Learning",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sourceCodePro(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 12.0, left: 12, right: 12),
        child: SafeArea(
          child: GlassBottomNavBar(
            currentIndex: selectedIndex,
            onItemTap: (i) => setState(() => selectedIndex = i),
          ),
        ),
      ),
    );
  }
}