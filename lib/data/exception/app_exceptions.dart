import '../../utils/errors/error_messages.dart';

class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException() : super(ErrorMessages.networkError);
}

class ServerException extends AppException {
  ServerException() : super(ErrorMessages.serverError);
}

class BadRequestException extends AppException {
  BadRequestException() : super(ErrorMessages.badRequest);
}

class UnauthorizedException extends AppException {
  UnauthorizedException() : super(ErrorMessages.unauthorized);
}

class ForbiddenException extends AppException {
  ForbiddenException() : super(ErrorMessages.forbidden);
}

class TimeoutException extends AppException {
  TimeoutException() : super(ErrorMessages.timeout);
}

class DefinitionNotFoundException extends AppException {
  DefinitionNotFoundException() : super(ErrorMessages.definitions);
}

class AudioNotAvailableException extends AppException {
  AudioNotAvailableException() : super(ErrorMessages.audio);
}

class AudioUnableToPlayException extends AppException {
  AudioUnableToPlayException() : super(ErrorMessages.audioPlayerError);
}

class UrlCannotLaunchException extends AppException {
  UrlCannotLaunchException() : super(ErrorMessages.url);
}

class RateLimiterException extends AppException {
  RateLimiterException() : super(ErrorMessages.rateLimiter);
}
// Add more custom exceptions as needed...