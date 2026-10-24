import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/spectrum_logo.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..forward();

  late final Animation<double> _fade =
      CurvedAnimation(parent: _controller, curve: Curves.easeOut);

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Tras la animación, pasamos al login con transición fade (ver AppRouter).
    _timer = Timer(const Duration(milliseconds: 2800), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.85, end: 1).animate(_fade),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SpectrumLogo(),
                  const SizedBox(height: 28),
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        AppColors.gradient.createShader(bounds),
                    child: const Text(
                      'Spectrum',
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Encuentra tu frecuencia',
                    style: TextStyle(fontSize: 18, color: AppColors.cyan),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Conecta con personas que vibran\nen tu misma onda musical.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textMuted, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
