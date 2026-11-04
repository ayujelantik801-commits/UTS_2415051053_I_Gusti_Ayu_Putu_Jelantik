import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/recipe.dart';
import '../models/saved_bake.dart';
import '../providers/saved_bake_provider.dart';
import '../widgets/bake_form.dart';

class AddBakeScreen extends StatelessWidget {
  final Recipe recipe;

  const AddBakeScreen({super.key, required this.recipe});

  Future<void> _save(
    BuildContext context,
    String note,
    int rating,
    String status,
  ) async {
    final provider = context.read<SavedBakeProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final errorColor = Theme.of(context).colorScheme.error;

    final success = await provider.add(
      SavedBake(
        studentId: studentId,
        mealId: recipe.id,
        mealName: recipe.name,
        thumbnail: recipe.thumbnail,
        note: note,
        rating: rating,
        bakeStatus: status,
      ),
    );

    if (success) {
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text('Resep berhasil disimpan ke Koleksi.')),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(provider.actionError ?? 'Gagal menyimpan resep.'),
          backgroundColor: errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<SavedBakeProvider>().isSaving;

    return Scaffold(
      appBar: AppBar(title: const Text('Simpan ke Koleksi')),
      body: BakeForm(
        mealName: recipe.name,
        thumbnail: recipe.thumbnail,
        submitLabel: 'Simpan',
        isSaving: isSaving,
        onSubmit: (note, rating, status) =>
            _save(context, note, rating, status),
      ),
    );
  }
}