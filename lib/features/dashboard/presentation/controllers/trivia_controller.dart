import 'package:flutter/foundation.dart';

import '../../domain/entities/dashboard_entities.dart';
import '../../domain/repositories/dashboard_repository.dart';

/// Estado compartido de las trivias: el admin las crea y borra,
/// el cliente las juega. Ambas pantallas escuchan este mismo controlador.
class TriviaController extends ChangeNotifier {
  TriviaController(this._repository) {
    load();
  }

  final DashboardRepository _repository;

  List<TriviaQuestion> _items = [];
  bool _isLoading = true;

  List<TriviaQuestion> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _items = await _repository.getTrivias();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> add(TriviaQuestion trivia) async {
    await _repository.addTrivia(trivia);
    _items = await _repository.getTrivias();
    notifyListeners();
  }

  Future<void> remove(String id) async {
    await _repository.deleteTrivia(id);
    _items = await _repository.getTrivias();
    notifyListeners();
  }
}
