import 'package:flutter/foundation.dart';
import '../models/recipe.dart';
import '../repositories/recipe_repository.dart';

enum LoadStatus { initial, loading, success, error }

class RecipeProvider extends ChangeNotifier {
  final RecipeRepository _repository;

  RecipeProvider(this._repository);

  LoadStatus _status = LoadStatus.initial;
  List<Recipe> _recipes = [];
  String? _errorMessage;
  String _keyword = '';

  // Penanda pencarian terbaru, agar respons lama tidak menimpa yang baru.
  int _requestId = 0;

  LoadStatus get status => _status;
  List<Recipe> get recipes => _recipes;
  String? get errorMessage => _errorMessage;
  String get keyword => _keyword;

  Future<void> search(String keyword) async {
    final requestId = ++_requestId;
    _keyword = keyword.trim();
    _status = LoadStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.searchRecipes(_keyword);
      if (requestId != _requestId) return; // ada pencarian yang lebih baru
      _recipes = result;
      _status = LoadStatus.success;
    } catch (e) {
      if (requestId != _requestId) return;
      _status = LoadStatus.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }
    notifyListeners();
  }

  Future<void> retry() => search(_keyword);
}