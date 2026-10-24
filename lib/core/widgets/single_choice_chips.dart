import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Selector de una sola opción con chips (se reutiliza en varios formularios).
class SingleChoiceChips<T> extends StatelessWidget {
  const SingleChoiceChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.labelOf,
  });

  final List<T> options;
  final T selected;
  final ValueChanged<T> onChanged;
  final String Function(T)? labelOf;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final option in options)
          ChoiceChip(
            label: Text(labelOf?.call(option) ?? '$option'),
            selected: option == selected,
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.field,
            side: BorderSide.none,
            showCheckmark: false,
            labelStyle: const TextStyle(color: Colors.white),
            onSelected: (_) => onChanged(option),
          ),
      ],
    );
  }
}
