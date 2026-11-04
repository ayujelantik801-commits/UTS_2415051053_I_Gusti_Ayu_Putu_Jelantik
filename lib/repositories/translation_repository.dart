import '../models/recipe.dart';
import '../models/translated_content.dart';
import '../services/translation_service.dart';

class TranslationRepository {
  final TranslationService _service;

  TranslationRepository(this._service);

  Future<TranslatedContent> translateRecipe(Recipe recipe) async {
    final results = await Future.wait([
      _service.translateToIndonesian(recipe.instructions ?? ''),
      _service.translateToIndonesian(recipe.ingredients.join('\n')),
    ]);

    final lines = results[1]
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    // Jika jumlah baris berubah setelah diterjemahkan, pakai daftar asli.
    final ingredients =
        lines.length == recipe.ingredients.length ? lines : recipe.ingredients;

    return TranslatedContent(
      ingredients: ingredients,
      instructions: results[0],
    );
  }
}