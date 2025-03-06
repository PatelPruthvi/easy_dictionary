class AppResources {
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
  static String getWordOfTheDay() {
    int index = DateTime.now().day % wordOfTheDayList.length;
    return wordOfTheDayList[index];
  }

  static const List<Map<String, String>> wordStoryblogs = [
    {
      "title": "The Importance of Context in Word Definitions",
      "content":
          "A word's meaning can change depending on context. For example, 'light' can mean 'not heavy' (adjective) or 'a source of illumination' (noun). Words also take on figurative meanings, like 'a bright student' (intelligent, not literally glowing). Understanding context helps in choosing the right word and avoiding misinterpretation.",
      "reading_time": "4 min"
    },
    {
      "title": "Phonetics: Why Do Words Sound Different Than They Look?",
      "content":
          "Phonetics is the study of speech sounds. English pronunciation often differs from spelling because words come from multiple languages, leading to silent letters and varied pronunciations. For example, 'knight' has a silent 'k' due to historical changes in speech patterns. Phonetic transcriptions, like /nait/ for 'night', help learners pronounce words correctly.",
      "reading_time": "4 min"
    },
    {
      "title": "What Are Homophones, and Why Do They Cause Confusion?",
      "content":
          "Homophones are words that sound the same but have different meanings and spellings, like 'their', 'there', and 'they're'. They often cause spelling mistakes and misunderstandings. Knowing the meaning and context of homophones helps in clear writing. A simple trick: 'there' relates to location, 'their' shows possession, and 'they're' is a contraction of 'they are'.",
      "reading_time": "5 min"
    },
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
    }
  ];
}
