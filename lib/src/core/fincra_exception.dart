/// Thrown when a Fincra API call fails.
///
/// Fincra error bodies typically look like:
/// ```json
/// { "success": false, "error": "Account could not be resolved", "errorType": "UNPROCESSABLE_ENTITY" }
/// ```
/// or, for validation failures, include an `errors` array. This exception
/// normalises all of those into a single shape.
class FincraException implements Exception {
  FincraException(
    this.message, {
    this.statusCode,
    this.errorType,
    this.errors = const [],
    this.raw,
  });

  /// Human-readable error message (from `error` or `message`).
  final String message;

  /// HTTP status code, when the failure came from a response.
  final int? statusCode;

  /// Fincra's machine-readable error category, e.g. `VALIDATION_FAILED`.
  final String? errorType;

  /// Individual validation messages, when present.
  final List<String> errors;

  /// The decoded response body, for debugging.
  final Object? raw;

  /// Builds an exception from a decoded JSON error body.
  factory FincraException.fromBody(
    Map<String, dynamic> body, {
    int? statusCode,
  }) {
    final dynamic rawErrors = body['errors'];
    return FincraException(
      (body['error'] ?? body['message'] ?? 'Unknown Fincra error').toString(),
      statusCode: statusCode,
      errorType: body['errorType']?.toString(),
      errors: rawErrors is List
          ? rawErrors.map((dynamic e) => e.toString()).toList()
          : const [],
      raw: body,
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer('FincraException: $message');
    if (statusCode != null) buffer.write(' (HTTP $statusCode)');
    if (errorType != null) buffer.write(' [$errorType]');
    return buffer.toString();
  }
}
