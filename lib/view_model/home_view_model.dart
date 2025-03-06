import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_dictionary/data/exception/app_exceptions.dart';
import 'package:easy_dictionary/models/word_stories_model.dart';
import 'package:easy_dictionary/utils/resources/app_resources.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/dictionary_model.dart';
import '../../repository/dictionary_repo.dart';

class HomeViewModel extends ChangeNotifier {
  final _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  // Text controller for input field
  final TextEditingController wordController = TextEditingController();
  // Stores the "Word of the Day"
  DictionaryModel? wordOfTheDay;
  // Stores the searched word result
  DictionaryModel? searchedWord;
  //stores blog
  List<WordStoriesModel> wordStories = [];
  // Keeps track of recent searches
  List<String> recentSearches = [];
  // Loading state for API calls
  bool isLoading = false;
  // Loading indicator for wordOfTheDay
  bool isWordLoading = false;
  // blog loader
  bool isBlogLoading = false;
  //audio loader
  bool isAudioLoading = false;

  //error in loading wod
  String? errorMessageForWOD;

  HomeViewModel() {
    wordController.addListener(_onTextChanged);
    fetchWordOfTheDay();
    _loadRecentSearches();
    fetchWordStoriesModel();
    loadBlogs();
  }

  // Notifies UI when the search field text changes
  void _onTextChanged() {
    notifyListeners();
  }

  // Returns true if the search button should be visible
  bool get isSearchButtonVisible => wordController.text.isNotEmpty;

  Future loadBlogs() async {
    isBlogLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 3));
    isBlogLoading = false;
    notifyListeners();
  }

  Future<void> searchRecentSearches(String word) async {
    wordController.text = word;
    notifyListeners();
    await searchWord();
  }

  /// **Fetches the "Word of the Day" from API**
  Future<void> fetchWordOfTheDay() async {
    isWordLoading = true;
    notifyListeners();
    String wordOfDay = AppResources.getWordOfTheDay();
    try {
      dynamic response =
          await DictionaryRepo().fetchWordDetailsApi(word: wordOfDay);
      wordOfTheDay = DictionaryModel.fromJson(response.first);
      errorMessageForWOD = null;
      notifyListeners();
    } catch (e) {
      errorMessageForWOD = e.toString();
      notifyListeners();
      // rethrow;
    } finally {
      isWordLoading = false;
      notifyListeners();
    }
  }

  void fetchWordStoriesModel() {
    for (var wordStory in AppResources.wordStoryblogs) {
      wordStories.add(WordStoriesModel.fromJson(wordStory));
    }
    notifyListeners();
  }

  Future<void> playAudio() async {
    String? audioUrl = wordOfTheDay?.phonetics
        .firstWhere((phonetic) => phonetic.audio != null,
            orElse: () => Phonetic(audio: ""))
        .audio;

    if (!_isPlaying) {
      if (audioUrl != null && audioUrl.isNotEmpty) {
        isAudioLoading = true;
        notifyListeners();
        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult.contains(ConnectivityResult.none)) {
          isAudioLoading = false;
          notifyListeners();
          throw AudioUnableToPlayException();
        }
        await _audioPlayer.setSourceUrl(audioUrl).then((val) {
          _audioPlayer.resume();
          _isPlaying = true;
          isAudioLoading = false;
          notifyListeners();
        }).timeout(
          const Duration(seconds: 8),
          onTimeout: () {
            isAudioLoading = false;
            _isPlaying = false;
            notifyListeners();
            throw AudioUnableToPlayException();
          },
        );

        _audioPlayer.onPlayerComplete.listen(cancelOnError: true, (_) {
          _isPlaying = false;
          notifyListeners();
        });
      } else {
        throw AudioNotAvailableException();
      }
    }
  }

  /// **Searches for a word and updates the UI**
  Future<void> searchWord() async {
    if (wordController.text.isEmpty) return;
    isLoading = true;
    notifyListeners();

    try {
      dynamic response =
          await DictionaryRepo().fetchWordDetailsApi(word: wordController.text);
      searchedWord = DictionaryModel.fromJson(response.first);
      if (searchedWord != null) {
        _addToRecentSearches(wordController.text);
      } else {}
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// **Loads recent searches from local storage**
  Future<void> _loadRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    recentSearches = prefs.getStringList('recentSearches') ?? [];
    notifyListeners();
  }

  /// **Adds a new search to the recent list**
  Future<void> _addToRecentSearches(String word) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!recentSearches.contains(word)) {
      recentSearches.insert(0, word);

      // Keep only the last 5 searches
      if (recentSearches.length > 5) {
        recentSearches = recentSearches.sublist(0, 5);
      }

      prefs.setStringList('recentSearches', recentSearches);
      notifyListeners();
    }
  }

  Future<void> removeFromRecentSearches(String word) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (recentSearches.contains(word)) {
      recentSearches.remove(word);
      prefs.setStringList('recentSearches', recentSearches);
      notifyListeners();
    }
  }
}
