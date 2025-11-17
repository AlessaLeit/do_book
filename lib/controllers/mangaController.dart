import 'package:flutter/material.dart';
import '../models/mangaModel.dart';
import '../repositories/mangaRepository.dart';
import '../services/mangaSyncService.dart';

class MangaController extends ChangeNotifier {
  final MangaRepository _mangaRepository;
  final MangaSyncService _mangaSyncService;

  MangaController(this._mangaRepository, this._mangaSyncService);

  List<MangaModel> _mangas = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<MangaModel> get mangas => _mangas;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadMangas() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _mangas = await _mangaRepository.getMangas();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addManga(MangaModel manga) async {
    try {
      await _mangaRepository.addManga(manga);
      await _mangaSyncService.syncToRemote(manga);
      await loadMangas(); // Recarregar lista
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateManga(MangaModel manga) async {
    try {
      await _mangaRepository.updateManga(manga);
      await _mangaSyncService.syncToRemote(manga);
      await loadMangas();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteManga(String id) async {
    try {
      await _mangaRepository.deleteManga(id);
      await _mangaSyncService.deleteFromRemote(id);
      await loadMangas();
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
