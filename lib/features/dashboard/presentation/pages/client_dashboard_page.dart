import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../domain/entities/dashboard_entities.dart';
import 'match_detail_page.dart';

/// Dashboard Cliente: personas con gustos musicales similares.
/// Lista dinámica: se puede filtrar, descartar ("Pasar") o dar "Me gusta".
/// Cuando no quedan elementos se muestra el estado vacío.
class ClientDashboardPage extends StatefulWidget {
  const ClientDashboardPage({super.key});

  @override
  State<ClientDashboardPage> createState() => _ClientDashboardPageState();
}

class _ClientDashboardPageState extends State<ClientDashboardPage> {
  final _repo = Injector.dashboardRepository;
  final _searchCtrl = TextEditingController();

  List<MusicMatch> _matches = [];
  bool _loading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await _repo.getMatches();
    if (!mounted) return;
    _searchCtrl.clear();
    setState(() {
      _matches = data;
      _query = '';
      _loading = false;
    });
  }

  List<MusicMatch> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _matches;
    return _matches
        .where((m) =>
            m.name.toLowerCase().contains(q) ||
            m.sharedTags.any((t) => t.toLowerCase().contains(q)))
        .toList();
  }

  void _remove(MusicMatch match, {required bool liked}) {
    setState(() => _matches = _matches.where((m) => m.id != match.id).toList());
    if (liked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡Te conectaste con ${match.name}!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personas en tu frecuencia',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _searchCtrl,
            onChanged: (v) => setState(() => _query = v),
            decoration: const InputDecoration(
              hintText: 'Buscar por nombre, artista o género',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : items.isEmpty
                    ? EmptyState(
                        icon: Icons.music_off_outlined,
                        title: 'Sin personas por ahora',
                        message: _matches.isEmpty
                            ? 'Ya revisaste a todos. Vuelve más tarde o recarga la lista.'
                            : 'Ninguna coincidencia para "$_query".',
                        actionLabel: 'Recargar lista',
                        onAction: _load,
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) => _MatchCard(
                          match: items[i],
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => MatchDetailPage(match: items[i]),
                            ),
                          ),
                          onPass: () => _remove(items[i], liked: false),
                          onLike: () => _remove(items[i], liked: true),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  const _MatchCard({
    required this.match,
    required this.onPass,
    required this.onLike,
    required this.onTap,
  });

  final MusicMatch match;
  final VoidCallback onPass;
  final VoidCallback onLike;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserAvatar(name: match.name),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${match.name}, ${match.age}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      match.bio,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${match.compatibility}%',
                style: const TextStyle(
                  color: AppColors.cyan,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: onPass, child: const Text('Pasar')),
              const SizedBox(width: 8),
              FilledButton(onPressed: onLike, child: const Text('Me gusta')),
            ],
          ),
        ],
      ),
    ),
    );
  }
}
