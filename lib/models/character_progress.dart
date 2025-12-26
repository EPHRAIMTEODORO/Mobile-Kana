class CharacterProgress {
  final String character;
  int correct;
  int incorrect;
  DateTime lastReviewed;

  CharacterProgress({
    required this.character,
    this.correct = 0,
    this.incorrect = 0,
    DateTime? lastReviewed,
  }) : lastReviewed = lastReviewed ?? DateTime.now();

  double get accuracy {
    final total = correct + incorrect;
    return total == 0 ? 0.0 : correct / total;
  }

  bool get isMastered => accuracy >= 0.8 && (correct + incorrect) >= 5;

  Map<String, dynamic> toJson() => {
        'character': character,
        'correct': correct,
        'incorrect': incorrect,
        'lastReviewed': lastReviewed.toIso8601String(),
      };

  factory CharacterProgress.fromJson(Map<String, dynamic> json) =>
      CharacterProgress(
        character: json['character'] as String,
        correct: json['correct'] as int,
        incorrect: json['incorrect'] as int,
        lastReviewed: DateTime.parse(json['lastReviewed'] as String),
      );
}
