import '../models/recipe.dart';
import '../services/meal_api_service.dart';

class RecipeRepository {
  final MealApiService _service;

  RecipeRepository(this._service);

  static const _defaultKeywords = [
    'cake', 'cookie', 'brownie', 'tart', 'bread', 'pie',
  ];

  Future<List<Recipe>> searchRecipes(String keyword) async {
    final k = keyword.trim();
    if (k.isNotEmpty) return _service.searchMeals(k);

    // Katalog awal: gabungkan beberapa kata kunci baking, hapus duplikat.
    final results = await Future.wait(_defaultKeywords.map(_service.searchMeals));
    final unique = <String, Recipe>{};
    for (final list in results) {
      for (final recipe in list) {
        unique[recipe.id] = recipe;
      }
    }
    return unique.values.toList();
  }
}