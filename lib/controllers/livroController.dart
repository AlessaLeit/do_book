import 'package:flutter/material.dart';
import '../models/livroModel.dart';
import '../repositories/livroRepository.dart';
import '../services/livroSyncService.dart';

class LivroController extends ChangeNotifier {
  final LivroRepository _livroRepository;
  final LivroSyncService _livroSyncService;

  LivroController(this._livroRepository, this._livroSyncService);

  List<LivroModel> _livros = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<LivroModel> get livros => _livros;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadLivros() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _livros = await _livroRepository.getLivros();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addLivro(LivroModel livro) async {
    try {
      await _livroRepository.addLivro(livro);
      await _livroSyncService.syncToRemote(livro);
      await loadLivros();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateLivro(LivroModel livro) async {
    try {
      await _livroRepository.updateLivro(livro);
      await _livroSyncService.syncToRemote(livro);
      await loadLivros();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteLivro(String id) async {
    try {
      await _livroRepository.deleteLivro(id);
      await _livroSyncService.deleteFromRemote(id);
      await loadLivros();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
