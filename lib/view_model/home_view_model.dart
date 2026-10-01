import 'package:easy_dictionary/data/network/api_logger.dart';
import 'package:easy_dictionary/data/pronunciation/pronunciation_service.dart';
import 'package:easy_dictionary/models/language_model.dart';
import 'package:easy_dictionary/models/recent_search_model.dart';
import 'package:easy_dictionary/models/word_stories_model.dart';
import 'package:easy_dictionary/utils/resources/app_resources.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/dictionary_model.dart';
import '../repository/dictionary_repo.dart';
import 'safe_notifier.dart';

class HomeViewModel extends ChangeNotifier with SafeNotifier {
  HomeViewModel({DictionaryRepo? repository})
      : _repository = repository ?? DictionaryRepo() {
    wordController.addListener(_onTextChanged);
    _loadWordStories();
    _restoreAndLoad();
  }

  static const String _recentSearchesKey = 'recentSearches';
  static const String _languageCodeKey = 'searchLanguageCode';
  static const String _languageNameKey = 'searchLanguageName';
  static const String _wordOfDayDateKey = 'wordOfTheDayDate';
  static const String _wordOfDayPayloadKey = 'wordOfTheDayPayload';
  static const int _maxRecentSearches = 8;
  static const int _randomWordAttempts = 5;

  final DictionaryRepo _repository;
  final TextEditingController wordController = TextEditingController();

  /// The language every search and the language picker operate on.
  LanguageModel selectedLanguage = AppResources.defaultLanguage;

  /// Languages offered by the API; seeded with a static list so the picker is
  /// usable before (and without) a successful network call.
  List<LanguageModel> languages = AppResources.fallbackLanguages;
  bool isLanguagesLoading = false;

  DictionaryModel? wordOfTheDay;
  DictionaryModel? searchedWord;
  List<WordStoriesModel> wordStories = [];
  List<RecentSearchModel> recentSearches = [];

  bool isLoading = false;
  bool isWordLoading = false;
  bool isAudioLoading = false;
  String? errorMessageForWOD;

  bool get isSearchButtonVisible => wordController.text.trim().isNotEmpty;

  /// Word of the Day always comes from the English random word API.
  String get wordOfTheDayLanguageCode =>
      wordOfTheDay?.language?.code ?? AppResources.defaultLanguage.code;

  void _onTextChanged() => notifyListeners();

  Future<void> _restoreAndLoad() async {
    final prefs = await SharedPreferences.getInstance();
    _restoreLanguage(prefs);
    _restoreRecentSearches(prefs);
    notifyListeners();

    await Future.wait([
      fetchWordOfTheDay(),
      loadLanguages(),
    ]);
  }

  // ---------------------------------------------------------------- languages

  Future<void> loadLanguages() async {
    isLanguagesLoading = true;
    notifyListeners();
    try {
      final fetched = await _repository.fetchLanguages();
      languages = fetched;
      // Refresh the stored language with the API's own name / word count.
      final match = fetched.firstWhere(
        (language) => language.code == selectedLanguage.code,
        orElse: () => selectedLanguage,
      );
      selectedLanguage = match;
    } catch (error, stackTrace) {
      ApiLogger.error(
        operation: 'Language list',
        error: error,
        stackTrace: stackTrace,
      );
      // Keep the fallback list; the picker stays usable.
    } finally {
      isLanguagesLoading = false;
      notifyListeners();
    }
  }

  /// Quick-pick languages shown above the searchable list.
  List<LanguageModel> get suggestedLanguages {
    final byCode = {for (final language in languages) language.code: language};
    return AppResources.suggestedLanguageCodes
        .map((code) => byCode[code])
        .whereType<LanguageModel>()
        .toList();
  }

  Future<void> selectLanguage(LanguageModel language) async {
    if (language.code == selectedLanguage.code) return;
    selectedLanguage = language;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, language.code);
    await prefs.setString(_languageNameKey, language.name);
  }

  void _restoreLanguage(SharedPreferences prefs) {
    final code = prefs.getString(_languageCodeKey);
    if (code == null || code.isEmpty) return;
    selectedLanguage = LanguageModel(
      code: code,
      name: prefs.getString(_languageNameKey) ?? code.toUpperCase(),
    );
  }

  // ------------------------------------------------------------- word of day

  /// Loads the Word of the Day, reusing today's cached payload when present.
  ///
  /// The word is drawn once per day and then reused, so reopening the app or
  /// pulling to refresh never changes it. Only [forceRefresh] - the shuffle
  /// button - draws a new word, and that new word is saved as the word for the
  /// rest of the day.
  Future<void> fetchWordOfTheDay({bool forceRefresh = false}) async {
    isWordLoading = true;
    errorMessageForWOD = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    if (!forceRefresh && _loadCachedWordOfTheDay(prefs)) {
      isWordLoading = false;
      notifyListeners();
      return;
    }

    try {
      final model = await _resolveWordOfTheDay();
      wordOfTheDay = model;
      errorMessageForWOD = null;
      await prefs.setString(_wordOfDayDateKey, _todayKey());
      await prefs.setString(_wordOfDayPayloadKey, model.toRawJson());
    } catch (error, stackTrace) {
      ApiLogger.error(
        operation: 'Word of the Day lookup',
        error: error,
        stackTrace: stackTrace,
      );
      // A stale cached word still beats an error card.
      if (!_loadCachedWordOfTheDay(prefs, ignoreDate: true)) {
        errorMessageForWOD = error.toString();
      }
    } finally {
      isWordLoading = false;
      notifyListeners();
    }
  }

  /// Retries today's word after a failure; it does not draw a different word.
  Future<void> retryWordOfTheDay() => fetchWordOfTheDay();

  /// Draws a new word on demand and keeps it as the word for the rest of today.
  Future<void> shuffleWordOfTheDay() => fetchWordOfTheDay(forceRefresh: true);

  /// Draws random words until one has dictionary entries, then falls back to
  /// the curated list. Random words are often inflections Wiktionary misses.
  Future<DictionaryModel> _resolveWordOfTheDay() async {
    final candidates = <String>[];
    try {
      candidates.addAll(
        await _repository.fetchRandomWords(count: _randomWordAttempts),
      );
    } catch (error, stackTrace) {
      ApiLogger.error(
        operation: 'Random word',
        error: error,
        stackTrace: stackTrace,
      );
    }
    candidates.add(AppResources.fallbackWordOfTheDay());

    Object? lastError;
    for (final candidate in candidates) {
      try {
        return await _repository.fetchWordDetails(
          word: candidate,
          languageCode: AppResources.defaultLanguage.code,
        );
      } catch (error) {
        lastError = error;
      }
    }
    throw lastError ?? Exception('Could not load the Word of the Day.');
  }

  bool _loadCachedWordOfTheDay(
    SharedPreferences prefs, {
    bool ignoreDate = false,
  }) {
    final payload = prefs.getString(_wordOfDayPayloadKey);
    if (payload == null || payload.isEmpty) return false;
    if (!ignoreDate && prefs.getString(_wordOfDayDateKey) != _todayKey()) {
      return false;
    }

    try {
      final model = DictionaryModel.fromRawJson(payload);
      if (!model.hasEntries) return false;
      wordOfTheDay = model;
      errorMessageForWOD = null;
      return true;
    } catch (error) {
      ApiLogger.error(operation: 'Cached Word of the Day', error: error);
      return false;
    }
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  // ------------------------------------------------------------------ search

  /// Looks up [word] (or the text field) and stores the result in
  /// [searchedWord]. Throws an [AppException] the caller can surface.
  Future<DictionaryModel> searchWord({
    String? word,
    LanguageModel? language,
  }) async {
    final query = (word ?? wordController.text).trim();
    final searchLanguage = language ?? selectedLanguage;
    if (query.isEmpty) throw Exception('Type a word to look up.');

    isLoading = true;
    notifyListeners();
    try {
      final result = await _repository.fetchWordDetails(
        word: query,
        languageCode: searchLanguage.code,
      );
      searchedWord = result;
      await _addToRecentSearches(query, searchLanguage);
      return result;
    } catch (error, stackTrace) {
      ApiLogger.error(
        operation: 'Dictionary search ($query / ${searchLanguage.code})',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<DictionaryModel> searchRecentSearch(RecentSearchModel recent) {
    wordController.text = recent.word;
    return searchWord(
      word: recent.word,
      language: LanguageModel(
        code: recent.languageCode,
        name: recent.languageName,
      ),
    );
  }

  void clearSearchField() {
    wordController.clear();
    notifyListeners();
  }

  // --------------------------------------------------------------- recents

  void _restoreRecentSearches(SharedPreferences prefs) {
    recentSearches = (prefs.getStringList(_recentSearchesKey) ?? [])
        .map(RecentSearchModel.tryParse)
        .whereType<RecentSearchModel>()
        .toList();
  }

  Future<void> _addToRecentSearches(
    String word,
    LanguageModel language,
  ) async {
    final entry = RecentSearchModel(
      word: word,
      languageCode: language.code,
      languageName: language.name,
    );

    recentSearches
      ..removeWhere(entry.sameAs)
      ..insert(0, entry);
    if (recentSearches.length > _maxRecentSearches) {
      recentSearches = recentSearches.sublist(0, _maxRecentSearches);
    }
    notifyListeners();
    await _persistRecentSearches();
  }

  Future<void> removeFromRecentSearches(RecentSearchModel recent) async {
    recentSearches.removeWhere(recent.sameAs);
    notifyListeners();
    await _persistRecentSearches();
  }

  Future<void> clearRecentSearches() async {
    recentSearches = [];
    notifyListeners();
    await _persistRecentSearches();
  }

  Future<void> _persistRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _recentSearchesKey,
      recentSearches.map((recent) => recent.toRawJson()).toList(),
    );
  }

  // ----------------------------------------------------------- pronunciation

  Future<void> speakWordOfTheDay() async {
    final word = wordOfTheDay?.word;
    if (word == null || word.isEmpty) return;

    isAudioLoading = true;
    notifyListeners();
    try {
      await PronunciationService.instance.speak(
        text: word,
        languageCode: wordOfTheDayLanguageCode,
      );
    } finally {
      isAudioLoading = false;
      notifyListeners();
    }
  }

  // ------------------------------------------------------------------ extras

  void _loadWordStories() {
    wordStories = AppResources.wordStoryblogs
        .map((story) => WordStoriesModel.fromJson(story))
        .toList();
  }

  @override
  void dispose() {
    wordController.removeListener(_onTextChanged);
    wordController.dispose();
    super.dispose();
  }
}
