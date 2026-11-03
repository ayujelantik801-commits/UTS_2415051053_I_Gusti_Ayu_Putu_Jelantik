import 'package:flutter/material.dart';
import 'screens/app_shell.dart';

void main() => runApp(const BakeCraftApp());

class BakeCraftApp extends StatelessWidget {
  const BakeCraftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BakeCraft',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFC77D3A)),
      ),
      home: const AppShell(),
    );
  }
}