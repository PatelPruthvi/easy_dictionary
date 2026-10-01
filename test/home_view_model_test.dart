import 'package:easy_dictionary/data/exception/app_exceptions.dart';
import 'package:easy_dictionary/data/network/base_api_service.dart';
import 'package:easy_dictionary/models/language_model.dart';
import 'package:easy_dictionary/repository/dictionary_repo.dart';
import 'package:easy_dictionary/utils/resources/app_resources.dart';
import 'package:easy_dictionary/view_model/home_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Serves entry payloads for a fixed set of known words and 200-with-no-entries
/// for everything else, which is how the real API reports unknown words.
class _FakeApiService extends BaseApiService {
  _FakeApiService({
    this.knownWords = const {'hello'},
    this.randomWords = const ['vibrating'],
    this.failRandomWords = false,
    this.failLanguages = false,
  });

  final Set<String> knownWords;
  final List<String> randomWords;
  final bool failRandomWords;
  final bool failLanguages;
  final List<String> requestedUrls = [];

  @override
  Future<dynamic> getGetApiResponse({required String url}) async {
    requestedUrls.add(url);

    if (url.contains('random-word-api')) {
      if (failRandomWords) throw ServerException();
      return randomWords;
    }
    if (url.endsWith('/languages')) {
      if (failLanguages) throw ServerException();
      return [
        {'code': 'en', 'name': 'English', 'words': 1365322},
        {'code': 'fr', 'name': 'French', 'words': 387833},
      ];
    }

    final word = Uri.decodeComponent(url.split('/').last);
    if (!knownWords.contains(word.toLowerCase())) {
      return {'word': word, 'entries': <dynamic>[]};
    }
    return {
      'word': word,
      'entries': [
        {
          'language': {'code': 'en', 'name': 'English'},
          'partOfSpeech': 'interjection',
          'senses': [
            {'definition': 'A greeting.'},
          ],
        },
      ],
    };
  }
}

/// Builds a view model and waits for the work kicked off in its constructor.
Future<HomeViewModel> _buildViewModel(_FakeApiService api) async {
  final viewModel = HomeViewModel(repository: DictionaryRepo(apiService: api));
  addTearDown(viewModel.dispose);
  await pumpEventQueue();
  return viewModel;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('word of the day', () {
    test('uses a word from the random word API', () async {
      final api = _FakeApiService(
        knownWords: {'vibrating'},
        randomWords: ['vibrating'],
      );
      final viewModel = await _buildViewModel(api);

      expect(viewModel.wordOfTheDay?.word, 'vibrating');
      expect(viewModel.errorMessageForWOD, isNull);
      expect(viewModel.isWordLoading, isFalse);
    });

    test('skips random words the dictionary does not know', () async {
      final api = _FakeApiService(
        knownWords: {'triton'},
        randomWords: ['tats', 'flubbed', 'triton'],
      );
      final viewModel = await _buildViewModel(api);

      expect(viewModel.wordOfTheDay?.word, 'triton');
    });

    test('falls back to the curated list when every random word fails',
        () async {
      final fallback = AppResources.fallbackWordOfTheDay();
      final api = _FakeApiService(
        knownWords: {fallback.toLowerCase()},
        randomWords: ['tats', 'flubbed'],
      );
      final viewModel = await _buildViewModel(api);

      expect(viewModel.wordOfTheDay?.word, fallback);
    });

    test('falls back to the curated list when the random API is down',
        () async {
      final fallback = AppResources.fallbackWordOfTheDay();
      final api = _FakeApiService(
        knownWords: {fallback.toLowerCase()},
        failRandomWords: true,
      );
      final viewModel = await _buildViewModel(api);

      expect(viewModel.wordOfTheDay?.word, fallback);
    });

    test('reports an error only when nothing can be resolved', () async {
      final api = _FakeApiService(knownWords: const {}, randomWords: const []);
      final viewModel = await _buildViewModel(api);

      expect(viewModel.wordOfTheDay, isNull);
      expect(viewModel.errorMessageForWOD, isNotNull);
    });

    test('reuses the cached word for the rest of the day', () async {
      final api = _FakeApiService(
        knownWords: {'vibrating'},
        randomWords: ['vibrating'],
      );
      await _buildViewModel(api);

      final second = _FakeApiService(
        knownWords: {'spurner'},
        randomWords: ['spurner'],
      );
      final viewModel = await _buildViewModel(second);

      expect(viewModel.wordOfTheDay?.word, 'vibrating');
      expect(
        second.requestedUrls.where((url) => url.contains('random-word-api')),
        isEmpty,
      );
    });

    test('a forced refresh ignores the cache', () async {
      final api = _FakeApiService(
        knownWords: {'vibrating'},
        randomWords: ['vibrating'],
      );
      await _buildViewModel(api);

      final second = _FakeApiService(
        knownWords: {'spurner'},
        randomWords: ['spurner'],
      );
      final viewModel = await _buildViewModel(second);
      await viewModel.fetchWordOfTheDay(forceRefresh: true);

      expect(viewModel.wordOfTheDay?.word, 'spurner');
    });

    test('a shuffled word becomes the word for the rest of the day', () async {
      final api = _FakeApiService(
        knownWords: {'vibrating'},
        randomWords: ['vibrating'],
      );
      await _buildViewModel(api);

      final shuffled = _FakeApiService(
        knownWords: {'spurner'},
        randomWords: ['spurner'],
      );
      final viewModel = await _buildViewModel(shuffled);
      await viewModel.shuffleWordOfTheDay();
      expect(viewModel.wordOfTheDay?.word, 'spurner');

      // Reopening the app keeps the shuffled word instead of drawing again.
      final reopened = _FakeApiService(
        knownWords: {'triton'},
        randomWords: ['triton'],
      );
      final restored = await _buildViewModel(reopened);

      expect(restored.wordOfTheDay?.word, 'spurner');
      expect(
        reopened.requestedUrls.where((url) => url.contains('random-word-api')),
        isEmpty,
      );
    });

    test('a stale cache is shown when today lookup fails', () async {
      SharedPreferences.setMockInitialValues({
        'wordOfTheDayDate': '1999-1-1',
        'wordOfTheDayPayload':
            '{"word":"yesterday","entries":[{"partOfSpeech":"noun",'
                '"senses":[{"definition":"The day before."}]}]}',
      });

      final api = _FakeApiService(knownWords: const {}, randomWords: const []);
      final viewModel = await _buildViewModel(api);

      expect(viewModel.wordOfTheDay?.word, 'yesterday');
      expect(viewModel.errorMessageForWOD, isNull);
    });
  });

  group('languages', () {
    test('replaces the fallback list once the API responds', () async {
      final viewModel = await _buildViewModel(_FakeApiService());

      expect(viewModel.languages.map((l) => l.code), ['en', 'fr']);
      expect(viewModel.isLanguagesLoading, isFalse);
    });

    test('keeps the fallback list when the API fails', () async {
      final viewModel =
          await _buildViewModel(_FakeApiService(failLanguages: true));

      expect(viewModel.languages, AppResources.fallbackLanguages);
    });

    test('the selected language is persisted and restored', () async {
      final viewModel = await _buildViewModel(_FakeApiService());
      await viewModel
          .selectLanguage(const LanguageModel(code: 'fr', name: 'French'));

      final restored = await _buildViewModel(_FakeApiService());
      expect(restored.selectedLanguage.code, 'fr');
    });
  });

  group('search', () {
    test('looks the word up in the selected language', () async {
      final api = _FakeApiService();
      final viewModel = await _buildViewModel(api);
      await viewModel
          .selectLanguage(const LanguageModel(code: 'fr', name: 'French'));

      viewModel.wordController.text = 'hello';
      await viewModel.searchWord();

      expect(viewModel.searchedWord?.word, 'hello');
      expect(
        api.requestedUrls.last,
        endsWith('/entries/fr/hello'),
      );
    });

    test('an unknown word throws and is not recorded as recent', () async {
      final viewModel = await _buildViewModel(_FakeApiService());
      viewModel.wordController.text = 'notaword123';

      await expectLater(
        viewModel.searchWord(),
        throwsA(isA<DefinitionNotFoundException>()),
      );
      expect(viewModel.recentSearches, isEmpty);
      expect(viewModel.isLoading, isFalse);
    });

    test('recent searches remember their language and stay unique', () async {
      final viewModel = await _buildViewModel(_FakeApiService());

      viewModel.wordController.text = 'hello';
      await viewModel.searchWord();
      await viewModel
          .selectLanguage(const LanguageModel(code: 'fr', name: 'French'));
      await viewModel.searchWord(word: 'hello');
      await viewModel.searchWord(word: 'hello');

      expect(viewModel.recentSearches, hasLength(2));
      expect(viewModel.recentSearches.first.languageCode, 'fr');
      expect(viewModel.recentSearches.last.languageCode, 'en');
    });

    test('recent searches survive a restart', () async {
      final viewModel = await _buildViewModel(_FakeApiService());
      viewModel.wordController.text = 'hello';
      await viewModel.searchWord();

      final restored = await _buildViewModel(_FakeApiService());
      expect(restored.recentSearches.single.word, 'hello');
    });

    test('plain string recents written by older builds are read as English',
        () async {
      SharedPreferences.setMockInitialValues({
        'recentSearches': ['legacyword'],
      });

      final viewModel = await _buildViewModel(_FakeApiService());

      expect(viewModel.recentSearches.single.word, 'legacyword');
      expect(viewModel.recentSearches.single.languageCode, 'en');
    });

    test('removing and clearing recents persists', () async {
      final viewModel = await _buildViewModel(_FakeApiService());
      viewModel.wordController.text = 'hello';
      await viewModel.searchWord();

      await viewModel
          .removeFromRecentSearches(viewModel.recentSearches.single);
      expect(viewModel.recentSearches, isEmpty);

      final restored = await _buildViewModel(_FakeApiService());
      expect(restored.recentSearches, isEmpty);
    });
  });
}
