import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/livroModel.dart';

class LivroSyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> syncToRemote(LivroModel livro) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('livros')
        .doc(livro.id);

    await docRef.set(livro.toMap());
  }

  Future<void> deleteFromRemote(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('livros')
        .doc(id)
        .delete();
  }

  Future<List<LivroModel>> getRemoteLivros() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('livros')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return LivroModel.fromMap(data);
    }).toList();
  }

  Future<void> syncFromRemote() async {
    // Implementar sincronização bidirecional se necessário
    // Por enquanto, apenas leitura remota
  }
}
