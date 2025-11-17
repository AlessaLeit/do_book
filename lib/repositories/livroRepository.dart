import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/livroModel.dart';
import '../database/databaseHelper.dart';

class LivroRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<LivroModel>> getLivros() async {
    // Sempre usar SQLite para consistência
    final livros = await _databaseHelper.getLivros();
    return livros.map((livro) => LivroModel.fromMap(livro.toMap())).toList();
  }

  Future<void> addLivro(LivroModel livro) async {
    // SQLite
    await _databaseHelper.insertLivro(livro);
    // Sincronizar com Firestore se logado
    try {
      await _firestore.collection('livros').add(livro.toMap());
    } catch (e) {
      // Ignorar erro se não estiver logado ou sem internet
    }
  }

  Future<void> updateLivro(LivroModel livro) async {
    if (livro.id == null) throw Exception('ID do livro não pode ser nulo');
    // SQLite
    await _databaseHelper.updateLivro(livro);
    // Sincronizar com Firestore se logado
    try {
      await _firestore.collection('livros').doc(livro.id).update(livro.toMap());
    } catch (e) {
      // Ignorar erro se não estiver logado ou sem internet
    }
  }

  Future<void> deleteLivro(String id) async {
    // SQLite
    await _databaseHelper.deleteLivro(int.parse(id));
    // Sincronizar com Firestore se logado
    try {
      await _firestore.collection('livros').doc(id).delete();
    } catch (e) {
      // Ignorar erro se não estiver logado ou sem internet
    }
  }
}
