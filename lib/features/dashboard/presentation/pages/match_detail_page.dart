import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../domain/entities/dashboard_entities.dart';

/// Detalle de una persona: lista secundaria con canciones en común.
/// Si no hay canciones se muestra el estado vacío.
class MatchDetailPage extends StatelessWidget {
  const MatchDetailPage({super.key, required this.match});

  final MusicMatch match;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(match.name)),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 64, 20, 16),
                  children: [
                    Row(
                      children: [
                        UserAvatar(name: match.name, size: 72),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${match.name}, ${match.age}',
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w800),
                              ),
                              Text(
                                '${match.compatibility}% compatibles',
                                style: const TextStyle(
                                    color: AppColors.cyan,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(match.bio,
                        style: const TextStyle(color: AppColors.textMuted)),
                    const SizedBox(height: 20),
                    const Text('Gustos en común',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final tag in match.sharedTags)
                          Chip(
                            label: Text(tag),
                            backgroundColor: AppColors.field,
                            side: BorderSide.none,
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('Canciones en común',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    if (match.sharedSongs.isEmpty)
                      const EmptyState(
                        icon: Icons.library_music_outlined,
                        title: 'Aún no comparten canciones',
                        message:
                            'Escríbele y descubran qué suena en sus playlists.',
                      )
                    else
                      for (final song in match.sharedSongs)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.gradient,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.music_note,
                                      color: Colors.white),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(song.title,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700)),
                                      Text(song.artist,
                                          style: const TextStyle(
                                              color: AppColors.textMuted)),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.play_arrow,
                                    color: AppColors.cyan),
                              ],
                            ),
                          ),
                        ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: GradientButton(
                  label: 'Enviar mensaje',
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Chat con ${match.name} (próximamente)')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
