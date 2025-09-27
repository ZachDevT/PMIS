/// Custom API exceptions for better error handling
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;
  
  const ApiException(this.message, [this.statusCode, this.errorCode]);
  
  @override
  String toString() => 'ApiException: $message';
}

/// Network-related exceptions
class NetworkException extends ApiException {
  const NetworkException(String message, [int? statusCode]) 
      : super(message, statusCode, 'NETWORK_ERROR');
}

/// Authentication-related exceptions
class AuthException extends ApiException {
  const AuthException(String message, [int? statusCode]) 
      : super(message, statusCode, 'AUTH_ERROR');
}

/// Validation-related exceptions
class ValidationException extends ApiException {
  const ValidationException(String message) 
      : super(message, 400, 'VALIDATION_ERROR');
}

/// Server-related exceptions
class ServerException extends ApiException {
  const ServerException(String message, [int? statusCode]) 
      : super(message, statusCode, 'SERVER_ERROR');
}

/// Timeout-related exceptions
class TimeoutException extends ApiException {
  const TimeoutException(String message) 
      : super(message, 408, 'TIMEOUT_ERROR');
}
