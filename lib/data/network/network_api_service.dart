import 'dart:convert';
import 'dart:io';

import 'package:easy_dictionary/data/network/base_api_service.dart';
import 'package:easy_dictionary/data/network/api_logger.dart';
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
    } on SocketException catch (error, stackTrace) {
      ApiLogger.error(
        operation: 'GET $url',
        error: error,
        stackTrace: stackTrace,
      );
      if (error.message.contains('Network is unreachable')) {
        throw NetworkException();
      } else if (error.message.contains('Connection refused')) {
        throw ServerException();
      } else {
        throw NetworkException();
      }
    } on TimeoutException catch (error, stackTrace) {
      ApiLogger.error(
        operation: 'GET $url',
        error: error,
        stackTrace: stackTrace,
      );
      throw TimeoutException();
    } on http.ClientException catch (error, stackTrace) {
      ApiLogger.error(
        operation: 'GET $url',
        error: error,
        stackTrace: stackTrace,
      );
      throw ServerException();
    } on AppException catch (error, stackTrace) {
      ApiLogger.error(
        operation: 'GET $url',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    } catch (error, stackTrace) {
      ApiLogger.error(
        operation: 'GET $url',
        error: error,
        stackTrace: stackTrace,
      );
      throw AppException(error.toString());
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
