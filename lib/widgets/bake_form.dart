import 'package:flutter/material.dart';
import '../models/saved_bake.dart';
import 'rating_input.dart';
import 'recipe_image.dart';

/// Form bersama untuk menambah dan mengedit resep di Koleksi.
class BakeForm extends StatefulWidget {
  final String mealName;
  final String thumbnail;
  final String initialNote;
  final int initialRating;
  final String initialStatus;
  final String submitLabel;
  final bool isSaving;
  final void Function(String note, int rating, String status) onSubmit;

  const BakeForm({
    super.key,
    required this.mealName,
    required this.thumbnail,
    required this.submitLabel,
    required this.onSubmit,
    this.initialNote = '',
    this.initialRating = 0,
    this.initialStatus = SavedBake.statusWantToTry,
    this.isSaving = false,
  });

  @override
  State<BakeForm> createState() => _BakeFormState();
}

class _BakeFormState extends State<BakeForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _noteController;
  late int _rating;
  late String _status;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.initialNote);
    _rating = widget.initialRating;
    _status = widget.initialStatus;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    widget.onSubmit(_noteController.text.trim(), _rating, _status);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
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
                        child: RecipeImage(url: widget.thumbnail, height: 64),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.mealName,
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
                    hintText: 'Mis. kurangi gula, panggang 5 menit lebih lama',
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
                  initialValue: widget.initialRating,
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
                    onPressed: widget.isSaving ? null : _submit,
                    icon: widget.isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(
                      widget.isSaving ? 'Menyimpan...' : widget.submitLabel,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}