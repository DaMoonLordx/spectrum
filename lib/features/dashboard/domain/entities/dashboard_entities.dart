import '../../../auth/domain/entities/user_role.dart';

/// Persona sugerida por afinidad musical (dashboard Cliente).
class MusicMatch {
  const MusicMatch({
    required this.id,
    required this.name,
    required this.age,
    required this.compatibility,
    required this.bio,
    required this.sharedTags,
    this.sharedSongs = const [],
  });

  final String id;
  final String name;
  final int age;
  final int compatibility; // 0 - 100
  final String bio;
  final List<String> sharedTags;
  final List<SharedSong> sharedSongs;
}

/// Usuario administrable (dashboard Admin).
class ManagedUser {
  const ManagedUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String email;
  final UserRole role;
  final bool isActive;

  ManagedUser copyWith({bool? isActive}) => ManagedUser(
        id: id,
        name: name,
        email: email,
        role: role,
        isActive: isActive ?? this.isActive,
      );
}

/// Reporte pendiente de moderación (dashboard Operador).
class ModerationReport {
  const ModerationReport({
    required this.id,
    required this.title,
    required this.reportedUser,
    required this.reason,
  });

  final String id;
  final String title;
  final String reportedUser;
  final String reason;
}

/// Canción que dos personas tienen en común (lista de detalle).
class SharedSong {
  const SharedSong({required this.title, required this.artist});

  final String title;
  final String artist;
}

/// Pregunta de trivia creada por el admin y jugada por los clientes.
class TriviaQuestion {
  const TriviaQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.difficulty,
  });

  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String difficulty;
}
