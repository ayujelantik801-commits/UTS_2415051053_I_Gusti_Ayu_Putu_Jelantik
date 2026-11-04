import 'package:flutter/foundation.dart';
import '../models/saved_bake.dart';
import '../repositories/saved_bake_repository.dart';
import 'recipe_provider.dart' show LoadStatus;

class SavedBakeProvider extends ChangeNotifier {
  final SavedBakeRepository _repository;

  SavedBakeProvider(this._repository);

  LoadStatus _status = LoadStatus.initial;
  List<SavedBake> _items = [];
  String? _errorMessage;

  bool _isSaving = false;
  String? _actionError;

  LoadStatus get status => _status;
  List<SavedBake> get items => _items;
  String? get errorMessage => _errorMessage;
  bool get isSaving => _isSaving;
  String? get actionError => _actionError;

  /// Shared state: dipakai layar detail untuk tahu resep sudah disimpan atau belum.
  bool isSaved(String mealId) => _items.any((e) => e.mealId == mealId);

  Future<void> load() async {
    _status = LoadStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _items = await _repository.getAll();
      _status = LoadStatus.success;
    } catch (e) {
      _status = LoadStatus.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }
    notifyListeners();
  }

  /// Mengembalikan true jika berhasil. Pesan gagal ada di [actionError].
  Future<bool> add(SavedBake bake) async {
    _isSaving = true;
    _actionError = null;
    notifyListeners();

    try {
      final created = await _repository.add(bake);
      _items = [created, ..._items];
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _actionError = e.toString();
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

    /// Mengembalikan true jika berhasil. Pesan gagal ada di [actionError].
  Future<bool> update(SavedBake bake) async {
    _isSaving = true;
    _actionError = null;
    notifyListeners();

    try {
      final updated = await _repository.edit(bake);
      _items = [
        for (final item in _items) item.id == updated.id ? updated : item,
      ];
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _actionError = e.toString();
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }
}