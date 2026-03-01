/// Модель желания (Текущие / Исполненные).
class Wish {
  final String id;
  final String category;
  final String title;
  final String description;
  final bool isFulfilled;
  final bool isFavorite;

  Wish({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    this.isFulfilled = false,
    this.isFavorite = false,
  });

  Wish copyWith({
    String? id,
    String? category,
    String? title,
    String? description,
    bool? isFulfilled,
    bool? isFavorite,
  }) {
    return Wish(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      isFulfilled: isFulfilled ?? this.isFulfilled,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
