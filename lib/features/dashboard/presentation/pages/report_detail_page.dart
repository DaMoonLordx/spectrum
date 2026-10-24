import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/single_choice_chips.dart';
import '../../domain/entities/dashboard_entities.dart';

/// Formulario del OPERADOR: decide qué hacer con un reporte y deja notas.
/// Al guardar, devuelve un mensaje con Navigator.pop para quitarlo de la lista.
class ReportDetailPage extends StatefulWidget {
  const ReportDetailPage({super.key, required this.report});

  final ModerationReport report;

  @override
  State<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  static const _actions = [
    'Advertir al usuario',
    'Suspender 7 días',
    'Sin infracción',
  ];

  final _formKey = GlobalKey<FormState>();
  final _notesCtrl = TextEditingController();
  String _action = _actions.first;

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop('Reporte resuelto: $_action');
  }

  @override
  Widget build(BuildContext context) {
    final report = widget.report;
    return Scaffold(
      appBar: AppBar(title: const Text('Revisar reporte')),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 64, 20, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(report.title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text('Reportado: ${report.reportedUser}',
                            style: const TextStyle(color: AppColors.cyan)),
                        const SizedBox(height: 8),
                        Text(report.reason,
                            style: const TextStyle(color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Acción a tomar',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  SingleChoiceChips<String>(
                    options: _actions,
                    selected: _action,
                    onChanged: (v) => setState(() => _action = v),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _notesCtrl,
                    maxLines: 4,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) =>
                        Validators.minLength(v, 10, field: 'Las notas'),
                    decoration: const InputDecoration(
                      labelText: 'Notas de moderación',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 28),
                  GradientButton(
                      label: 'Registrar resolución', onPressed: _submit),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
