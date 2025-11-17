class Validadores {
  // ===== Usuário =====
  static String? validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email obrigatório.';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido.';
    }
    return null;
  }

  static String? validarPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha obrigatória.';
    }
    if (value.length < 6) {
      return 'A senha deve ter no mínimo 6 caracteres.';
    }
    return null;
  }

  static String? validarNome(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome obrigatório.';
    }
    return null;
  }

  static String? validarConfirmarPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Confirmação de senha obrigatória.';
    }
    if (password != confirmPassword) {
      return 'As senhas não coincidem.';
    }
    return null;
  }

  // ===== Tarefas =====
  static String? validarTitulo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Título da tarefa é obrigatório.';
    }
    if (value.length < 3) {
      return 'Título muito curto.';
    }
    return null;
  }

  static String? validarDescricao(String? value) {
    if (value != null && value.length > 200) {
      return 'Descrição não pode passar de 200 caracteres.';
    }
    return null;
  }

  static String? validarData(DateTime? date) {
    if (date == null) {
      return 'Data é obrigatória.';
    }
    if (date.isBefore(DateTime.now())) {
      return 'A data não pode ser no passado.';
    }
    return null;
  }
}
