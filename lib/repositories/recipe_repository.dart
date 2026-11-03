import '../models/recipe.dart';
import '../services/sample_data.dart';

class RecipeRepository {
  Future<List<Recipe>> searchRecipes(String keyword) async {
    await Future.delayed(const Duration(milliseconds: 600)); // simulasi loading
    final k = keyword.trim().toLowerCase();
    if (k.isEmpty) return sampleRecipes;
    return sampleRecipes
        .where((r) => r.name.toLowerCase().contains(k))
        .toList();
  }
}