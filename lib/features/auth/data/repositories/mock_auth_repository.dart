import '../../domain/entities/app_user.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/failures/auth_exception.dart';
import '../../domain/repositories/auth_repository.dart';

class _Account {
  const _Account(this.user, this.password);
  final AppUser user;
  final String password;
}

/// Repositorio falso en memoria. Simula latencia de red.
class MockAuthRepository implements AuthRepository {
  final List<_Account> _accounts = [
    const _Account(
      AppUser(
        id: '1',
        name: 'Admin Spectrum',
        email: 'admin@spectrum.com',
        role: UserRole.admin,
      ),
      'Admin1234',
    ),
    const _Account(
      AppUser(
        id: '2',
        name: 'Valeria Montes',
        email: 'cliente@spectrum.com',
        role: UserRole.cliente,
      ),
      'Cliente1234',
    ),
    const _Account(
      AppUser(
        id: '3',
        name: 'Omar Operador',
        email: 'operador@spectrum.com',
        role: UserRole.operador,
      ),
      'Operador1234',
    ),
  ];

  @override
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final normalized = email.trim().toLowerCase();
    for (final account in _accounts) {
      if (account.user.email == normalized && account.password == password) {
        return account.user;
      }
    }
    throw const AuthException('Correo o contraseña incorrectos');
  }

  @override
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final normalized = email.trim().toLowerCase();
    final exists = _accounts.any((a) => a.user.email == normalized);
    if (exists) {
      throw const AuthException('Ya existe una cuenta con ese correo');
    }
    final user = AppUser(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      email: normalized,
      role: role,
    );
    _accounts.add(_Account(user, password));
    return user;
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
}
