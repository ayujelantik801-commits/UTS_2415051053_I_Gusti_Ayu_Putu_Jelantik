import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const nama = 'I Gusti Ayu Putu Jelantik';
  static const nim = '2415051053';
  static const kelas = '5 PTI C';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const CircleAvatar(radius: 48, child: Icon(Icons.person, size: 48)),
          const SizedBox(height: 16),
          Center(
            child: Text(nama, style: Theme.of(context).textTheme.titleLarge),
          ),
          const SizedBox(height: 24),
          const ListTile(
            leading: Icon(Icons.badge_outlined),
            title: Text('NIM'),
            subtitle: Text(nim),
          ),
          const ListTile(
            leading: Icon(Icons.school_outlined),
            title: Text('Kelas'),
            subtitle: Text(kelas),
          ),
          const ListTile(
            leading: Icon(Icons.cake_outlined),
            title: Text('BakeCraft'),
            subtitle: Text('Aplikasi katalog dan koleksi resep baking'),
          ),
        ],
      ),
    );
  }
}