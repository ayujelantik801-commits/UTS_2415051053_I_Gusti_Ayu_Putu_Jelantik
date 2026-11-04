import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import '../widgets/recipe_card.dart';
import '../widgets/section_title.dart';
import '../widgets/state_message.dart';
import 'recipe_detail_screen.dart';
import 'recipe_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // (label tampilan, kata kunci untuk API)
  static const _categories = [
    ('Kue', 'cake'),
    ('Pai', 'pie'),
    ('Kue Kering', 'cookie'),
    ('Tart', 'tart'),
    ('Brownies', 'brownie'),
    ('Roti', 'bread'),
  ];

  void _openResults(BuildContext context, String keyword, {String? label}) {
    context.read<RecipeProvider>().search(keyword, label: label);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RecipeListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('BakeCraft')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Wujudkan Kue Impianmu',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          TextField(
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) _openResults(context, value);
            },
            decoration: const InputDecoration(
              hintText: 'Cari resep, mis. cokelat, keju, pisang...',
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
                ActionChip(
                  label: Text(c.$1),
                  onPressed: () => _openResults(context, c.$2, label: c.$1),
                ),
            ],
          ),
          const SizedBox(height: 24),
          const SectionTitle('Resep Pilihan'),
          const SizedBox(height: 12),
          SizedBox(height: 230, child: _FeaturedList(provider: provider)),
        ],
      ),
    );
  }
}

class _FeaturedList extends StatelessWidget {
  final RecipeProvider provider;

  const _FeaturedList({required this.provider});

  @override
  Widget build(BuildContext context) {
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
            message: 'Belum ada resep.',
          );
        }
        final items = provider.recipes.take(8).toList();
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final recipe = items[index];
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
        );
    }
  }
}