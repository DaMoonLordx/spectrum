import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../auth/domain/entities/user_role.dart';
import 'admin_dashboard_page.dart';
import 'client_dashboard_page.dart';
import 'create_trivia_form_page.dart';
import 'edit_music_profile_form_page.dart';
import 'operator_dashboard_page.dart';
import 'trivia_list_page.dart';

class _TabItem {
  const _TabItem(this.label, this.icon, this.page);

  final String label;
  final IconData icon;
  final Widget page;
}

/// Cada rol ve SOLO sus pantallas. Si agregas un rol o una pestaña,
/// es el único lugar que hay que tocar.
List<_TabItem> _tabsFor(UserRole role) => switch (role) {
      UserRole.admin => const [
          _TabItem('Usuarios', Icons.group_outlined, AdminDashboardPage()),
          _TabItem('Trivias', Icons.list_alt_outlined, TriviaListPage(canManage: true)),
          _TabItem('Nueva trivia', Icons.quiz_outlined, CreateTriviaFormPage()),
        ],
      UserRole.cliente => const [
          _TabItem('Inicio', Icons.graphic_eq, ClientDashboardPage()),
          _TabItem('Juegos', Icons.sports_esports_outlined, TriviaListPage(canManage: false)),
          _TabItem('Mi perfil', Icons.person_outline, EditMusicProfileFormPage()),
        ],
      UserRole.operador => const [
          _TabItem('Reportes', Icons.shield_outlined, OperatorDashboardPage()),
        ],
    };

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  final _auth = Injector.authController;
  int _index = 0;

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('¿Cerrar sesión?'),
        content: const Text(
            'Podrás volver a entrar con tu correo y contraseña cuando quieras.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await _auth.signOut();
    if (!mounted) return;
    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.user;
    final role = user?.role ?? UserRole.cliente;
    final tabs = _tabsFor(role);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hola, ${user?.name ?? 'invitado'}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: _confirmLogout,
          ),
        ],
      ),
      body: GradientBackground(
        child: IndexedStack(
          index: _index,
          children: [for (final tab in tabs) tab.page],
        ),
      ),
      // Con una sola pestaña no hace falta barra inferior.
      bottomNavigationBar: tabs.length < 2
          ? null
          : NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              destinations: [
                for (final tab in tabs)
                  NavigationDestination(icon: Icon(tab.icon), label: tab.label),
              ],
            ),
    );
  }
}
