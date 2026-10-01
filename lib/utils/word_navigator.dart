import 'package:flutter/material.dart';

import '../data/exception/app_exceptions.dart';
import '../models/dictionary_model.dart';
import '../models/recent_search_model.dart';
import '../view_model/home_view_model.dart';
import '../views/word_info_view/word_info_view.dart';
import 'utils.dart';

/// Runs a lookup and pushes the detail screen, reporting failures as a toast.
///
/// Every entry point into the detail screen (search field, search button,
/// recent chip, word of the day) funnels through here so the error handling and
/// the `mounted` guards live in one place.
class WordNavigator {
  const WordNavigator._();

  static Future<void> search(
    BuildContext context,
    HomeViewModel viewModel, {
    RecentSearchModel? recent,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      final result = recent == null
          ? await viewModel.searchWord()
          : await viewModel.searchRecentSearch(recent);
      if (!context.mounted) return;
      viewModel.clearSearchField();
      await open(context, result);
    } catch (error) {
      if (!context.mounted) return;
      Utils.showError(
        context,
        title: _titleFor(error),
        message: error.toString(),
      );
    }
  }

  static Future<void> open(BuildContext context, DictionaryModel model) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => WordInfoView(wordInfoModel: model)),
    );
  }

  static String _titleFor(Object error) => switch (error) {
        DefinitionNotFoundException() => 'No definitions found',
        TimeoutException() => 'Request timed out',
        NetworkException() => 'You appear to be offline',
        RateLimiterException() => 'Slow down a little',
        _ => 'Search failed',
      };
}
