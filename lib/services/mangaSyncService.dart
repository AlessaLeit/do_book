import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/mangaModel.dart';

class MangaSyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> syncToRemote(MangaModel manga) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('mangas')
        .doc(manga.id);

    await docRef.set(manga.toMap());
  }

  Future<void> deleteFromRemote(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('mangas')
        .doc(id)
        .delete();
  }

  Future<List<MangaModel>> getRemoteMangas() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('mangas')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return MangaModel.fromMap(data);
    }).toList();
  }

  Future<void> syncFromRemote() async {
    // Implementar sincronização bidirecional se necessário
    // Por enquanto, apenas leitura remota
  }
}
