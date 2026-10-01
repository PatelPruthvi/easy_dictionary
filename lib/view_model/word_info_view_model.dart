import 'package:easy_dictionary/data/exception/app_exceptions.dart';
import 'package:easy_dictionary/data/pronunciation/pronunciation_service.dart';
import 'package:easy_dictionary/models/dictionary_model.dart';
import 'package:easy_dictionary/repository/dictionary_repo.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'safe_notifier.dart';

class WordInfoViewModel extends ChangeNotifier with SafeNotifier {
  WordInfoViewModel({
    required this.wordInfoModel,
    DictionaryRepo? repository,
  }) : _repository = repository ?? DictionaryRepo();

  final DictionaryModel wordInfoModel;
  final DictionaryRepo _repository;

  /// Index into [DictionaryModel.entries] - one entry per part of speech.
  int entryIndex = 0;
  bool isAudioLoading = false;

  /// Set while a tapped synonym / antonym is being looked up.
  bool isLookupLoading = false;

  /// Sense indexes whose quotations are expanded.
  final Set<String> _expandedQuotes = {};

  WordEntry get currentEntry => wordInfoModel.entries[entryIndex];

  /// Part of speech of the open entry, numbered when it is not unique.
  String get currentEntryLabel => wordInfoModel.entryLabels[entryIndex];

  String get languageCode => wordInfoModel.language?.code ?? 'en';

  void changeEntryIndex(int index) {
    if (index == entryIndex || index < 0 || index >= wordInfoModel.entries.length) {
      return;
    }
    entryIndex = index;
    notifyListeners();
  }

  bool isQuotesExpanded(String senseKey) => _expandedQuotes.contains(senseKey);

  void toggleQuotes(String senseKey) {
    if (!_expandedQuotes.remove(senseKey)) _expandedQuotes.add(senseKey);
    notifyListeners();
  }

  Future<void> speak([String? text]) async {
    isAudioLoading = true;
    notifyListeners();
    try {
      await PronunciationService.instance.speak(
        text: text ?? wordInfoModel.word,
        languageCode: languageCode,
      );
    } finally {
      isAudioLoading = false;
      notifyListeners();
    }
  }

  /// Looks up a related word (synonym, antonym, form) in the same language.
  Future<DictionaryModel> lookupRelated(String word) async {
    isLookupLoading = true;
    notifyListeners();
    try {
      return await _repository.fetchWordDetails(
        word: word,
        languageCode: languageCode,
      );
    } finally {
      isLookupLoading = false;
      notifyListeners();
    }
  }

  Future<void> openUrl(String url) async {
    if (url.trim().isEmpty) throw UrlCannotLaunchException();
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw UrlCannotLaunchException();
    }
  }

}
