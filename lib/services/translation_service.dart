import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'meal_api_service.dart'; // untuk ApiException

class TranslationService {
  static const _endpoint = 'https://api.mymemory.translated.net/get';

  // Email opsional (menaikkan kuota harian). Diisi lewat --dart-define,
  // JANGAN ditulis langsung di kode.
  static const _email = String.fromEnvironment('MYMEMORY_EMAIL');

  // Batas API 500 byte; sisakan ruang untuk karakter non-ASCII.
  static const _maxChunk = 400;

  final http.Client _client;

  TranslationService({http.Client? client})
      : _client = client ?? http.Client();

  Future<String> translateToIndonesian(String text) async {
    final chunks = _splitIntoChunks(text);
    final results = await Future.wait(chunks.map(_translateChunk));
    return results.join('\n');
  }

  List<String> _splitIntoChunks(String text) {
    // 1. Pecah per baris; kalimat yang terlalu panjang dipecah lagi.
    final parts = <String>[];
    for (final line in text.split(RegExp(r'[\r\n]+'))) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      if (trimmed.length <= _maxChunk) {
        parts.add(trimmed);
        continue;
      }
      for (final sentence in trimmed.split(RegExp(r'(?<=[.!?])\s+'))) {
        var rest = sentence;
        while (rest.length > _maxChunk) {
          parts.add(rest.substring(0, _maxChunk));
          rest = rest.substring(_maxChunk);
        }
        if (rest.isNotEmpty) parts.add(rest);
      }
    }

    // 2. Gabungkan bagian pendek agar jumlah request lebih sedikit.
    final chunks = <String>[];
    var buffer = '';
    for (final part in parts) {
      if (buffer.isEmpty) {
        buffer = part;
      } else if (buffer.length + 1 + part.length <= _maxChunk) {
        buffer = '$buffer\n$part';
      } else {
        chunks.add(buffer);
        buffer = part;
      }
    }
    if (buffer.isNotEmpty) chunks.add(buffer);
    return chunks;
  }

  Future<String> _translateChunk(String chunk) async {
    final uri = Uri.parse(_endpoint).replace(queryParameters: {
      'q': chunk,
      'langpair': 'en|id',
      if (_email.isNotEmpty) 'de': _email,
    });

    try {
      final response =
          await _client.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw ApiException(
            'Layanan terjemahan bermasalah (kode ${response.statusCode}).');
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final status = int.tryParse('${body['responseStatus']}') ?? 0;
      final data = body['responseData'] as Map<String, dynamic>;
      final text = (data['translatedText'] as String).trim();

      if (status == 429 || text.startsWith('MYMEMORY WARNING')) {
        throw const ApiException(
            'Kuota terjemahan harian habis. Coba lagi besok.');
      }
      if (status != 200) {
        throw const ApiException('Terjemahan gagal. Coba lagi.');
      }
      return _decodeEntities(text);
    } on SocketException {
      throw const ApiException('Tidak ada koneksi internet.');
    } on http.ClientException {
      throw const ApiException('Tidak ada koneksi internet.');
    } on TimeoutException {
      throw const ApiException('Koneksi terlalu lama. Coba lagi.');
    } on FormatException {
      throw const ApiException('Format data terjemahan tidak valid.');
    }
  }

  // MyMemory kadang mengirim karakter dalam bentuk entitas HTML.
  String _decodeEntities(String s) => s
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&amp;', '&');
}