import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../core/network/api_client.dart';
import '../../../core/utils/result.dart';
import '../../users/models/user.dart';

class AuthRepository {
  AuthRepository(this._client);

  final ApiClient _client;

  Future<Result<String>> loginRequest(String email) async {
    try {
      final response = await _client.post(
        '/users/login/request',
        body: {'email': email},
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return Success(decoded['token'] as String);
      }
      return Failure('Email non reconnu');
    } catch (e, st) {
      debugPrint('loginRequest error: $e\n$st');
      return Failure('Erreur réseau inattendue');
    }
  }

  Future<Result<String>> loginConfirm({
    required String email,
    required String code,
    required String requestToken,
  }) async {
    try {
      final response = await _client.post(
        '/users/login/confirm',
        body: {'email': email, 'secret': code, 'token': requestToken},
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return Success(decoded['jwt'] as String);
      }
      return Failure('Code invalide');
    } catch (e, st) {
      debugPrint('loginConfirm error: $e\n$st');
      return Failure('Erreur réseau inattendue');
    }
  }

  Future<Result<void>> logoutAll() async {
    try {
      final response = await _client.post('/users/logout');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const Success(null);
      }
      return Failure('Impossible de déconnecter les sessions');
    } catch (e, st) {
      debugPrint('logoutAll error: $e\n$st');
      return Failure('Erreur réseau inattendue');
    }
  }

  Future<Result<User>> fetchProfile() async {
    try {
      final response = await _client.get('/users');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return Success(User.fromJson(decoded));
      }
      return Failure('Profil introuvable');
    } catch (e, st) {
      debugPrint('fetchProfile error: $e\n$st');
      return Failure('Erreur réseau inattendue');
    }
  }

  Future<Result<({User user, String? jwt})>> updatePseudo(
    String email,
    String pseudo,
  ) async {
    try {
      final response = await _client.put(
        '/users',
        body: {'email': email, 'pseudo': pseudo},
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final userPayload = decoded['user'];
        final Map<String, dynamic> userJson;
        if (userPayload is Map<String, dynamic>) {
          userJson = userPayload;
        } else if (userPayload is Map) {
          userJson = userPayload.map(
            (key, value) => MapEntry(key.toString(), value),
          );
        } else {
          userJson = decoded;
        }
        final jwt = decoded['jwt']?.toString();
        return Success((user: User.fromJson(userJson), jwt: jwt));
      }
      return Failure('Impossible de mettre à jour le pseudo');
    } catch (e, st) {
      debugPrint('updatePseudo error: $e\n$st');
      return Failure('Erreur réseau inattendue');
    }
  }
}
