import 'package:flutter/material.dart';

class RecipeImage extends StatelessWidget {
  final String url;
  final double? height;

  const RecipeImage({super.key, required this.url, this.height});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      height: height,
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: const Center(child: Icon(Icons.cake_outlined, size: 40)),
    );

    if (url.isEmpty) return placeholder;

    return Image.network(
      url,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => placeholder,
    );
  }
}