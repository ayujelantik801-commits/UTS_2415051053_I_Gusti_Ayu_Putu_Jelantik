import 'package:flutter/material.dart';
import '../models/saved_bake.dart';
import 'recipe_image.dart';

class SavedBakeTile extends StatelessWidget {
  final SavedBake bake;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const SavedBakeTile({
    super.key,
    required this.bake,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: RecipeImage(url: bake.thumbnail, height: 72),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bake.mealName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(bake.bakeStatus, style: textTheme.bodySmall),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text('${bake.rating}/5', style: textTheme.bodySmall),
                      ],
                    ),
                    if (bake.note != null && bake.note!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        bake.note!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              if (onDelete != null)
                IconButton(
                  tooltip: 'Hapus',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onDelete,
                ),
            ],
          ),
        ),
      ),
    );
  }
}