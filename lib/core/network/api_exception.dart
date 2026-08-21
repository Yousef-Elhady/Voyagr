import 'package:dio/dio.dart';

/// A single error type used across every repository in the app, so
/// screens never need to know whether a failure came from Dio, the
/// backend, or somewhere else — they just catch/read an ApiException.
class ApiException implements Exception {
  final int? statusCode;
  final String message;

  /// Field-keyed validation errors, matching the backend's 400 shape:
  /// { "email": ["Email is required"] }
  /// Null for non-validation errors (401, 500, no internet, etc).
  final Map<String, dynamic>? errors;

  const ApiException({
    required this.message,
    this.statusCode,
    this.errors,
  });

  bool get isValidationError => errors != null && errors!.isNotEmpty;

  /// First validation message for a given field, if any — e.g.
  /// `error.errorFor('email')` to show under the email TextField.
  String? errorFor(String field) {
    final fieldErrors = errors?[field];
    if (fieldErrors is List && fieldErrors.isNotEmpty) {
      return fieldErrors.first.toString();
    }
    return null;
  }

  /// Builds an ApiException from a Dio response body, matching the
  /// backend's standard error shape: { "message": "...", "errors": {...} | null }
  factory ApiException.fromResponse(Response? response, {String? fallbackMessage}) {
    final statusCode = response?.statusCode;
    final data = response?.data;

    if (data is Map<String, dynamic>) {
      return ApiException(
        statusCode: statusCode,
        message: data['message'] as String? ?? fallbackMessage ?? _defaultMessageFor(statusCode),
        errors: data['errors'] as Map<String, dynamic>?,
      );
    }

    return ApiException(
      statusCode: statusCode,
      message: fallbackMessage ?? _defaultMessageFor(statusCode),
    );
  }

  /// Unwraps whatever was thrown into an ApiException — whether it's
  /// already one, a DioException carrying one (attached by the
  /// interceptor in api_client.dart), or something else entirely.
  /// Every catch block in the app should call this rather than
  /// checking `e is ApiException` directly, since what Dio actually
  /// throws is a DioException with the ApiException tucked inside it.
  factory ApiException.from(Object error) {
    if (error is ApiException) return error;
    if (error is DioException) {
      if (error.error is ApiException) return error.error as ApiException;
      return ApiException.fromResponse(error.response, fallbackMessage: error.message);
    }
    return ApiException(message: error.toString());
  }

  static String _defaultMessageFor(int? statusCode) => switch (statusCode) {
    401 => 'Incorrect email or password.',
    403 => 'You do not have permission to do that.',
    404 => 'Resource not found.',
    409 => 'That already exists.',
    500 => 'Server error. Please try again later.',
    null => 'No internet connection.',
    _ => 'Something went wrong (error $statusCode).',
  };

  @override
  String toString() => 'ApiException($statusCode): $message';
}