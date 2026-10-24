import '../../../auth/domain/entities/user_role.dart';
import '../../domain/entities/dashboard_entities.dart';
import '../../domain/repositories/dashboard_repository.dart';

class MockDashboardRepository implements DashboardRepository {
  static const _delay = Duration(milliseconds: 700);

  // En memoria: las trivias creadas por el admin viven mientras la app esté abierta.
  final List<TriviaQuestion> _trivias = [
    const TriviaQuestion(
      id: 't1',
      question: '¿Qué instrumento produce sonido al golpear cuerdas con pequeños martillos?',
      options: ['Violín', 'Piano', 'Arpa', 'Guitarra'],
      correctIndex: 1,
      difficulty: 'Fácil',
    ),
    const TriviaQuestion(
      id: 't2',
      question: '¿Cuántas cuerdas tiene una guitarra clásica estándar?',
      options: ['4', '5', '6', '7'],
      correctIndex: 2,
      difficulty: 'Fácil',
    ),
  ];

  @override
  Future<List<MusicMatch>> getMatches() async {
    await Future<void>.delayed(_delay);
    return [
      const MusicMatch(
        id: 'm1',
        name: 'Camila',
        age: 22,
        compatibility: 92,
        bio: 'Fan de los conciertos pequeños y los sintetizadores.',
        sharedTags: ['Luna Eléctrica', 'Indie', 'Electrónica'],
        sharedSongs: [
          SharedSong(title: 'Frecuencia 432', artist: 'Luna Eléctrica'),
          SharedSong(title: 'Marea', artist: 'Marea Alta'),
        ],
      ),
      const MusicMatch(
        id: 'm2',
        name: 'Diego',
        age: 24,
        compatibility: 88,
        bio: 'Productor aficionado, siempre buscando nuevos beats.',
        sharedTags: ['Electrónica', 'Neón Sur'],
        sharedSongs: [
          SharedSong(title: 'Ciudad de neón', artist: 'Neón Sur'),
        ],
      ),
      const MusicMatch(
        id: 'm3',
        name: 'Sofía',
        age: 21,
        compatibility: 85,
        bio: 'Lo-fi para estudiar y para todo lo demás.',
        sharedTags: ['Lo-fi', 'Marea Alta'],
        sharedSongs: [
          SharedSong(title: 'Marea', artist: 'Marea Alta'),
        ],
      ),
      const MusicMatch(
        id: 'm4',
        name: 'Mateo',
        age: 23,
        compatibility: 81,
        bio: 'Pop de los 2000 y trivias musicales.',
        sharedTags: ['Pop', 'Aurora Vox'],
      ),
      const MusicMatch(
        id: 'm5',
        name: 'Lucía',
        age: 25,
        compatibility: 79,
        bio: 'Jazz los domingos, vinilos todo el año.',
        sharedTags: ['Jazz', 'Indie'],
      ),
    ];
  }

  @override
  Future<List<ManagedUser>> getUsers() async {
    await Future<void>.delayed(_delay);
    return [
      const ManagedUser(
        id: 'u1',
        name: 'Valeria Montes',
        email: 'valeria@correo.com',
        role: UserRole.cliente,
      ),
      const ManagedUser(
        id: 'u2',
        name: 'Camila Ríos',
        email: 'camila@correo.com',
        role: UserRole.cliente,
      ),
      const ManagedUser(
        id: 'u3',
        name: 'Omar Operador',
        email: 'operador@spectrum.com',
        role: UserRole.operador,
      ),
      const ManagedUser(
        id: 'u4',
        name: 'Diego Paredes',
        email: 'diego@correo.com',
        role: UserRole.cliente,
        isActive: false,
      ),
      const ManagedUser(
        id: 'u5',
        name: 'Admin Spectrum',
        email: 'admin@spectrum.com',
        role: UserRole.admin,
      ),
    ];
  }

  @override
  Future<List<ModerationReport>> getReports() async {
    await Future<void>.delayed(_delay);
    return [
      const ModerationReport(
        id: 'r1',
        title: 'Mensaje ofensivo en chat',
        reportedUser: 'user_482',
        reason: 'Lenguaje agresivo hacia otra persona.',
      ),
      const ModerationReport(
        id: 'r2',
        title: 'Perfil con foto sospechosa',
        reportedUser: 'user_117',
        reason: 'Posible suplantación de identidad.',
      ),
      const ModerationReport(
        id: 'r3',
        title: 'Spam en conversaciones',
        reportedUser: 'user_903',
        reason: 'Envía enlaces repetidos a varias personas.',
      ),
    ];
  }

  @override
  Future<List<TriviaQuestion>> getTrivias() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List.of(_trivias);
  }

  @override
  Future<void> addTrivia(TriviaQuestion trivia) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _trivias.insert(0, trivia);
  }

  @override
  Future<void> deleteTrivia(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _trivias.removeWhere((t) => t.id == id);
  }
}
