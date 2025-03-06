import 'dart:convert';

class DictionaryModel {
  String word;
  String? phonetic;
  List<Phonetic> phonetics;
  List<Meaning> meanings;
  License? license;
  List<String>? sourceUrls;

  DictionaryModel({
    required this.word,
    this.phonetic,
    required this.phonetics,
    required this.meanings,
    this.license,
    this.sourceUrls,
  });

  factory DictionaryModel.fromRawJson(String str) =>
      DictionaryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DictionaryModel.fromJson(Map<String, dynamic> json) =>
      DictionaryModel(
        word: json["word"] ?? "Unknown",
        phonetic: json["phonetic"],
        phonetics: (json["phonetics"] as List?)
                ?.map((x) => Phonetic.fromJson(x))
                .toList() ??
            [],
        meanings: (json["meanings"] as List?)
                ?.map((x) => Meaning.fromJson(x))
                .toList() ??
            [],
        license:
            json["license"] != null ? License.fromJson(json["license"]) : null,
        sourceUrls: (json["sourceUrls"] as List?)?.cast<String>() ?? [],
      );

  Map<String, dynamic> toJson() => {
        "word": word,
        "phonetic": phonetic,
        "phonetics": phonetics.map((x) => x.toJson()).toList(),
        "meanings": meanings.map((x) => x.toJson()).toList(),
        "license": license?.toJson(),
        "sourceUrls": sourceUrls,
      };
}

class License {
  String name;
  String url;

  License({required this.name, required this.url});

  factory License.fromRawJson(String str) => License.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory License.fromJson(Map<String, dynamic> json) => License(
        name: json["name"] ?? "",
        url: json["url"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
      };
}

class Meaning {
  String partOfSpeech;
  List<Definition> definitions;
  List<String> synonyms;
  List<String> antonyms;

  Meaning({
    required this.partOfSpeech,
    required this.definitions,
    required this.synonyms,
    required this.antonyms,
  });

  factory Meaning.fromRawJson(String str) => Meaning.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meaning.fromJson(Map<String, dynamic> json) => Meaning(
        partOfSpeech: json["partOfSpeech"] ?? "unknown",
        definitions: (json["definitions"] as List?)
                ?.map((x) => Definition.fromJson(x))
                .toList() ??
            [],
        synonyms: (json["synonyms"] as List?)?.cast<String>() ?? [],
        antonyms: (json["antonyms"] as List?)?.cast<String>() ?? [],
      );

  Map<String, dynamic> toJson() => {
        "partOfSpeech": partOfSpeech,
        "definitions": definitions.map((x) => x.toJson()).toList(),
        "synonyms": synonyms,
        "antonyms": antonyms,
      };
}

class Definition {
  String definition;
  List<String> synonyms;
  List<String> antonyms;
  String? example;

  Definition({
    required this.definition,
    required this.synonyms,
    required this.antonyms,
    this.example,
  });

  factory Definition.fromRawJson(String str) =>
      Definition.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Definition.fromJson(Map<String, dynamic> json) => Definition(
        definition: json["definition"] ?? "",
        synonyms: (json["synonyms"] as List?)?.cast<String>() ?? [],
        antonyms: (json["antonyms"] as List?)?.cast<String>() ?? [],
        example: json["example"],
      );

  Map<String, dynamic> toJson() => {
        "definition": definition,
        "synonyms": synonyms,
        "antonyms": antonyms,
        "example": example,
      };
}

class Phonetic {
  String? text;
  String? audio;
  String? sourceUrl;
  License? license;

  Phonetic({
    this.text,
    this.audio,
    this.sourceUrl,
    this.license,
  });

  factory Phonetic.fromRawJson(String str) =>
      Phonetic.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Phonetic.fromJson(Map<String, dynamic> json) => Phonetic(
        text: json["text"],
        audio: json["audio"],
        sourceUrl: json["sourceUrl"],
        license:
            json["license"] != null ? License.fromJson(json["license"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "audio": audio,
        "sourceUrl": sourceUrl,
        "license": license?.toJson(),
      };
}
