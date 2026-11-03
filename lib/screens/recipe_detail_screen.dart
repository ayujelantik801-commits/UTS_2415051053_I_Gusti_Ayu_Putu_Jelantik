import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../widgets/recipe_image.dart';
import '../widgets/section_title.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.name)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 720) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: RecipeImage(url: recipe.thumbnail, height: 400),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: _RecipeInfo(recipe: recipe),
                  ),
                ),
              ],
            );
          }
          return ListView(
            children: [
              RecipeImage(url: recipe.thumbnail, height: 240),
              Padding(
                padding: const EdgeInsets.all(16),
                child: _RecipeInfo(recipe: recipe),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RecipeInfo extends StatelessWidget {
  final Recipe recipe;

  const _RecipeInfo({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(recipe.name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            if (recipe.category != null) Chip(label: Text(recipe.category!)),
            if (recipe.area != null) Chip(label: Text(recipe.area!)),
          ],
        ),
        const SizedBox(height: 16),
        const SectionTitle('Bahan'),
        const SizedBox(height: 8),
        for (final item in recipe.ingredients)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text('• $item'),
          ),
        const SizedBox(height: 16),
        const SectionTitle('Langkah'),
        const SizedBox(height: 8),
        Text(recipe.instructions ?? 'Belum ada instruksi.'),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () {}, // akan dihubungkan ke database nanti
          icon: const Icon(Icons.bookmark_add_outlined),
          label: const Text('Simpan ke My Bakes'),
        ),
      ],
    );
  }
}