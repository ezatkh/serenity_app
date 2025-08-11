import 'package:flutter/material.dart';
import 'package:serenity_app/core/constants/app_colors.dart';
import '../../../core/navigation/page_transitions.dart';
import '../../auth/login/login_ui/login_ui.dart';
import '../widgets/stripedCircle.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;

  late AnimationController _screenController;
  late Animation<double> _screenOpacity;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );

    _screenController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _screenOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _screenController, curve: Curves.easeIn),
    );
  }

  bool _started = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Prevent it from running multiple times
    if (!_started) {
      _started = true;
      _startSequence();
    }
  }

  void _startSequence() async {
    await precacheImage(const AssetImage('assets/icons/loginLogo.png'), context);
    await precacheImage(const AssetImage('assets/images/bottomShape.png'), context);

    await _logoController.forward();
    await _screenController.forward();
    await Future.delayed(const Duration(milliseconds: 1000));
    await _screenController.reverse();
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      FadePageRoute(page: const LoginUI()),
    );
  }


  @override
  void dispose() {
    _logoController.dispose();
    _screenController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final iconSize = size.width * 0.05;
    final spacing = size.height * 0.01;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
        FadeTransition(
        opacity: _screenOpacity,
        child: Stack(
        children: [
        // Top-right image
          Positioned(
            right: -size.width * 0.11, // offset slightly off screen to the right
            child: Image.asset(
              'assets/images/topRight.png',
              width: size.width * 0.8,  // 65% of screen width
              height: size.width * 0.8, // same as width for square aspect
              fit: BoxFit.contain,
            ),
          ),
          // Top-right abstract shape
          Positioned(
            top: size.height * 0.18,
            left: size.width * 0.12,
            child: SizedBox(
              width: size.width * 0.12,
              height: size.width * 0.12,
              child: StripedCircle(),
            ),
          ),
          // Bottom-left stripes using rounded rectangles
          Positioned(
            bottom: size.height * 0.04,
            left: -30,
            child: Transform.rotate(
              angle: -0.5,
              child: Container(
                width: size.width * 0.35,
                height: size.height * 0.05,
                decoration: BoxDecoration(
                  color:AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: size.height * 0.02,
            left: -20,
            child: Transform.rotate(
              angle: -0.5,
              child: Container(
                width: size.width * 0.35,
                height: size.height * 0.05,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.secondaryColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          // Triangle icons (right)
          Positioned(
            right: size.width * 0.07,
            bottom: size.height * 0.1,
            child: Column(
              children:  [
                Icon(Icons.change_history, size: iconSize, color: AppColors.secondaryColor),
                SizedBox(height: spacing),
                Icon(Icons.change_history, size: iconSize, color:  AppColors.primaryLighterColor),
                SizedBox(height: spacing),
                Icon(Icons.change_history, size: iconSize, color: AppColors.primaryColor),
              ],
            ),
          ),
        ],
        ),
        ),
          // Centered logo and text
          Center(
            child: FadeTransition(
              opacity: _logoOpacity,
              child: ScaleTransition(
                scale: _logoScale,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/Icon.png',
                      width: size.width * 0.6,
                      height: size.width * 0.6,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
