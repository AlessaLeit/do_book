import 'package:firebase_auth/firebase_auth.dart';
import '../models/userModel.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel.fromFirebase(result.user);
    } catch (e) {
      throw e;
    }
  }

  Future<UserModel?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel.fromFirebase(result.user);
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  UserModel? getCurrentUser() {
    final user = _auth.currentUser;
    return user != null ? UserModel.fromFirebase(user) : null;
  }

  Stream<UserModel?> get userChanges {
    return _auth.authStateChanges().map((user) =>
        user != null ? UserModel.fromFirebase(user) : null);
  }
}
