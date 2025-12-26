class KanjiExample {
  final String word;
  final String reading;
  final String meaning;
  final String? type;

  const KanjiExample({
    required this.word,
    required this.reading,
    required this.meaning,
    this.type,
  });

  Map<String, dynamic> toJson() => {
        'word': word,
        'reading': reading,
        'meaning': meaning,
        if (type != null) 'type': type,
      };

  factory KanjiExample.fromJson(Map<String, dynamic> json) => KanjiExample(
        word: json['word'] as String,
        reading: json['reading'] as String,
        meaning: json['meaning'] as String,
        type: json['type'] as String?,
      );
}
