import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '/src/features/_user_data/controllers/user_controller.dart';
import 'package:provider/provider.dart';
import '../../../router/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late UserController _getUsercontroller;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getUsercontroller = Provider.of<UserController>(context, listen: false);
      await _getUsercontroller.fetchUserData();
      navigate();
    });

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward();
  }

  Future<void> navigate() async {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        if (_getUsercontroller.user != null) {
          if (_getUsercontroller.user!.username.isEmpty) {
            context.pushReplacementNamed(AppRoute.userNamePage);
            return;
          }
          if (_getUsercontroller.user!.name.isEmpty) {
            context.pushReplacementNamed(AppRoute.petFormPage);
            return;
          }
          context.pushReplacementNamed(AppRoute.navigationBar);
        } else {
          context.pushReplacementNamed(AppRoute.welcomeScreen);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) {
                return ClipRect(
                  clipper: RevealClipper(
                    _controller.value,
                  ),
                  child: Image.asset(
                    'assets/images/splashdog.png',
                    width: 160,
                    height: 160,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Chumme',
              style: GoogleFonts.fredoka(
                textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Clipper for revealing the image in steps
class RevealClipper extends CustomClipper<Rect> {
  final double revealPercent;

  RevealClipper(this.revealPercent);

  @override
  Rect getClip(Size size) {
    // Reveal based on the percentage of the image shown
    return Rect.fromLTRB(
      0.0,
      size.height * (1 - revealPercent),
      size.width,
      size.height,
    );
  }

  @override
  bool shouldReclip(RevealClipper oldClipper) {
    return oldClipper.revealPercent != revealPercent;
  }
}
