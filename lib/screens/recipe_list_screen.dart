import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import '../widgets/recipe_card.dart';
import '../widgets/state_message.dart';
import 'recipe_detail_screen.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController =
        TextEditingController(text: context.read<RecipeProvider>().label);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search(String value) {
    context.read<RecipeProvider>().search(value);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeProvider>();
    final title =
        provider.label.isEmpty ? 'Semua Resep' : 'Resep: ${provider.label}';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: _search,
              decoration: InputDecoration(
                hintText: 'Cari resep, mis. cokelat, keju, pisang...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  tooltip: 'Hapus pencarian',
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _search('');
                  },
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(28)),
                ),
              ),
            ),
          ),
          Expanded(child: _buildBody(provider)),
        ],
      ),
    );
  }

  Widget _buildBody(RecipeProvider provider) {
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