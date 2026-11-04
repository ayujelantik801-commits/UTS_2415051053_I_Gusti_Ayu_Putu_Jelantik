import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/saved_bake.dart';
import '../providers/recipe_provider.dart' show LoadStatus;
import '../providers/saved_bake_provider.dart';
import '../widgets/saved_bake_tile.dart';
import '../widgets/state_message.dart';
import 'edit_bake_screen.dart';

class MyBakesScreen extends StatelessWidget {
  const MyBakesScreen({super.key});

  Future<void> _confirmDelete(BuildContext context, SavedBake bake) async {
    final provider = context.read<SavedBakeProvider>();
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus dari Koleksi?'),
        content: Text('"${bake.mealName}" akan dihapus permanen dari koleksimu.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final success = await provider.remove(bake);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Resep dihapus dari Koleksi.'
              : (provider.actionError ?? 'Gagal menghapus resep.'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SavedBakeProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Koleksiku')),
      body: _buildBody(context, provider),
    );
  }

  Widget _buildBody(BuildContext context, SavedBakeProvider provider) {
    switch (provider.status) {
      case LoadStatus.initial:
      case LoadStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case LoadStatus.error:
        return StateMessage(
          icon: Icons.cloud_off,
          message: provider.errorMessage ?? 'Terjadi kesalahan.',
          onAction: provider.load,
        );
      case LoadStatus.success:
        if (provider.items.isEmpty) {
          return const StateMessage(
            icon: Icons.bookmark_border,
            message:
                'Belum ada resep tersimpan.\nSimpan resep favoritmu dari halaman detail.',
          );
        }
        return RefreshIndicator(
          onRefresh: provider.load,
          child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            // 1 kolom di HP, 2 kolom atau lebih di layar lebar.
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 560,
              mainAxisExtent: 120,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: provider.items.length,
            itemBuilder: (context, index) {
              final bake = provider.items[index];
              return SavedBakeTile(
                bake: bake,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditBakeScreen(bake: bake),
                  ),
                ),
                onDelete: () => _confirmDelete(context, bake),
              );
            },
          ),
        );
    }
  }
}