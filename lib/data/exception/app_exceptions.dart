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

// Add more custom exceptions as needed...