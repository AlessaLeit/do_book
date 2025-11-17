import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/mangaModel.dart';
import '../database/databaseHelper.dart';

class MangaRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<MangaModel>> getMangas() async {
    // Sempre usar SQLite para consistência
    final mangas = await _databaseHelper.getMangas();
    return mangas.map((manga) => MangaModel.fromMap(manga.toMap())).toList();
  }

  Future<void> addManga(MangaModel manga) async {
    // SQLite
    await _databaseHelper.insertManga(manga);
    // Sincronizar com Firestore se logado
    try {
      await _firestore.collection('mangas').add(manga.toMap());
    } catch (e) {
      // Ignorar erro se não estiver logado ou sem internet
    }
  }

  Future<void> updateManga(MangaModel manga) async {
    if (manga.id == null) throw Exception('ID do mangá não pode ser nulo');
    // SQLite
    await _databaseHelper.updateManga(manga);
    // Sincronizar com Firestore se logado
    try {
      await _firestore.collection('mangas').doc(manga.id).update(manga.toMap());
    } catch (e) {
      // Ignorar erro se não estiver logado ou sem internet
    }
  }

  Future<void> deleteManga(String id) async {
    // SQLite
    await _databaseHelper.deleteManga(int.parse(id));
    // Sincronizar com Firestore se logado
    try {
      await _firestore.collection('mangas').doc(id).delete();
    } catch (e) {
      // Ignorar erro se não estiver logado ou sem internet
    }
  }
}
