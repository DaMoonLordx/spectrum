import '../entities/app_user.dart';
import '../entities/user_role.dart';

/// Contrato: la capa de dominio no sabe si los datos vienen de un mock,
/// de Firebase o de tu propia API.
abstract class AuthRepository {
  Future<AppUser> login({required String email, required String password});

  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  });

  Future<void> logout();
}
