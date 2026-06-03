/// A typed wrapper around Fincra's standard success envelope.
///
/// Fincra responses are shaped like:
/// ```json
/// { "success": true, "message": "...", "data": { ... } }
/// ```
/// (checkout uses `status` instead of `success`). [data] is the parsed
/// payload of type [T].
class FincraResponse<T> {
  const FincraResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final T data;

  /// Parses an envelope, mapping the `data` field with [fromData].
  factory FincraResponse.fromEnvelope(
    Map<String, dynamic> body,
    T Function(dynamic data) fromData,
  ) {
    return FincraResponse<T>(
      success: (body['success'] ?? body['status'] ?? false) as bool,
      message: (body['message'] ?? '').toString(),
      data: fromData(body['data']),
    );
  }
}
