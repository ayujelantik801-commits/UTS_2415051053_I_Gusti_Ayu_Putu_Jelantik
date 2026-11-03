class Recipe {
  final String id;
  final String name;
  final String thumbnail;
  final String? category;
  final String? area;
  final String? instructions;
  final List<String> ingredients;

  const Recipe({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.category,
    this.area,
    this.instructions,
    this.ingredients = const [],
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final ingredients = <String>[];
    for (var i = 1; i <= 20; i++) {
      final ingredient = (json['strIngredient$i'] as String?)?.trim();
      final measure = (json['strMeasure$i'] as String?)?.trim();
      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add(
          measure != null && measure.isNotEmpty
              ? '$measure $ingredient'
              : ingredient,
        );
      }
    }

    return Recipe(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      thumbnail: json['strMealThumb'] as String? ?? '',
      category: json['strCategory'] as String?,
      area: json['strArea'] as String?,
      instructions: json['strInstructions'] as String?,
      ingredients: ingredients,
    );
  }
}