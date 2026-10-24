import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Fondo morado → casi negro, igual que en los mockups.
class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -1.1),
          radius: 1.3,
          colors: [Color(0xFF3B1478), AppColors.background],
          stops: [0.0, 0.75],
        ),
      ),
      child: child,
    );
  }
}
