import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../domain/entities/dashboard_entities.dart';
import 'report_detail_page.dart';

/// Dashboard Operador: cola de reportes por moderar.
/// Al resolver o descartar todos, aparece el estado vacío.
class OperatorDashboardPage extends StatefulWidget {
  const OperatorDashboardPage({super.key});

  @override
  State<OperatorDashboardPage> createState() => _OperatorDashboardPageState();
}

class _OperatorDashboardPageState extends State<OperatorDashboardPage> {
  final _repo = Injector.dashboardRepository;

  List<ModerationReport> _reports = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await _repo.getReports();
    if (!mounted) return;
    setState(() {
      _reports = data;
      _loading = false;
    });
  }

  Future<void> _open(ModerationReport report) async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => ReportDetailPage(report: report)),
    );
    if (!mounted || result == null) return;
    _close(report, result);
  }

  void _close(ModerationReport report, String message) {
    setState(
        () => _reports = _reports.where((r) => r.id != report.id).toList());
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reportes pendientes',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            _loading ? 'Cargando…' : '${_reports.length} por revisar',
            style: const TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _reports.isEmpty
                    ? EmptyState(
                        icon: Icons.verified_outlined,
                        title: 'Todo en orden',
                        message: 'No hay reportes pendientes. Buen trabajo.',
                        actionLabel: 'Buscar nuevos reportes',
                        onAction: _load,
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: _reports.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) {
                          final report = _reports[i];
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  report.title,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Reportado: ${report.reportedUser}',
                                  style: const TextStyle(
                                      color: AppColors.cyan, fontSize: 13),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  report.reason,
                                  style: const TextStyle(
                                      color: AppColors.textMuted),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () =>
                                          _close(report, 'Reporte descartado'),
                                      child: const Text('Descartar'),
                                    ),
                                    const SizedBox(width: 8),
                                    FilledButton(
                                      onPressed: () => _open(report),
                                      child: const Text('Revisar'),
                                    ),
                                  ],
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
