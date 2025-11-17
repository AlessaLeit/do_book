import 'package:flutter/material.dart';
import '../repositories/authRepository.dart';
import '../services/sessionService.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _authRepository;
  final SessionService _sessionService;

  AuthController(this._authRepository, this._sessionService);

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _sessionService.isAuthenticated;

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authRepository.signIn(email, password);
      if (user != null) {
        await _sessionService.saveUser(user);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _errorMessage = 'Falha na autenticação';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authRepository.signUp(email, password);
      if (user != null) {
        await _sessionService.saveUser(user);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _errorMessage = 'Falha no cadastro';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    await _sessionService.clearUser();
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
