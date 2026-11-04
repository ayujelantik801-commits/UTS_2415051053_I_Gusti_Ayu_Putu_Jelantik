import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/recipe_provider.dart';
import 'providers/saved_bake_provider.dart';
import 'providers/translation_provider.dart';
import 'repositories/recipe_repository.dart';
import 'repositories/saved_bake_repository.dart';
import 'repositories/translation_repository.dart';
import 'screens/app_shell.dart';
import 'services/meal_api_service.dart';
import 'services/saved_bake_service.dart';
import 'services/translation_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    publishableKey: const String.fromEnvironment('SUPABASE_KEY'),
  );
  runApp(const BakeCraftApp());
}

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
        ChangeNotifierProvider(
          create: (_) => SavedBakeProvider(
            SavedBakeRepository(SavedBakeService()),
          )..load(),
        ),
      ],
      child: MaterialApp(
        title: 'BakeCraft',
        debugShowCheckedModeBanner: false,
        locale: const Locale('id'),
        supportedLocales: const [Locale('id')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
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