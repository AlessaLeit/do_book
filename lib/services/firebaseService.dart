import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mangaModel.dart';
import '../models/livroModel.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Autenticação
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      throw e;
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  // Firestore para Mangás
  Future<void> addManga(MangaModel manga) async {
    if (currentUser == null) throw Exception('Usuário não autenticado');
    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('mangas')
        .add(manga.toMap());
  }

  Future<List<MangaModel>> getMangas() async {
    if (currentUser == null) throw Exception('Usuário não autenticado');
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('mangas')
        .get();
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Usar doc.id como id
      return MangaModel.fromMap(data);
    }).toList();
  }

  Future<void> updateManga(MangaModel manga) async {
    if (currentUser == null) throw Exception('Usuário não autenticado');
    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('mangas')
        .doc(manga.id.toString())
        .update(manga.toMap());
  }

  Future<void> deleteManga(String id) async {
    if (currentUser == null) throw Exception('Usuário não autenticado');
    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('mangas')
        .doc(id)
        .delete();
  }

  // Firestore para Livros
  Future<void> addLivro(LivroModel livro) async {
    if (currentUser == null) throw Exception('Usuário não autenticado');
    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('livros')
        .add(livro.toMap());
  }

  Future<List<LivroModel>> getLivros() async {
    if (currentUser == null) throw Exception('Usuário não autenticado');
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('livros')
        .get();
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return LivroModel.fromMap(data);
    }).toList();
  }

  Future<void> updateLivro(LivroModel livro) async {
    if (currentUser == null) throw Exception('Usuário não autenticado');
    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('livros')
        .doc(livro.id.toString())
        .update(livro.toMap());
  }

  Future<void> deleteLivro(String id) async {
    if (currentUser == null) throw Exception('Usuário não autenticado');
    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('livros')
        .doc(id)
        .delete();
  }
}
