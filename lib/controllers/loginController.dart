import 'package:flutter/material.dart';
import 'authController.dart';

class LoginController {
  final AuthController _authController;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  LoginController(this._authController);

  bool get isLoading => _authController.isLoading;
  String? get errorMessage => _authController.errorMessage;

  Future<bool> login() async {
    if (!formKey.currentState!.validate()) return false;

    final success = await _authController.signIn(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    return success;
  }

  void clearError() {
    _authController.clearError();
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
