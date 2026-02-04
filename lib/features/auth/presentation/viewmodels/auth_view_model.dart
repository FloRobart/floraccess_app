import 'package:flutter/material.dart';

import '../../../../shared/app_state.dart';
import '../../data/auth_repository.dart';
import '../../../users/models/user.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({required this.authRepository, required this.appState});

  final AuthRepository authRepository;
  final AppState appState;

  bool _isLoading = false;
  String? _error;
  User? _profile;

  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get profile => _profile;

  Future<bool> requestLogin(String email) async {
    _setLoading(true);
    final result = await authRepository.loginRequest(email);
    _setLoading(false);
    return result.when(
      success: (token) {
        _error = null;
        appState.setLoginEmail(email);
        appState.setLoginRequestToken(token);
        return true;
      },
      error: (msg) {
        _error = msg;
        notifyListeners();
        return false;
      },
    );
  }

  Future<bool> confirmLogin(String code) async {
    final email = appState.loginEmail;
    final requestToken = appState.loginRequestToken;
    if (email == null || requestToken == null) {
      _error = 'Session de connexion invalide';
      notifyListeners();
      return false;
    }
    _setLoading(true);
    final result = await authRepository.loginConfirm(
      email: email,
      code: code.trim().replaceAll(RegExp(r'\s+'), ''),
      requestToken: requestToken,
    );
    _setLoading(false);
    return result.when(
      success: (jwt) {
        _error = null;
        appState.setJwtToken(jwt);
        appState.setLoginRequestToken(null);
        notifyListeners();
        return true;
      },
      error: (msg) {
        _error = msg;
        notifyListeners();
        return false;
      },
    );
  }

  Future<void> logoutLocal() async {
    await appState.clearJwtToken();
    await appState.setLoginRequestToken(null);
    notifyListeners();
  }

  Future<void> logoutEverywhere() async {
    _setLoading(true);
    final result = await authRepository.logoutAll();
    _setLoading(false);
    result.when(
      success: (_) async {
        await logoutLocal();
      },
      error: (msg) {
        _error = msg;
        notifyListeners();
      },
    );
  }

  Future<void> loadProfile() async {
    _setLoading(true);
    final result = await authRepository.fetchProfile();
    _setLoading(false);
    result.when(
      success: (user) {
        _profile = user;
        _error = null;
        notifyListeners();
      },
      error: (msg) {
        _error = msg;
        notifyListeners();
      },
    );
  }

  Future<void> updatePseudo(String email, String pseudo) async {
    _setLoading(true);
    final result = await authRepository.updatePseudo(email, pseudo);
    _setLoading(false);
    await result.when(
      success: (payload) async {
        _profile = payload.user;
        _error = null;
        final newJwt = payload.jwt;
        if (newJwt != null && newJwt.isNotEmpty) {
          await appState.setJwtToken(newJwt);
          await _refreshProfileFromServer();
        } else {
          notifyListeners();
        }
      },
      error: (msg) async {
        _error = msg;
        notifyListeners();
      },
    );
  }

  Future<void> _refreshProfileFromServer() async {
    final refresh = await authRepository.fetchProfile();
    refresh.when(
      success: (user) {
        _profile = user;
        _error = null;
      },
      error: (msg) {
        _error = msg;
      },
    );
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
