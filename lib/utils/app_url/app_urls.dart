class AppUrls {
  /// Free Dictionary API (Wiktionary backed) - https://freedictionaryapi.com
  static const String dictionaryBaseUrl = "https://freedictionaryapi.com/api/v1";

  /// Entries for [word] in the language identified by [languageCode].
  static String entries({
    required String languageCode,
    required String word,
  }) =>
      "$dictionaryBaseUrl/entries/$languageCode/${Uri.encodeComponent(word)}";

  /// Every language the dictionary has entries for.
  static String get languages => "$dictionaryBaseUrl/languages";

  /// Random English words, used to pick the Word of the Day.
  static String randomWords({int count = 5}) =>
      "https://random-word-api.herokuapp.com/word?number=$count";
}
