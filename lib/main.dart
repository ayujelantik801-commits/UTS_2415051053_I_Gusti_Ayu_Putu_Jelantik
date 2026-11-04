import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/recipe_provider.dart';
import 'providers/translation_provider.dart';
import 'repositories/recipe_repository.dart';
import 'repositories/translation_repository.dart';
import 'screens/app_shell.dart';
import 'services/meal_api_service.dart';
import 'services/translation_service.dart';

void main() => runApp(const BakeCraftApp());

class BakeCraftApp extends StatelessWidget {
  const BakeCraftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              RecipeProvider(RecipeRepository(MealApiService()))..search(''),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              TranslationProvider(TranslationRepository(TranslationService())),
        ),
      ],
      child: MaterialApp(
        title: 'BakeCraft',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSeed(seedColor: const Color(0xFFC77D3A)),
        ),
        home: const AppShell(),
      ),
    );
  }
}