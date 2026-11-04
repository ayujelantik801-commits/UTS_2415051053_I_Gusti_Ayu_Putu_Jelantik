import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants.dart';
import '../models/saved_bake.dart';
import 'meal_api_service.dart'; // untuk ApiException

class SavedBakeService {
  static const _table = 'saved_bakes';

  final SupabaseClient _client;

  SavedBakeService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// READ: ambil semua resep tersimpan milik student_id ini.
  Future<List<SavedBake>> fetchAll() {
    return _guard(() async {
      final rows = await _client
          .from(_table)
          .select()
          .eq('student_id', studentId)
          .order('created_at', ascending: false);
      return rows.map((row) => SavedBake.fromJson(row)).toList();
    });
  }

  /// CREATE: simpan resep baru, lalu kembalikan baris yang dibuat database.
  Future<SavedBake> insert(SavedBake bake) {
    return _guard(() async {
      final row =
          await _client.from(_table).insert(bake.toJson()).select().single();
      return SavedBake.fromJson(row);
    });
  }

  /// UPDATE: ubah catatan, rating, dan status berdasarkan id.
  Future<SavedBake> update(SavedBake bake) {
    return _guard(() async {
      final row = await _client
          .from(_table)
          .update({
            'note': bake.note,
            'rating': bake.rating,
            'bake_status': bake.bakeStatus,
          })
          .eq('id', bake.id!)
          .select()
          .single();
      return SavedBake.fromJson(row);
    });
  }

  /// DELETE: hapus baris berdasarkan id.
  Future<void> delete(int id) {
    return _guard(() async {
      final deleted = await _client.from(_table).delete().eq('id', id).select();
      if (deleted.isEmpty) {
        throw const ApiException('Data tidak ditemukan atau sudah dihapus.');
      }
    });
  }

  /// Menerjemahkan berbagai error menjadi pesan yang mudah dipahami.
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action().timeout(const Duration(seconds: 10));
    } on PostgrestException catch (e) {
      throw ApiException('Database bermasalah: ${e.message}');
    } on SocketException {
      throw const ApiException('Tidak ada koneksi internet.');
    } on http.ClientException {
      throw const ApiException('Tidak ada koneksi internet.');
    } on TimeoutException {
      throw const ApiException('Koneksi terlalu lama. Coba lagi.');
    }
  }
}