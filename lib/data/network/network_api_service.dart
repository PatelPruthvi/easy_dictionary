import 'dart:convert';
import 'dart:io';

import 'package:easy_dictionary/data/network/base_api_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../utils/constants/app_constants.dart';
import '../exception/app_exceptions.dart';

class NetworkApiService extends BaseApiService {
  @override
  Future<dynamic> getGetApiResponse({required String url}) async {
    dynamic jsonResponse;
    try {
      Response response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: AppConstants.timeoutDurationInSec),
              onTimeout: () {
        throw TimeoutException();
      });

      jsonResponse = returnResponse(response);
    } on SocketException catch (e) {
      if (e.message.contains('Network is unreachable')) {
        throw NetworkException();
      } else if (e.message.contains('Connection refused')) {
        throw ServerException();
      } else {
        throw NetworkException();
      }
    } on TimeoutException {
      throw TimeoutException();
    } on http.ClientException {
      throw ServerException();
    } catch (e) {
      throw AppException(e.toString());
    }
    return jsonResponse;
  }
}

dynamic returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      dynamic jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    case 400:
      throw BadRequestException();
    case 401:
      throw UnauthorizedException();
    case 403:
      throw ForbiddenException();
    case 404:
      throw DefinitionNotFoundException(); //referred from dictionaryapi github docs
    case 429:
      throw RateLimiterException(); //referred from dictionaryapi github docs
    case 500:
      throw ServerException();
    default:
      throw AppException(response.body.toString());
  }
}
