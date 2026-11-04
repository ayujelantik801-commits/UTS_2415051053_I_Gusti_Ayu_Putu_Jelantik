import 'package:flutter/foundation.dart';
import '../models/recipe.dart';
import '../models/translated_content.dart';
import '../repositories/translation_repository.dart';

class TranslationProvider extends ChangeNotifier {
  final TranslationRepository _repository;

  TranslationProvider(this._repository);

  final Map<String, TranslatedContent> _cache = {};
  final Set<String> _loading = {};
  final Map<String, String> _errors = {};

  TranslatedContent? contentFor(String recipeId) => _cache[recipeId];
  bool isLoading(String recipeId) => _loading.contains(recipeId);
  String? errorFor(String recipeId) => _errors[recipeId];

  Future<void> translate(Recipe recipe) async {
    if (_cache.containsKey(recipe.id) || _loading.contains(recipe.id)) return;

    _loading.add(recipe.id);
    _errors.remove(recipe.id);
    notifyListeners();

    try {
      _cache[recipe.id] = await _repository.translateRecipe(recipe);
    } catch (e) {
      _errors[recipe.id] = e.toString();
    }

    _loading.remove(recipe.id);
    notifyListeners();
  }
}