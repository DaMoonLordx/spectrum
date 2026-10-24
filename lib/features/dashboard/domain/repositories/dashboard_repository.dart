import '../entities/dashboard_entities.dart';

abstract class DashboardRepository {
  Future<List<MusicMatch>> getMatches();
  Future<List<ManagedUser>> getUsers();
  Future<List<ModerationReport>> getReports();
  Future<List<TriviaQuestion>> getTrivias();
  Future<void> addTrivia(TriviaQuestion trivia);
  Future<void> deleteTrivia(String id);
}
