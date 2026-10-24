import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/gradient_button.dart';

/// Formulario del CLIENTE: edita su perfil musical (descripción, géneros, artistas).
class EditMusicProfileFormPage extends StatefulWidget {
  const EditMusicProfileFormPage({super.key});

  @override
  State<EditMusicProfileFormPage> createState() =>
      _EditMusicProfileFormPageState();
}

class _EditMusicProfileFormPageState extends State<EditMusicProfileFormPage> {
  static const _allGenres = ['Indie', 'Pop', 'Electrónica', 'Lo-fi', 'Jazz', 'Rock'];

  final _formKey = GlobalKey<FormState>();
  final _bioCtrl =
      TextEditingController(text: 'Entre playlists y conciertos indie.');
  final _artistsCtrl = TextEditingController(text: 'Luna Eléctrica, Neón Sur');
  final Set<String> _genres = {'Indie', 'Electrónica', 'Lo-fi'};
  bool _genresError = false;

  @override
  void dispose() {
    _bioCtrl.dispose();
    _artistsCtrl.dispose();
    super.dispose();
  }

  void _toggleGenre(String genre, bool selected) {
    if (selected && _genres.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Puedes elegir hasta 5 géneros')),
      );
      return;
    }
    setState(() {
      selected ? _genres.add(genre) : _genres.remove(genre);
      _genresError = _genres.isEmpty;
    });
  }

  void _save() {
    FocusScope.of(context).unfocus();
    final formOk = _formKey.currentState!.validate();
    setState(() => _genresError = _genres.isEmpty);
    if (!formOk || _genres.isEmpty) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil musical actualizado')),
    );
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
            const Text('Mi perfil musical',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            const Text('Esto es lo que verán las personas que coincidan contigo.',
                style: TextStyle(color: AppColors.textMuted)),
            const SizedBox(height: 20),
            TextFormField(
              controller: _bioCtrl,
              maxLength: 120,
              maxLines: 2,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (v) =>
                  Validators.minLength(v, 10, field: 'La descripción'),
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            const SizedBox(height: 12),
            const Text('Géneros (elige hasta 5)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final genre in _allGenres)
                  FilterChip(
                    label: Text(genre),
                    selected: _genres.contains(genre),
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.field,
                    checkmarkColor: Colors.white,
                    side: BorderSide.none,
                    labelStyle: const TextStyle(color: Colors.white),
                    onSelected: (v) => _toggleGenre(genre, v),
                  ),
              ],
            ),
            if (_genresError)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('Elige al menos un género',
                    style: TextStyle(color: AppColors.pink)),
              ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _artistsCtrl,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (v) =>
                  Validators.requiredField(v, field: 'Tus artistas favoritos'),
              decoration: const InputDecoration(
                labelText: 'Artistas favoritos',
                helperText: 'Sepáralos con comas',
              ),
            ),
            const SizedBox(height: 24),
            GradientButton(label: 'Guardar cambios', onPressed: _save),
          ],
        ),
      ),
    );
  }
}
