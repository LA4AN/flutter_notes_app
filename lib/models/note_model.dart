class NoteModel {
  final String id;
  final String title;
  final String description;
  final bool isFinished;

  NoteModel({
    required this.id,
    required this.title,
    required this.description,
    this.isFinished = false,
  });

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isFinished: map['is_finished'] ?? false,
    );
  }

  NoteModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isFinished,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isFinished: isFinished ?? this.isFinished,
    );
  }
}
