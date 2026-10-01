import 'package:easy_dictionary/data/exception/app_exceptions.dart';
import 'package:easy_dictionary/data/network/base_api_service.dart';
import 'package:easy_dictionary/data/network/network_api_service.dart';
import 'package:easy_dictionary/models/dictionary_model.dart';
import 'package:easy_dictionary/models/language_model.dart';
import 'package:easy_dictionary/utils/app_url/app_urls.dart';

class DictionaryRepo {
  DictionaryRepo({BaseApiService? apiService})
      : apiService = apiService ?? NetworkApiService();

  final BaseApiService apiService;

  /// Looks [word] up in [languageCode] and fails when the API has no entries.
  ///
  /// The API answers unknown words with `200` and an empty `entries` list, so
  /// the emptiness check has to happen here rather than on the status code.
  Future<DictionaryModel> fetchWordDetails({
    required String word,
    required String languageCode,
  }) async {
    final response = await apiService.getGetApiResponse(
      url: AppUrls.entries(languageCode: languageCode, word: word.trim()),
    );

    if (response is! Map) throw DefinitionNotFoundException();

    final model = DictionaryModel.fromJson(Map<String, dynamic>.from(response));
    if (!model.hasEntries) throw DefinitionNotFoundException();
    return model;
  }

  Future<List<LanguageModel>> fetchLanguages() async {
    final response = await apiService.getGetApiResponse(
      url: AppUrls.languages,
    );

    if (response is! List || response.isEmpty) throw ServerException();

    return response
        .whereType<Map>()
        .map((x) => LanguageModel.fromJson(Map<String, dynamic>.from(x)))
        .where((language) => language.code.isNotEmpty)
        .toList();
  }

  /// A handful of random English words, so a word missing from the dictionary
  /// can be skipped without another round trip.
  Future<List<String>> fetchRandomWords({int count = 5}) async {
    final response = await apiService.getGetApiResponse(
      url: AppUrls.randomWords(count: count),
    );

    if (response is! List) throw ServerException();

    return response
        .whereType<String>()
        .map((word) => word.trim())
        .where((word) => word.isNotEmpty)
        .toList();
  }
}
