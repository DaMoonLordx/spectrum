import 'package:flutter/material.dart';

import '../di/injector.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_shell.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  /// Todas las rutas usan una transición de desvanecimiento (fade).
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final Widget page = switch (settings.name) {
      AppRoutes.login => const LoginPage(),
      AppRoutes.register => const RegisterPage(),
      // Sin sesión no se puede entrar al dashboard.
      AppRoutes.home => Injector.authController.user == null
          ? const LoginPage()
          : const DashboardShell(),
      _ => const SplashPage(),
    };

    return PageRouteBuilder<void>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }
}
