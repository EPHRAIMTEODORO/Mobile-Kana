enum KanaType { hiragana, katakana }

class KanaCharacter {
  final String character;
  final String romaji;
  final KanaType type;

  const KanaCharacter({
    required this.character,
    required this.romaji,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'character': character,
        'romaji': romaji,
        'type': type.toString(),
      };

  factory KanaCharacter.fromJson(Map<String, dynamic> json) => KanaCharacter(
        character: json['character'] as String,
        romaji: json['romaji'] as String,
        type: json['type'] == 'KanaType.hiragana'
            ? KanaType.hiragana
            : KanaType.katakana,
      );
}
