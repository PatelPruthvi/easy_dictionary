import 'dart:convert';

/// Response model for `GET /api/v1/entries/{language}/{word}`.
class DictionaryModel {
  final String word;
  final List<WordEntry> entries;
  final DictionarySource? source;

  const DictionaryModel({
    required this.word,
    required this.entries,
    this.source,
  });

  factory DictionaryModel.fromRawJson(String str) =>
      DictionaryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DictionaryModel.fromJson(Map<String, dynamic> json) =>
      DictionaryModel(
        word: json["word"] ?? "Unknown",
        entries: (json["entries"] as List?)
                ?.whereType<Map>()
                .map((x) => WordEntry.fromJson(Map<String, dynamic>.from(x)))
                .toList() ??
            const [],
        source: json["source"] is Map
            ? DictionarySource.fromJson(
                Map<String, dynamic>.from(json["source"]))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "word": word,
        "entries": entries.map((x) => x.toJson()).toList(),
        "source": source?.toJson(),
      };

  bool get hasEntries => entries.isNotEmpty;

  /// The language of the first entry, which the whole response shares.
  LanguageInfo? get language => entries.isEmpty ? null : entries.first.language;

  /// Every distinct IPA transcription across all entries, in API order.
  List<Pronunciation> get pronunciations {
    final seen = <String>{};
    return entries
        .expand((entry) => entry.pronunciations)
        .where((pronunciation) => seen.add(pronunciation.text))
        .toList();
  }

  /// The transcription shown next to the word in headers and cards.
  String? get primaryPronunciation {
    final all = pronunciations;
    return all.isEmpty ? null : all.first.text;
  }

  /// The first definition available, used for compact previews.
  String? get previewDefinition {
    for (final entry in entries) {
      for (final sense in entry.senses) {
        if (sense.definition.isNotEmpty) return sense.definition;
      }
    }
    return null;
  }

  /// Labels for the entry selector.
  ///
  /// A word can have several entries sharing one part of speech (separate
  /// etymologies), so repeated labels are numbered to tell them apart.
  List<String> get entryLabels {
    final totals = <String, int>{};
    for (final entry in entries) {
      totals[entry.partOfSpeech] = (totals[entry.partOfSpeech] ?? 0) + 1;
    }

    final seen = <String, int>{};
    return entries.map((entry) {
      final partOfSpeech = entry.partOfSpeech;
      if ((totals[partOfSpeech] ?? 0) < 2) return partOfSpeech;
      final ordinal = seen[partOfSpeech] = (seen[partOfSpeech] ?? 0) + 1;
      return '$partOfSpeech $ordinal';
    }).toList();
  }

  /// Distinct parts of speech, for summarising an entry list in one line.
  List<String> get partsOfSpeech =>
      entries.map((entry) => entry.partOfSpeech).toSet().toList();

  /// Alternative spellings and inflections, de-duplicated across entries.
  List<WordForm> get forms {
    final seen = <String>{};
    return entries
        .expand((entry) => entry.forms)
        .where((form) => seen.add('${form.word}|${form.tags.join(",")}'))
        .toList();
  }
}

class WordEntry {
  final LanguageInfo? language;
  final String partOfSpeech;
  final List<Pronunciation> pronunciations;
  final List<WordForm> forms;
  final List<Sense> senses;
  final List<String> synonyms;
  final List<String> antonyms;

  const WordEntry({
    this.language,
    required this.partOfSpeech,
    required this.pronunciations,
    required this.forms,
    required this.senses,
    required this.synonyms,
    required this.antonyms,
  });

  factory WordEntry.fromJson(Map<String, dynamic> json) => WordEntry(
        language: json["language"] is Map
            ? LanguageInfo.fromJson(Map<String, dynamic>.from(json["language"]))
            : null,
        partOfSpeech: json["partOfSpeech"] ?? "unknown",
        pronunciations: (json["pronunciations"] as List?)
                ?.whereType<Map>()
                .map((x) =>
                    Pronunciation.fromJson(Map<String, dynamic>.from(x)))
                .where((pronunciation) => pronunciation.text.isNotEmpty)
                .toList() ??
            const [],
        forms: (json["forms"] as List?)
                ?.whereType<Map>()
                .map((x) => WordForm.fromJson(Map<String, dynamic>.from(x)))
                .where((form) => form.word.isNotEmpty)
                .toList() ??
            const [],
        senses: (json["senses"] as List?)
                ?.whereType<Map>()
                .map((x) => Sense.fromJson(Map<String, dynamic>.from(x)))
                .toList() ??
            const [],
        synonyms: _stringList(json["synonyms"]),
        antonyms: _stringList(json["antonyms"]),
      );

  Map<String, dynamic> toJson() => {
        "language": language?.toJson(),
        "partOfSpeech": partOfSpeech,
        "pronunciations": pronunciations.map((x) => x.toJson()).toList(),
        "forms": forms.map((x) => x.toJson()).toList(),
        "senses": senses.map((x) => x.toJson()).toList(),
        "synonyms": synonyms,
        "antonyms": antonyms,
      };

  /// Entry level synonyms plus the ones attached to individual senses.
  List<String> get allSynonyms =>
      _merge(synonyms, senses.expand((sense) => sense.allSynonyms));

  List<String> get allAntonyms =>
      _merge(antonyms, senses.expand((sense) => sense.allAntonyms));
}

class Sense {
  final String definition;
  final List<String> tags;
  final List<String> examples;
  final List<Quote> quotes;
  final List<String> synonyms;
  final List<String> antonyms;
  final List<Sense> subsenses;

  const Sense({
    required this.definition,
    required this.tags,
    required this.examples,
    required this.quotes,
    required this.synonyms,
    required this.antonyms,
    required this.subsenses,
  });

  factory Sense.fromJson(Map<String, dynamic> json) => Sense(
        definition: json["definition"] ?? "",
        tags: _stringList(json["tags"]),
        examples: _stringList(json["examples"]),
        quotes: (json["quotes"] as List?)
                ?.whereType<Map>()
                .map((x) => Quote.fromJson(Map<String, dynamic>.from(x)))
                .where((quote) => quote.text.isNotEmpty)
                .toList() ??
            const [],
        synonyms: _stringList(json["synonyms"]),
        antonyms: _stringList(json["antonyms"]),
        subsenses: (json["subsenses"] as List?)
                ?.whereType<Map>()
                .map((x) => Sense.fromJson(Map<String, dynamic>.from(x)))
                .toList() ??
            const [],
      );

  Map<String, dynamic> toJson() => {
        "definition": definition,
        "tags": tags,
        "examples": examples,
        "quotes": quotes.map((x) => x.toJson()).toList(),
        "synonyms": synonyms,
        "antonyms": antonyms,
        "subsenses": subsenses.map((x) => x.toJson()).toList(),
      };

  List<String> get allSynonyms =>
      _merge(synonyms, subsenses.expand((sense) => sense.allSynonyms));

  List<String> get allAntonyms =>
      _merge(antonyms, subsenses.expand((sense) => sense.allAntonyms));
}

class Quote {
  final String text;
  final String? reference;

  const Quote({required this.text, this.reference});

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        text: json["text"] ?? "",
        reference: json["reference"],
      );

  Map<String, dynamic> toJson() => {"text": text, "reference": reference};
}

class Pronunciation {
  final String type;
  final String text;
  final List<String> tags;

  const Pronunciation({
    required this.type,
    required this.text,
    required this.tags,
  });

  factory Pronunciation.fromJson(Map<String, dynamic> json) => Pronunciation(
        type: json["type"] ?? "ipa",
        text: json["text"] ?? "",
        tags: _stringList(json["tags"]),
      );

  Map<String, dynamic> toJson() => {"type": type, "text": text, "tags": tags};

  /// e.g. "General American", used as the subtitle of a transcription chip.
  String get accent => tags.join(' · ');
}

class WordForm {
  final String word;
  final List<String> tags;

  const WordForm({required this.word, required this.tags});

  factory WordForm.fromJson(Map<String, dynamic> json) => WordForm(
        word: json["word"] ?? "",
        tags: _stringList(json["tags"]),
      );

  Map<String, dynamic> toJson() => {"word": word, "tags": tags};

  String get label => tags.isEmpty ? 'form' : tags.join(' · ');
}

class LanguageInfo {
  final String code;
  final String name;

  const LanguageInfo({required this.code, required this.name});

  factory LanguageInfo.fromJson(Map<String, dynamic> json) => LanguageInfo(
        code: json["code"] ?? "",
        name: json["name"] ?? "",
      );

  Map<String, dynamic> toJson() => {"code": code, "name": name};
}

class DictionarySource {
  final String url;
  final License? license;

  const DictionarySource({required this.url, this.license});

  factory DictionarySource.fromJson(Map<String, dynamic> json) =>
      DictionarySource(
        url: json["url"] ?? "",
        license: json["license"] is Map
            ? License.fromJson(Map<String, dynamic>.from(json["license"]))
            : null,
      );

  Map<String, dynamic> toJson() => {"url": url, "license": license?.toJson()};
}

class License {
  final String name;
  final String url;

  const License({required this.name, required this.url});

  factory License.fromJson(Map<String, dynamic> json) => License(
        name: json["name"] ?? "",
        url: json["url"] ?? "",
      );

  Map<String, dynamic> toJson() => {"name": name, "url": url};
}

List<String> _stringList(dynamic value) =>
    (value as List?)?.whereType<String>().where((v) => v.isNotEmpty).toList() ??
    const [];

/// Concatenates lists while dropping duplicates and keeping the original order.
List<String> _merge(Iterable<String> first, Iterable<String> second) {
  final seen = <String>{};
  return [...first, ...second].where(seen.add).toList();
}
