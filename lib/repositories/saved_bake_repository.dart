import '../models/saved_bake.dart';
import '../services/saved_bake_service.dart';

class SavedBakeRepository {
  final SavedBakeService _service;

  SavedBakeRepository(this._service);

  Future<List<SavedBake>> getAll() => _service.fetchAll();
  Future<SavedBake> add(SavedBake bake) => _service.insert(bake);
}