import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/saved_bake.dart';
import '../providers/saved_bake_provider.dart';
import '../widgets/bake_form.dart';

class EditBakeScreen extends StatelessWidget {
  final SavedBake bake;

  const EditBakeScreen({super.key, required this.bake});

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

    final success = await provider.update(
      bake.copyWith(note: note, rating: rating, bakeStatus: status),
    );

    if (success) {
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text('Perubahan berhasil disimpan.')),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(provider.actionError ?? 'Gagal menyimpan perubahan.'),
          backgroundColor: errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<SavedBakeProvider>().isSaving;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Koleksi')),
      body: BakeForm(
        mealName: bake.mealName,
        thumbnail: bake.thumbnail,
        initialNote: bake.note ?? '',
        initialRating: bake.rating,
        initialStatus: bake.bakeStatus,
        submitLabel: 'Simpan Perubahan',
        isSaving: isSaving,
        onSubmit: (note, rating, status) =>
            _save(context, note, rating, status),
      ),
    );
  }
}