import '../entities/app_user.dart';
import '../entities/user_role.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);
  final AuthRepository _repository;

  Future<AppUser> call(String email, String password) =>
      _repository.login(email: email, password: password);
}

class RegisterUseCase {
  const RegisterUseCase(this._repository);
  final AuthRepository _repository;

  Future<AppUser> call({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) =>
      _repository.register(
        name: name,
        email: email,
        password: password,
        role: role,
      );
}

class LogoutUseCase {
  const LogoutUseCase(this._repository);
  final AuthRepository _repository;

  Future<void> call() => _repository.logout();
}
