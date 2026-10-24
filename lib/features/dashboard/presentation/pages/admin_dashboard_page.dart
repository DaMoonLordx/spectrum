import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../domain/entities/dashboard_entities.dart';

/// Dashboard Admin: resumen + lista de usuarios (activar/desactivar/eliminar).
class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final _repo = Injector.dashboardRepository;

  List<ManagedUser> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await _repo.getUsers();
    if (!mounted) return;
    setState(() {
      _users = data;
      _loading = false;
    });
  }

  void _toggle(String id) {
    setState(() {
      _users = [
        for (final u in _users)
          if (u.id == id) u.copyWith(isActive: !u.isActive) else u,
      ];
    });
  }

  void _delete(ManagedUser user) {
    setState(() => _users = _users.where((u) => u.id != user.id).toList());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${user.name} fue eliminado')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final active = _users.where((u) => u.isActive).length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Panel de administración',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child:
                      _StatTile(label: 'Usuarios', value: '${_users.length}')),
              const SizedBox(width: 12),
              Expanded(child: _StatTile(label: 'Activos', value: '$active')),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Usuarios',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _users.isEmpty
                    ? EmptyState(
                        icon: Icons.group_off_outlined,
                        title: 'No hay usuarios',
                        message:
                            'Aún no hay cuentas registradas en la plataforma.',
                        actionLabel: 'Recargar usuarios',
                        onAction: _load,
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: _users.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) {
                          final user = _users[i];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              children: [
                                UserAvatar(name: user.name, size: 44),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        '${user.role.label} · ${user.email}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: AppColors.textMuted,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: user.isActive,
                                  onChanged: (_) => _toggle(user.id),
                                ),
                                IconButton(
                                  tooltip: 'Eliminar',
                                  icon: const Icon(Icons.delete_outline,
                                      color: AppColors.pink),
                                  onPressed: () => _delete(user),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.cyan,
            ),
          ),
        ],
      ),
    );
  }
}
