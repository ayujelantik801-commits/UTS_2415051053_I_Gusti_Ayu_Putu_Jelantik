class SavedBake {
  final int? id;
  final String mealId;
  final String mealName;
  final String thumbnail;
  final String? note;
  final int rating;
  final String bakeStatus;
  final DateTime? createdAt;

  static const statusWantToTry = 'Mau dicoba';
  static const statusTrying = 'Sedang dicoba';
  static const statusSuccess = 'Berhasil';
  static const statusOptions = [statusWantToTry, statusTrying, statusSuccess];

  const SavedBake({
    this.id,
    required this.mealId,
    required this.mealName,
    required this.thumbnail,
    this.note,
    this.rating = 0,
    this.bakeStatus = statusWantToTry,
    this.createdAt,
  });

  factory SavedBake.fromJson(Map<String, dynamic> json) {
    return SavedBake(
      id: json['id'] as int?,
      mealId: json['meal_id'] as String,
      mealName: json['meal_name'] as String,
      thumbnail: json['thumbnail'] as String? ?? '',
      note: json['note'] as String?,
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      bakeStatus: json['bake_status'] as String? ?? statusWantToTry,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'meal_id': mealId,
        'meal_name': mealName,
        'thumbnail': thumbnail,
        'note': note,
        'rating': rating,
        'bake_status': bakeStatus,
      };

  SavedBake copyWith({String? note, int? rating, String? bakeStatus}) {
    return SavedBake(
      id: id,
      mealId: mealId,
      mealName: mealName,
      thumbnail: thumbnail,
      note: note ?? this.note,
      rating: rating ?? this.rating,
      bakeStatus: bakeStatus ?? this.bakeStatus,
      createdAt: createdAt,
    );
  }
}