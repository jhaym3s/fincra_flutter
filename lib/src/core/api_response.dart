
class FincraResponse<T> {
  const FincraResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final T data;

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
