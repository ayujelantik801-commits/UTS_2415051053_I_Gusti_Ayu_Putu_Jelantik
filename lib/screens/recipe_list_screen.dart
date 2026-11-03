import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import '../widgets/recipe_card.dart';
import '../widgets/state_message.dart';
import 'recipe_detail_screen.dart';

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeProvider>();
    final title = provider.keyword.isEmpty
        ? 'Semua Resep'
        : 'Resep: ${provider.keyword}';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: _buildBody(context, provider),
    );
  }

  Widget _buildBody(BuildContext context, RecipeProvider provider) {
    switch (provider.status) {
      case LoadStatus.initial:
      case LoadStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case LoadStatus.error:
        return StateMessage(
          icon: Icons.wifi_off,
          message: provider.errorMessage ?? 'Terjadi kesalahan.',
          onAction: provider.retry,
        );
      case LoadStatus.success:
        if (provider.recipes.isEmpty) {
          return const StateMessage(
            icon: Icons.search_off,
            message: 'Resep tidak ditemukan. Coba kata kunci lain.',
          );
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final columns = width >= 900 ? 4 : (width >= 600 ? 3 : 2);
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: provider.recipes.length,
              itemBuilder: (context, index) {
                final recipe = provider.recipes[index];
                return RecipeCard(
                  recipe: recipe,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipeDetailScreen(recipe: recipe),
                    ),
                  ),
                );
              },
            );
          },
        );
    }
  }
}