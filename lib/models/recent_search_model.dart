import 'dart:convert';

/// A past lookup, kept together with the language it was performed in so
/// tapping the chip repeats the exact same search.
class RecentSearchModel {
  final String word;
  final String languageCode;
  final String languageName;

  const RecentSearchModel({
    required this.word,
    required this.languageCode,
    required this.languageName,
  });

  factory RecentSearchModel.fromJson(Map<String, dynamic> json) =>
      RecentSearchModel(
        word: json['word'] ?? '',
        languageCode: json['languageCode'] ?? 'en',
        languageName: json['languageName'] ?? 'English',
      );

  Map<String, dynamic> toJson() => {
        'word': word,
        'languageCode': languageCode,
        'languageName': languageName,
      };

  String toRawJson() => json.encode(toJson());

  /// Reads an entry written either by this version or by the older builds,
  /// which stored a bare word string.
  static RecentSearchModel? tryParse(String raw) {
    if (raw.trim().isEmpty) return null;
    try {
      final decoded = json.decode(raw);
      if (decoded is Map) {
        final model =
            RecentSearchModel.fromJson(Map<String, dynamic>.from(decoded));
        return model.word.isEmpty ? null : model;
      }
    } catch (_) {
      // Pre-multilingual entries were plain words; treat them as English.
    }
    return RecentSearchModel(
      word: raw,
      languageCode: 'en',
      languageName: 'English',
    );
  }

  bool sameAs(RecentSearchModel other) =>
      other.word.toLowerCase() == word.toLowerCase() &&
      other.languageCode == languageCode;
}
