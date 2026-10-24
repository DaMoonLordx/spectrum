import '../../features/auth/data/repositories/mock_auth_repository.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_usecases.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/dashboard/data/repositories/mock_dashboard_repository.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/presentation/controllers/trivia_controller.dart';

/// Inyección de dependencias manual y sencilla (sin paquetes externos).
/// Para pasar a datos reales, cambia MockXxx por tu implementación con API.
class Injector {
  Injector._();

  static final AuthRepository authRepository = MockAuthRepository();
  static final DashboardRepository dashboardRepository =
      MockDashboardRepository();

  static final TriviaController triviaController =
      TriviaController(dashboardRepository);

  static final AuthController authController = AuthController(
    login: LoginUseCase(authRepository),
    register: RegisterUseCase(authRepository),
    logout: LogoutUseCase(authRepository),
  );
}
