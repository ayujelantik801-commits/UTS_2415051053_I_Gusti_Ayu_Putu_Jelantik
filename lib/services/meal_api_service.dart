import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

class MealApiService {
  static const _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  final http.Client _client;

  MealApiService({http.Client? client}) : _client = client ?? http.Client();

  /// GET search.php?s=keyword
  Future<List<Recipe>> searchMeals(String keyword) async {
    final uri = Uri.parse('$_baseUrl/search.php')
        .replace(queryParameters: {'s': keyword});

    try {
      final response =
          await _client.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw ApiException('Server bermasalah (kode ${response.statusCode}).');
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final meals = body['meals'] as List<dynamic>?;
      if (meals == null) return []; // API mengirim null jika tidak ada hasil

      return meals
          .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
          .toList();
    } on SocketException {
      throw const ApiException('Tidak ada koneksi internet.');
    } on http.ClientException {
      throw const ApiException('Tidak ada koneksi internet.');
    } on TimeoutException {
      throw const ApiException('Koneksi terlalu lama. Coba lagi.');
    } on FormatException {
      throw const ApiException('Format data dari server tidak valid.');
    }
  }
}