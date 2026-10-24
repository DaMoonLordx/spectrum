import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../domain/entities/dashboard_entities.dart';

/// Lista de trivias publicadas.
/// - canManage = true  (Admin): ve la respuesta correcta y puede eliminar.
/// - canManage = false (Cliente): toca una opción y ve si acertó.
class TriviaListPage extends StatelessWidget {
  const TriviaListPage({super.key, required this.canManage});

  final bool canManage;

  @override
  Widget build(BuildContext context) {
    final controller = Injector.triviaController;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final items = controller.items;
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                canManage ? 'Trivias publicadas' : 'Trivia musical',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                canManage
                    ? '${items.length} preguntas en el banco'
                    : 'Responde y pon a prueba tu oído.',
                style: const TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : items.isEmpty
                        ? EmptyState(
                            icon: Icons.quiz_outlined,
                            title: 'No hay trivias',
                            message: canManage
                                ? 'Crea la primera desde la pestaña Nueva trivia.'
                                : 'Pronto habrá nuevas preguntas para jugar.',
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.only(bottom: 16),
                            itemCount: items.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (_, i) => _TriviaCard(
                              key: ValueKey(items[i].id),
                              trivia: items[i],
                              canManage: canManage,
                            ),
                          ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TriviaCard extends StatefulWidget {
  const _TriviaCard({super.key, required this.trivia, required this.canManage});

  final TriviaQuestion trivia;
  final bool canManage;

  @override
  State<_TriviaCard> createState() => _TriviaCardState();
}

class _TriviaCardState extends State<_TriviaCard> {
  static const _letters = ['A', 'B', 'C', 'D'];
  int? _picked;

  Color? _borderFor(int i) {
    final correct = widget.trivia.correctIndex;
    if (widget.canManage) return i == correct ? AppColors.cyan : null;
    if (_picked == null) return null;
    if (i == correct) return AppColors.cyan;
    if (i == _picked) return AppColors.pink;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final trivia = widget.trivia;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Chip(
                label: Text(trivia.difficulty),
                backgroundColor: AppColors.field,
                side: BorderSide.none,
                visualDensity: VisualDensity.compact,
              ),
              const Spacer(),
              if (widget.canManage)
                IconButton(
                  tooltip: 'Eliminar',
                  icon: const Icon(Icons.delete_outline, color: AppColors.pink),
                  onPressed: () {
                    Injector.triviaController.remove(trivia.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pregunta eliminada')),
                    );
                  },
                ),
            ],
          ),
          Text(
            trivia.question,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < trivia.options.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: widget.canManage || _picked != null
                      ? null
                      : () => setState(() => _picked = i),
                  child: Ink(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.field,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _borderFor(i) ?? Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            _letters[i],
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(trivia.options[i])),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (!widget.canManage && _picked != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _picked == trivia.correctIndex ? '¡Correcto!' : 'Casi. Sigue intentando.',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: _picked == trivia.correctIndex
                      ? AppColors.cyan
                      : AppColors.pink,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
