import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'fincra_config.dart';
import 'fincra_exception.dart';


class FincraHttpClient {
  FincraHttpClient(this._config, {http.Client? httpClient})
      : _client = httpClient ?? http.Client();

  final FincraConfig _config;
  final http.Client _client;

  @visibleForTesting
  Map<String, String> buildHeaders({bool includePublicKey = false}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'api-key': _config.secretKey,
    };
    if (includePublicKey && _config.publicKey != null) {
      headers['x-pub-key'] = _config.publicKey!;
    }
    if (_config.businessId != null) {
      headers['x-business-id'] = _config.businessId!;
    }
    return headers;
  }

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final normalized = path.startsWith('/') ? path : '/$path';
    final cleaned = query?.map(
      (key, dynamic value) => MapEntry(key, value?.toString() ?? ''),
    )?..removeWhere((_, value) => value.isEmpty);
    return Uri.parse('${_config.baseUrl}$normalized').replace(
      queryParameters: (cleaned == null || cleaned.isEmpty) ? null : cleaned,
    );
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
    bool includePublicKey = false,
  }) {
    return _send(() => _client
        .get(_uri(path, query),
            headers: buildHeaders(includePublicKey: includePublicKey),)
        .timeout(_config.timeout),);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    bool includePublicKey = false,
  }) {
    return _send(() => _client
        .post(
          _uri(path),
          headers: buildHeaders(includePublicKey: includePublicKey),
          body: jsonEncode(body ?? const <String, dynamic>{}),
        )
        .timeout(_config.timeout));
  }

  Future<Map<String, dynamic>> _send(
    Future<http.Response> Function() request,
  ) async {
    final http.Response response;
    try {
      response = await request();
    } on TimeoutException {
      throw FincraException('Request timed out after ${_config.timeout}.');
    } catch (e) {
      throw FincraException('Network error: $e');
    }

    Map<String, dynamic> decoded;
    try {
      final dynamic parsed =
          response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body);
      decoded = parsed is Map<String, dynamic> ? parsed : {'data': parsed};
    } on FormatException {
      throw FincraException(
        'Could not parse response from Fincra.',
        statusCode: response.statusCode,
        raw: response.body,
      );
    }

    final ok = response.statusCode >= 200 && response.statusCode < 300;
    final flaggedFailure = decoded['success'] == false || decoded['status'] == false;
    if (!ok || flaggedFailure) {
      throw FincraException.fromBody(decoded, statusCode: response.statusCode);
    }
    return decoded;
  }

  void close() => _client.close();
}
