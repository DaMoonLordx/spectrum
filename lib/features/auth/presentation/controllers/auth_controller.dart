import 'package:flutter/foundation.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/failures/auth_exception.dart';
import '../../domain/usecases/auth_usecases.dart';

/// Estado de autenticación. Las pantallas lo escuchan con ListenableBuilder.
class AuthController extends ChangeNotifier {
  AuthController({
    required LoginUseCase login,
    required RegisterUseCase register,
    required LogoutUseCase logout,
  })  : _login = login,
        _register = register,
        _logout = logout;

  final LoginUseCase _login;
  final RegisterUseCase _register;
  final LogoutUseCase _logout;

  AppUser? _user;
  bool _isLoading = false;
  String? _error;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> signIn(String email, String password) =>
      _run(() => _login(email, password));

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) =>
      _run(() => _register(
            name: name,
            email: email,
            password: password,
            role: role,
          ));

  Future<void> signOut() async {
    await _logout();
    _user = null;
    notifyListeners();
  }

  Future<bool> _run(Future<AppUser> Function() action) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await action();
      return true;
    } on AuthException catch (e) {
      _error = e.message;
      return false;
    } catch (_) {
      _error = 'Ocurrió un error inesperado. Inténtalo de nuevo.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
