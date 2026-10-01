import '../../models/language_model.dart';

class AppResources {
  /// Shown as the default search language and the Word of the Day language.
  static const LanguageModel defaultLanguage =
      LanguageModel(code: 'en', name: 'English', words: 1365322);

  /// Used when `GET /languages` cannot be reached, so the picker is never empty.
  static const List<LanguageModel> fallbackLanguages = [
    defaultLanguage,
    LanguageModel(code: 'es', name: 'Spanish'),
    LanguageModel(code: 'fr', name: 'French'),
    LanguageModel(code: 'de', name: 'German'),
    LanguageModel(code: 'it', name: 'Italian'),
    LanguageModel(code: 'pt', name: 'Portuguese'),
    LanguageModel(code: 'nl', name: 'Dutch'),
    LanguageModel(code: 'ru', name: 'Russian'),
    LanguageModel(code: 'pl', name: 'Polish'),
    LanguageModel(code: 'la', name: 'Latin'),
    LanguageModel(code: 'sv', name: 'Swedish'),
    LanguageModel(code: 'hi', name: 'Hindi'),
    LanguageModel(code: 'ja', name: 'Japanese'),
    LanguageModel(code: 'zh', name: 'Chinese'),
    LanguageModel(code: 'ar', name: 'Arabic'),
    LanguageModel(code: 'ko', name: 'Korean'),
    LanguageModel(code: 'tr', name: 'Turkish'),
  ];

  /// Language codes offered as quick picks above the full list.
  static const List<String> suggestedLanguageCodes = [
    'en', 'es', 'fr', 'de', 'it', 'pt', 'hi', 'ja',
  ];

  /// Curated words that back the Word of the Day when the random word API is
  /// unreachable or keeps returning words the dictionary does not know.
  static const List<String> wordOfTheDayList = [
    "Benevolent",
    "Candid",
    "sad",
    "Eloquent",
    "Facetious",
    "Gracious",
    "Hapless",
    "Inept",
    "Jovial",
    "Keen",
    "Lucid",
    "Meticulous",
    "Nimble",
    "Obscure",
    "Prudent",
    "Quirky",
    "Resilient",
    "Savvy",
    "Tactful",
    "Unravel",
    "Vivid",
    "Wistful",
    "Yearn",
    "Zealous",
    "Adorn",
    "Brisk",
    "Clever",
    "Diligent",
    "Earnest",
    "Fickle",
    "Gleeful",
    "Humble",
    "Inventive",
    "Jaunty",
    "Kudos",
    "Luminous",
    "Modest",
    "Nurture",
    "Optimistic",
    "Peculiar",
    "Quaint",
    "Rejoice",
    "Sincere",
    "Tranquil",
    "Uplift",
    "Venture",
    "Whimsical",
    "Yield",
    "Zephyr",
    "Abound",
    "Bravado",
    "Cordial",
    "Deft",
    "Eager",
    "Finesse",
    "Gallant",
    "Hustle",
    "Impeccable",
    "Jubilant",
    "Kinship",
    "Lush",
    "Mirth",
    "Notion",
    "Opulent",
    "Perceptive",
    "Quench",
    "Radiant",
    "Stellar",
    "Tangible",
    "Upbeat",
    "Vivacious",
    "Witty",
    "Yonder",
    "Zesty",
    "Amiable",
    "Buoyant",
    "Charming",
    "Dainty",
    "Eminent",
    "Frugal",
    "Genial",
    "Harmonious",
    "Ingenious",
    "Jocular",
    "Kinetic",
    "Lavish",
    "Meander",
    "Nostalgic",
    "Obliging",
    "Placid",
    "Quicken",
    "Repose",
    "Snug",
    "Tactile",
    "Unison",
    "Versatile",
    "Winsome",
    "Yen",
    "Zenith"
  ];
  /// A stable-per-day pick from [wordOfTheDayList].
  static String fallbackWordOfTheDay([DateTime? now]) {
    final today = now ?? DateTime.now();
    final dayOfYear =
        today.difference(DateTime(today.year)).inDays;
    return wordOfTheDayList[dayOfYear % wordOfTheDayList.length];
  }

  static const List<Map<String, String>> wordStoryblogs = [
    {
      "title": "Etymology: The Hidden History of Words",
      "content":
          "Etymology is the study of word origins. Many English words come from Latin, Greek, and Old English. For example, 'hospital' comes from the Latin 'hospes', meaning 'guest' or 'host'. Understanding a word's history can help in memorizing its meaning and spelling. Exploring word roots also reveals surprising connections between languages.",
      "reading_time": "6 min"
    },
    {
      "title": "Pronunciation Challenges: Why Some Words Are Hard to Say",
      "content":
          "Some English words are tricky to pronounce because of irregular spelling rules. Words like 'colonel' (pronounced 'kernel') and 'Wednesday' (pronounced 'Wenz-day') don’t match their spelling. Silent letters, vowel shifts, and borrowed words from other languages contribute to these challenges. Phonetics and listening practice can help improve pronunciation.",
      "reading_time": "7 min"
    },
    {
      "title": "How Dictionaries Evolve: New Words and Changing Meanings",
      "content":
          "Dictionaries are updated regularly as language evolves. Words like 'selfie' and 'emoji' were added recently due to their widespread use. Some words also change meaning over time—'awful' once meant 'full of awe' but now means 'very bad'. Understanding language evolution helps us appreciate the dynamic nature of words.",
      "reading_time": "8 min"
    },
    {
      "title": "The Small Habit That Makes New Words Stick",
      "content":
          "Meeting a new word once rarely makes it part of your vocabulary. Try a three-step routine: notice the word in a sentence, write a sentence of your own, then bring it back a day later without looking. For example, if you learn 'nimble', you might write, 'Her nimble fingers repaired the watch.' The effort of retrieving a word strengthens the memory more than rereading a list. Keep the routine brief and attach it to something you already do, such as reviewing notes after breakfast.",
      "reading_time": "3 min"
    }
  ];
}
