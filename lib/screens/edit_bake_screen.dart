import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/saved_bake.dart';
import '../providers/saved_bake_provider.dart';
import '../widgets/rating_input.dart';
import '../widgets/recipe_image.dart';

class EditBakeScreen extends StatefulWidget {
  final SavedBake bake;

  const EditBakeScreen({super.key, required this.bake});

  @override
  State<EditBakeScreen> createState() => _EditBakeScreenState();
}

class _EditBakeScreenState extends State<EditBakeScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _noteController;
  late int _rating;
  late String _status;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.bake.note ?? '');
    _rating = widget.bake.rating;
    _status = widget.bake.bakeStatus;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final provider = context.read<SavedBakeProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final updated = widget.bake.copyWith(
      note: _noteController.text.trim(),
      rating: _rating,
      bakeStatus: _status,
    );

    final success = await provider.update(updated);
    if (!mounted) return;

    if (success) {
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text('Perubahan berhasil disimpan.')),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(provider.actionError ?? 'Gagal menyimpan perubahan.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<SavedBakeProvider>().isSaving;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Koleksi')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 64,
                          height: 64,
                          child: RecipeImage(
                            url: widget.bake.thumbnail,
                            height: 64,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.bake.mealName,
                          style: textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _noteController,
                    maxLines: 3,
                    maxLength: 200,
                    decoration: const InputDecoration(
                      labelText: 'Catatan',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) return 'Catatan wajib diisi.';
                      if (text.length < 3) return 'Catatan minimal 3 karakter.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Text('Rating', style: textTheme.titleSmall),
                  RatingInput(
                    initialValue: widget.bake.rating,
                    validator: (v) =>
                        (v == null || v < 1) ? 'Pilih rating 1 sampai 5.' : null,
                    onSaved: (v) => _rating = v ?? 0,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _status,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      for (final s in SavedBake.statusOptions)
                        DropdownMenuItem(value: s, child: Text(s)),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _status = v);
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: isSaving ? null : _submit,
                      icon: isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(isSaving ? 'Menyimpan...' : 'Simpan Perubahan'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}