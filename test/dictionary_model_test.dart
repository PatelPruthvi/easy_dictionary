import 'package:easy_dictionary/models/dictionary_model.dart';
import 'package:flutter_test/flutter_test.dart';

const _helloResponse = {
  'word': 'hello',
  'entries': [
    {
      'language': {'code': 'en', 'name': 'English'},
      'partOfSpeech': 'interjection',
      'pronunciations': [
        {
          'type': 'ipa',
          'text': '/hɛˈloʊ/',
          'tags': ['General American'],
        },
        {
          'type': 'ipa',
          'text': '/həˈləʊ/',
          'tags': ['Received Pronunciation'],
        },
      ],
      'forms': [
        {
          'word': 'hullo',
          'tags': ['alternative', 'UK'],
        },
      ],
      'senses': [
        {
          'definition': 'A greeting said when meeting someone.',
          'tags': <String>[],
          'examples': ['Hello, everyone.'],
          'quotes': [
            {'text': 'I commenced to whoop "Hello!"', 'reference': '1913'},
          ],
          'synonyms': <String>[],
          'antonyms': <String>[],
          'subsenses': <Map<String, dynamic>>[],
        },
        {
          'definition': 'An expression of puzzlement.',
          'tags': ['UK'],
          'examples': <String>[],
          'quotes': <Map<String, dynamic>>[],
          'synonyms': ['eh'],
          'antonyms': <String>[],
          'subsenses': [
            {
              'definition': 'A sarcastic call for attention.',
              'tags': ['colloquial'],
              'examples': ['Hello? Is anyone there?'],
              'synonyms': ['oi'],
            },
          ],
        },
      ],
      'synonyms': ['hi', 'hey', 'hi'],
      'antonyms': ['bye'],
    },
    {
      'language': {'code': 'en', 'name': 'English'},
      'partOfSpeech': 'noun',
      'pronunciations': [
        {
          'type': 'ipa',
          'text': '/hɛˈloʊ/',
          'tags': ['General American'],
        },
      ],
      'forms': [
        {
          'word': 'hellos',
          'tags': ['plural'],
        },
        {
          'word': 'hullo',
          'tags': ['alternative', 'UK'],
        },
      ],
      'senses': [
        {'definition': '"Hello!" or an equivalent greeting.'},
      ],
    },
  ],
  'source': {
    'url': 'https://en.wiktionary.org/wiki/hello',
    'license': {'name': 'CC BY-SA 4.0', 'url': 'https://example.com/licence'},
  },
};

void main() {
  group('DictionaryModel.fromJson', () {
    final model = DictionaryModel.fromJson(Map<String, dynamic>.from(
      _helloResponse,
    ));

    test('keeps one entry per part of speech', () {
      expect(model.word, 'hello');
      expect(model.hasEntries, isTrue);
      expect(
        model.entries.map((entry) => entry.partOfSpeech),
        ['interjection', 'noun'],
      );
      expect(model.language?.name, 'English');
    });

    test('de-duplicates pronunciations across entries', () {
      expect(
        model.pronunciations.map((pronunciation) => pronunciation.text),
        ['/hɛˈloʊ/', '/həˈləʊ/'],
      );
      expect(model.primaryPronunciation, '/hɛˈloʊ/');
      expect(model.pronunciations.first.accent, 'General American');
    });

    test('exposes the first definition as a preview', () {
      expect(
        model.previewDefinition,
        'A greeting said when meeting someone.',
      );
    });

    test('parses senses with tags, examples, quotes and subsenses', () {
      final senses = model.entries.first.senses;
      expect(senses, hasLength(2));
      expect(senses.first.examples, ['Hello, everyone.']);
      expect(senses.first.quotes.single.reference, '1913');
      expect(senses.last.tags, ['UK']);
      expect(senses.last.subsenses.single.tags, ['colloquial']);
    });

    test('merges sense level synonyms into the entry list without repeats',
        () {
      expect(model.entries.first.allSynonyms, ['hi', 'hey', 'eh', 'oi']);
      expect(model.entries.first.allAntonyms, ['bye']);
    });

    test('de-duplicates forms across entries', () {
      expect(
        model.forms.map((form) => '${form.word}:${form.label}'),
        ['hullo:alternative · UK', 'hellos:plural'],
      );
    });

    test('labels entries, leaving unique parts of speech alone', () {
      expect(model.entryLabels, ['interjection', 'noun']);
      expect(model.partsOfSpeech, ['interjection', 'noun']);
    });

    test('reads the source and licence', () {
      expect(model.source?.url, 'https://en.wiktionary.org/wiki/hello');
      expect(model.source?.license?.name, 'CC BY-SA 4.0');
    });

    test('survives a round trip through JSON, as the daily cache does', () {
      final restored = DictionaryModel.fromRawJson(model.toRawJson());
      expect(restored.word, model.word);
      expect(restored.entries, hasLength(model.entries.length));
      expect(restored.previewDefinition, model.previewDefinition);
      expect(
        restored.entries.first.senses.first.quotes.single.text,
        model.entries.first.senses.first.quotes.single.text,
      );
    });
  });

  test('entries sharing a part of speech are numbered apart', () {
    // "lune" really does come back as three separate noun etymologies.
    final model = DictionaryModel.fromJson({
      'word': 'lune',
      'entries': [
        {'partOfSpeech': 'noun'},
        {'partOfSpeech': 'noun'},
        {'partOfSpeech': 'verb'},
        {'partOfSpeech': 'noun'},
      ],
    });

    expect(model.entryLabels, ['noun 1', 'noun 2', 'verb', 'noun 3']);
    expect(model.partsOfSpeech, ['noun', 'verb']);
  });

  test('a response without entries is reported as empty', () {
    final model = DictionaryModel.fromJson({
      'word': 'notaword123',
      'entries': <dynamic>[],
      'source': {'url': 'https://en.wiktionary.org'},
    });

    expect(model.hasEntries, isFalse);
    expect(model.pronunciations, isEmpty);
    expect(model.previewDefinition, isNull);
    expect(model.language, isNull);
  });

  test('missing and malformed fields fall back to safe defaults', () {
    final model = DictionaryModel.fromJson({
      'entries': [
        {'senses': null, 'synonyms': [1, 'ok', null]},
      ],
    });

    expect(model.word, 'Unknown');
    expect(model.entries.single.partOfSpeech, 'unknown');
    expect(model.entries.single.senses, isEmpty);
    expect(model.entries.single.synonyms, ['ok']);
    expect(model.source, isNull);
  });
}
