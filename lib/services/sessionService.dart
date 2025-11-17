import 'package:shared_preferences/shared_preferences.dart';
import '../models/userModel.dart';

class SessionService {
  static const String _userKey = 'user_data';

  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = user.toMap();
    await prefs.setString(_userKey, userData.toString());
  }

  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userKey);
    if (userDataString != null) {
      // Note: This is a simple implementation. In a real app, you'd use JSON serialization
      // For now, we'll return null and rely on Firebase auth state
      return null;
    }
    return null;
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  bool get isAuthenticated => false; // Will be updated when Firebase auth is checked
}
