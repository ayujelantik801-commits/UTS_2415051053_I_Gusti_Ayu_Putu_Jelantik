import 'package:flutter/material.dart';

class MyBakesScreen extends StatelessWidget {
  const MyBakesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Bakes')),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bookmark_border, size: 64),
            SizedBox(height: 12),
            Text('Belum ada resep tersimpan'),
          ],
        ),
      ),
    );
  }
}