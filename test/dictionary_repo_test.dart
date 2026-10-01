import 'package:easy_dictionary/data/exception/app_exceptions.dart';
import 'package:easy_dictionary/data/network/base_api_service.dart';
import 'package:easy_dictionary/repository/dictionary_repo.dart';
import 'package:flutter_test/flutter_test.dart';

/// Returns canned payloads keyed by a substring of the requested URL.
class _FakeApiService extends BaseApiService {
  _FakeApiService(this.responses);

  final Map<String, dynamic> responses;
  final List<String> requestedUrls = [];

  @override
  Future<dynamic> getGetApiResponse({required String url}) async {
    requestedUrls.add(url);
    for (final entry in responses.entries) {
      if (url.contains(entry.key)) return entry.value;
    }
    throw ServerException();
  }
}

void main() {
  group('fetchWordDetails', () {
    test('requests the selected language and parses the entries', () async {
      final api = _FakeApiService({
        'entries/fr/bonjour': {
          'word': 'bonjour',
          'entries': [
            {
              'language': {'code': 'fr', 'name': 'French'},
              'partOfSpeech': 'interjection',
              'senses': [
                {'definition': 'hello'},
              ],
            },
          ],
        },
      });

      final model = await DictionaryRepo(apiService: api).fetchWordDetails(
        word: '  bonjour ',
        languageCode: 'fr',
      );

      expect(model.word, 'bonjour');
      expect(model.language?.code, 'fr');
      expect(api.requestedUrls.single, endsWith('/entries/fr/bonjour'));
    });

    test('percent-encodes words that are not URL safe', () async {
      final api = _FakeApiService({
        'entries/de/': {
          'word': 'grüßen',
          'entries': [
            {'partOfSpeech': 'verb'},
          ],
        },
      });

      await DictionaryRepo(apiService: api)
          .fetchWordDetails(word: 'grüßen', languageCode: 'de');

      expect(api.requestedUrls.single, contains('gr%C3%BC%C3%9Fen'));
    });

    test('treats an empty entry list as "not found"', () async {
      // The API answers unknown words with 200 and no entries rather than 404.
      final api = _FakeApiService({
        'entries/en/notaword123': {
          'word': 'notaword123',
          'entries': <dynamic>[],
        },
      });

      expect(
        () => DictionaryRepo(apiService: api)
            .fetchWordDetails(word: 'notaword123', languageCode: 'en'),
        throwsA(isA<DefinitionNotFoundException>()),
      );
    });

    test('rejects a payload that is not an object', () async {
      final api = _FakeApiService({'entries/en/x': <dynamic>[]});

      expect(
        () => DictionaryRepo(apiService: api)
            .fetchWordDetails(word: 'x', languageCode: 'en'),
        throwsA(isA<DefinitionNotFoundException>()),
      );
    });
  });

  group('fetchLanguages', () {
    test('parses codes, names and word counts', () async {
      final api = _FakeApiService({
        'languages': [
          {'code': 'en', 'name': 'English', 'words': 1365322},
          {'code': 'la', 'name': 'Latin', 'words': 833841},
          {'code': '', 'name': 'Broken', 'words': 1},
        ],
      });

      final languages = await DictionaryRepo(apiService: api).fetchLanguages();

      expect(languages.map((language) => language.code), ['en', 'la']);
      expect(languages.first.wordCountLabel, '1.4M words');
    });

    test('fails when the list comes back empty', () async {
      final api = _FakeApiService({'languages': <dynamic>[]});

      expect(
        () => DictionaryRepo(apiService: api).fetchLanguages(),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('fetchRandomWords', () {
    test('unwraps the array and drops blanks', () async {
      final api = _FakeApiService({
        'random-word-api': ['vibrating', '  ', 'triton', 42],
      });

      final words = await DictionaryRepo(apiService: api).fetchRandomWords();

      expect(words, ['vibrating', 'triton']);
      expect(api.requestedUrls.single, contains('number=5'));
    });
  });
}
