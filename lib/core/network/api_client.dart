import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({required this.baseUrl, required this.tokenProvider});

  final String baseUrl;
  final Future<String?> Function() tokenProvider;

  Future<http.Response> get(
    String path, {
    Map<String, String>? queryParams,
  }) async {
    final uri = _buildUri(path, queryParams);
    final headers = await _headers();
    return http.get(uri, headers: headers);
  }

  Future<http.Response> post(
    String path, {
    Object? body,
    Map<String, String>? queryParams,
  }) async {
    final uri = _buildUri(path, queryParams);
    final headers = await _headers();
    final encoded = body == null ? null : jsonEncode(body);
    return http.post(uri, body: encoded, headers: headers);
  }

  Future<http.Response> put(
    String path, {
    Object? body,
    Map<String, String>? queryParams,
  }) async {
    final uri = _buildUri(path, queryParams);
    final headers = await _headers();
    final encoded = body == null ? null : jsonEncode(body);
    return http.put(uri, body: encoded, headers: headers);
  }

  Future<http.Response> delete(
    String path, {
    Object? body,
    Map<String, String>? queryParams,
  }) async {
    final uri = _buildUri(path, queryParams);
    final headers = await _headers();
    final encoded = body == null ? null : jsonEncode(body);
    return http.delete(uri, body: encoded, headers: headers);
  }

  Uri _buildUri(String path, Map<String, String>? queryParams) {
    final normalized = path.startsWith('/') ? path : '/$path';
    return Uri.parse(
      '$baseUrl$normalized',
    ).replace(queryParameters: queryParams);
  }

  Future<Map<String, String>> _headers() async {
    final token = await tokenProvider();
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }
}
