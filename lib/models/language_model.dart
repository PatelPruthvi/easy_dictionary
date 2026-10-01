/// An entry of `GET /api/v1/languages`.
class LanguageModel {
  final String code;
  final String name;
  final int words;

  const LanguageModel({
    required this.code,
    required this.name,
    this.words = 0,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
        code: json["code"] ?? "",
        name: json["name"] ?? "",
        words: (json["words"] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() =>
      {"code": code, "name": name, "words": words};

  /// "1.4M words" / "12K words" / "840 words" for the picker subtitle.
  String get wordCountLabel {
    if (words >= 1000000) {
      return '${(words / 1000000).toStringAsFixed(1)}M words';
    }
    if (words >= 1000) return '${(words / 1000).round()}K words';
    return '$words words';
  }

  bool matches(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return true;
    return name.toLowerCase().contains(normalized) ||
        code.toLowerCase() == normalized;
  }

  @override
  bool operator ==(Object other) =>
      other is LanguageModel && other.code == code;

  @override
  int get hashCode => code.hashCode;
}
