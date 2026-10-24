import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Logo de ecualizador (barras de onda) del splash.
class SpectrumLogo extends StatelessWidget {
  const SpectrumLogo({super.key, this.height = 90});

  final double height;

  static const List<double> _bars = [
    0.30, 0.60, 0.90, 0.50, 1.00, 0.70, 0.40, 0.85, 1.00,
    0.60, 0.45, 0.80, 0.95, 0.55, 0.35, 0.70, 0.40,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (final factor in _bars)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Container(
                width: 6,
                height: height * factor,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.cyan, AppColors.pink],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
