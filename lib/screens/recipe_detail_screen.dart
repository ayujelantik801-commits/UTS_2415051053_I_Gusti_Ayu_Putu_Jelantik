import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../widgets/recipe_image.dart';
import '../widgets/section_title.dart';
import 'package:provider/provider.dart';
import '../providers/translation_provider.dart';

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

class _RecipeInfo extends StatefulWidget {
  final Recipe recipe;

  const _RecipeInfo({required this.recipe});

  @override
  State<_RecipeInfo> createState() => _RecipeInfoState();
}

class _RecipeInfoState extends State<_RecipeInfo> {
  bool _showOriginal = false;

  @override
  void initState() {
    super.initState();
    // Mulai terjemahan otomatis saat halaman dibuka.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<TranslationProvider>().translate(widget.recipe);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    final translation = context.watch<TranslationProvider>();
    final content = translation.contentFor(recipe.id);
    final loading = translation.isLoading(recipe.id);
    final error = translation.errorFor(recipe.id);

    final shown = _showOriginal ? null : content;
    final ingredients = shown?.ingredients ?? recipe.ingredients;
    final instructions = shown?.instructions ?? recipe.instructions ?? '';

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
        if (loading)
          const Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 8),
              Text('Menerjemahkan ke Bahasa Indonesia...'),
            ],
          )
        else if (error != null)
          Row(
            children: [
              Expanded(child: Text('$error Menampilkan teks asli.')),
              TextButton(
                onPressed: () => context
                    .read<TranslationProvider>()
                    .translate(recipe),
                child: const Text('Coba lagi'),
              ),
            ],
          )
        else if (content != null)
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('Indonesia')),
              ButtonSegment(value: true, label: Text('English')),
            ],
            selected: {_showOriginal},
            onSelectionChanged: (s) =>
                setState(() => _showOriginal = s.first),
          ),
        const SizedBox(height: 16),
        const SectionTitle('Bahan'),
        const SizedBox(height: 8),
        for (final item in ingredients)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text('• $item'),
          ),
        const SizedBox(height: 16),
        const SectionTitle('Cara Pembuatan'),
        const SizedBox(height: 8),
        Text(instructions.isEmpty ? 'Belum ada instruksi.' : instructions),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () {}, // akan dihubungkan ke database nanti
          icon: const Icon(Icons.bookmark_add_outlined),
          label: const Text('Simpan ke Koleksi'),
        ),
      ],
    );
  }
}