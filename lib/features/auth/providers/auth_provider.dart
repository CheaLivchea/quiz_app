import 'package:flutter/material.dart';
import '../models/auth_state.dart';
import '../services/auth_service.dart';
import '../utils/token_manager.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final TokenManager _tokenManager;
  AuthState _state = AuthState();

  AuthProvider(this._authService, this._tokenManager);

  bool get isAuthenticated => _state.isAuthenticated;
  String? get token => _state.token;
  String? get error => _state.error;

  Future<bool> login(String phone, String password) async {
    try {
      final result = await _authService.login(phone, password);

      if (result['success']) {
        final token = result['token'];
        // Token expires in 24 hours
        final expiry = DateTime.now().add(const Duration(hours: 24));

        await _tokenManager.saveToken(token, expiry);
        _state = AuthState(
          isAuthenticated: true,
          token: token,
          tokenExpiry: expiry,
        );
        notifyListeners();
        return true;
      } else {
        _state = AuthState(error: result['message']);
        notifyListeners();
        return false;
      }
    } catch (e) {
      _state = AuthState(error: e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _tokenManager.clearToken();
    _state = AuthState();
    notifyListeners();
  }

  Future<bool> sendOTPForReset({required String phoneNumber}) async {
    try {
      final result = await _authService.sendOTPForReset(phoneNumber);

      if (result['success']) {
        _state = AuthState(error: null);
        notifyListeners();
        return true;
      } else {
        _state = AuthState(error: result['message']);
        notifyListeners();
        return false;
      }
    } catch (e) {
      _state = AuthState(error: e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetPassword({
    required String phoneNumber,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final result = await _authService.resetPassword(
        phoneNumber,
        otp,
        newPassword,
      );

      if (result['success']) {
        _state = AuthState(error: null);
        notifyListeners();
        return true;
      } else {
        _state = AuthState(error: result['message']);
        notifyListeners();
        return false;
      }
    } catch (e) {
      _state = AuthState(error: e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<void> checkAuthState() async {
    final isValid = await _tokenManager.isTokenValid();
    final token = await _tokenManager.getToken();

    if (isValid && token != null) {
      _state = AuthState(isAuthenticated: true, token: token);
    } else {
      _state = AuthState();
    }
    notifyListeners();
  }
}
