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

  LoadStatus get status => _status;
  List<Recipe> get recipes => _recipes;
  String? get errorMessage => _errorMessage;
  String get keyword => _keyword;

  Future<void> search(String keyword) async {
    _keyword = keyword.trim();
    _status = LoadStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _recipes = await _repository.searchRecipes(_keyword);
      _status = LoadStatus.success;
    } catch (e) {
      _status = LoadStatus.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }
    notifyListeners();
  }

  Future<void> retry() => search(_keyword);
}