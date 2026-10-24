import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/single_choice_chips.dart';
import '../../domain/entities/dashboard_entities.dart';

/// Formulario del ADMIN: crea una pregunta para el minijuego de trivia musical.
class CreateTriviaFormPage extends StatefulWidget {
  const CreateTriviaFormPage({super.key});

  @override
  State<CreateTriviaFormPage> createState() => _CreateTriviaFormPageState();
}

class _CreateTriviaFormPageState extends State<CreateTriviaFormPage> {
  static const _letters = ['A', 'B', 'C', 'D'];
  static const _difficulties = ['Fácil', 'Media', 'Difícil'];

  final _formKey = GlobalKey<FormState>();
  final _questionCtrl = TextEditingController();
  final List<TextEditingController> _optionCtrls =
      List.generate(4, (_) => TextEditingController());
  int _correct = 0;
  String _difficulty = 'Media';

  @override
  void dispose() {
    _questionCtrl.dispose();
    for (final c in _optionCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    Injector.triviaController.add(
      TriviaQuestion(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        question: _questionCtrl.text.trim(),
        options: [for (final c in _optionCtrls) c.text.trim()],
        correctIndex: _correct,
        difficulty: _difficulty,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pregunta creada. Mírala en la pestaña Trivias.')),
    );
    _formKey.currentState!.reset();
    _questionCtrl.clear();
    for (final c in _optionCtrls) {
      c.clear();
    }
    setState(() {
      _correct = 0;
      _difficulty = 'Media';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nueva pregunta de trivia',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            const Text('Se añadirá al banco de preguntas del minijuego.',
                style: TextStyle(color: AppColors.textMuted)),
            const SizedBox(height: 20),
            TextFormField(
              controller: _questionCtrl,
              maxLines: 2,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (v) => Validators.minLength(v, 10, field: 'La pregunta'),
              decoration: const InputDecoration(labelText: 'Pregunta'),
            ),
            const SizedBox(height: 16),
            for (var i = 0; i < 4; i++) ...[
              TextFormField(
                controller: _optionCtrls[i],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (v) =>
                    Validators.requiredField(v, field: 'La opción ${_letters[i]}'),
                decoration: InputDecoration(labelText: 'Opción ${_letters[i]}'),
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 4),
            const Text('Respuesta correcta',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            SingleChoiceChips<int>(
              options: const [0, 1, 2, 3],
              selected: _correct,
              labelOf: (i) => _letters[i],
              onChanged: (v) => setState(() => _correct = v),
            ),
            const SizedBox(height: 20),
            const Text('Dificultad',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            SingleChoiceChips<String>(
              options: _difficulties,
              selected: _difficulty,
              onChanged: (v) => setState(() => _difficulty = v),
            ),
            const SizedBox(height: 28),
            GradientButton(label: 'Crear pregunta', onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
