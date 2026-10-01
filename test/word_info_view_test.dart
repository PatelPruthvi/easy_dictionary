import 'package:easy_dictionary/models/dictionary_model.dart';
import 'package:easy_dictionary/utils/theme/app_theme.dart';
import 'package:easy_dictionary/views/word_info_view/word_info_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final _model = DictionaryModel.fromJson({
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
      ],
      'senses': [
        {
          'definition': 'A greeting said when meeting someone.',
          'tags': ['colloquial'],
          'examples': ['Hello, everyone.'],
          'quotes': [
            {'text': 'I commenced to whoop "Hello!"', 'reference': '1913'},
          ],
        },
      ],
      'synonyms': ['hi'],
      'antonyms': ['bye'],
    },
    {
      'partOfSpeech': 'noun',
      'forms': [
        {
          'word': 'hellos',
          'tags': ['plural'],
        },
      ],
      'senses': [
        {'definition': 'An equivalent greeting.'},
      ],
    },
  ],
  'source': {
    'url': 'https://en.wiktionary.org/wiki/hello',
    'license': {'name': 'CC BY-SA 4.0', 'url': 'https://example.com'},
  },
});

Future<void> _pumpView(WidgetTester tester) async {
  // Tall surface so the whole entry is laid out without scrolling.
  tester.view.physicalSize = const Size(1100, 4000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(MaterialApp(
    theme: AppTheme.light(),
    home: WordInfoView(wordInfoModel: _model),
  ));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('renders the word, pronunciation and first senses',
      (tester) async {
    await _pumpView(tester);

    expect(find.text('hello'), findsWidgets);
    // The transcription and its accent share one Text.rich span.
    expect(find.textContaining('/hɛˈloʊ/'), findsOneWidget);
    expect(find.textContaining('General American'), findsOneWidget);
    expect(find.text('A greeting said when meeting someone.'), findsOneWidget);
    expect(find.text('Hello, everyone.'), findsOneWidget);
    expect(find.text('colloquial'), findsOneWidget);
  });

  testWidgets('shows synonyms, antonyms, forms and credits', (tester) async {
    await _pumpView(tester);

    expect(find.text('Synonyms'), findsOneWidget);
    expect(find.text('hi'), findsOneWidget);
    expect(find.text('Antonyms'), findsOneWidget);
    expect(find.text('bye'), findsOneWidget);
    expect(find.text('Other Forms'), findsOneWidget);
    expect(find.text('hellos'), findsOneWidget);
    expect(find.textContaining('CC BY-SA 4.0'), findsOneWidget);
  });

  testWidgets('citations stay collapsed until tapped', (tester) async {
    await _pumpView(tester);

    expect(find.text('1 citation'), findsOneWidget);
    expect(find.textContaining('whoop'), findsNothing);

    await tester.tap(find.text('1 citation'));
    await tester.pumpAndSettle();

    expect(find.text('Hide citations'), findsOneWidget);
    expect(find.textContaining('whoop'), findsOneWidget);
  });

  testWidgets('switching part of speech swaps the senses', (tester) async {
    await _pumpView(tester);

    expect(find.text('A greeting said when meeting someone.'), findsOneWidget);
    expect(find.text('An equivalent greeting.'), findsNothing);

    // Open the part-of-speech dropdown, then pick the noun entry.
    await tester.tap(find.byType(DropdownButton<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('noun').last);
    await tester.pumpAndSettle();

    expect(find.text('An equivalent greeting.'), findsOneWidget);
    expect(find.text('A greeting said when meeting someone.'), findsNothing);
  });
}
