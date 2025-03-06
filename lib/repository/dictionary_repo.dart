import 'package:easy_dictionary/data/exception/app_exceptions.dart';
import 'package:easy_dictionary/data/network/base_api_service.dart';
import 'package:easy_dictionary/data/network/network_api_service.dart';
import 'package:easy_dictionary/utils/app_url/app_urls.dart';

class DictionaryRepo {
  final BaseApiService apiService = NetworkApiService();

  Future fetchWordDetailsApi({required String word}) async {
    try {
      dynamic response =
          await apiService.getGetApiResponse(url: AppUrls.baseUrl + word);
      if (response is List && response.isNotEmpty) {
        return response;
      } else {
        throw DefinitionNotFoundException();
      }
    } catch (e) {
      rethrow;
    }
  }
}
