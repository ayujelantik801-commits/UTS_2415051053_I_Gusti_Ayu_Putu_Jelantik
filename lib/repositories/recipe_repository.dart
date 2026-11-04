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

    // Katalog awal: gabungkan beberapa kata kunci baking.
    // Satu request yang gagal tidak membatalkan yang lain.
    ApiException? lastError;
    final results = await Future.wait(_defaultKeywords.map((word) async {
      try {
        return await _service.searchMeals(word);
      } on ApiException catch (e) {
        lastError = e;
        return <Recipe>[];
      }
    }));

    final unique = <String, Recipe>{};
    for (final list in results) {
      for (final recipe in list) {
        unique[recipe.id] = recipe;
      }
    }

    // Jika semua request gagal, lempar error agar UI menampilkan error state.
    final error = lastError;
    if (unique.isEmpty && error != null) throw error;
    return unique.values.toList();
  }
}