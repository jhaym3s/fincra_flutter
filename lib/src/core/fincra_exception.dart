
class FincraException implements Exception {
  FincraException(
    this.message, {
    this.statusCode,
    this.errorType,
    this.errors = const [],
    this.raw,
  });

  final String message;

  final int? statusCode;

  final String? errorType;

  final List<String> errors;

  final Object? raw;

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
