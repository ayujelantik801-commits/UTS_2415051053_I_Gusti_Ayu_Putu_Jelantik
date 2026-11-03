import 'package:flutter/material.dart';
import '../services/sample_data.dart';
import '../widgets/recipe_card.dart';
import '../widgets/section_title.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _categories = ['Cake', 'Pie', 'Cookie', 'Tart', 'Brownie', 'Bread'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BakeCraft')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Craft Your Perfect Bake',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Cari resep kue...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(28)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              for (final c in _categories)
                ActionChip(label: Text(c), onPressed: () {}),
            ],
          ),
          const SizedBox(height: 24),
          const SectionTitle('Resep Pilihan'),
          const SizedBox(height: 12),
          SizedBox(
            height: 230,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: sampleRecipes.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final recipe = sampleRecipes[index];
                return SizedBox(
                  width: 160,
                  child: RecipeCard(
                    recipe: recipe,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecipeDetailScreen(recipe: recipe),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}