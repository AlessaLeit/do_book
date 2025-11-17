class LivroModel {
  String? id;
  String nome;
  String autor;
  StatusLivro status;

  LivroModel({
    this.id,
    required this.nome,
    required this.autor,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'autor': autor,
      'status': status.name,
    };
  }

  factory LivroModel.fromMap(Map<String, dynamic> map) {
    return LivroModel(
      id: map['id']?.toString(),
      nome: map['nome'],
      autor: map['autor'],
      status: StatusLivro.values.firstWhere(
        (e) => e.name == map['status'],
      ),
    );
  }

  LivroModel copyWith({
    String? id,
    String? nome,
    String? autor,
    StatusLivro? status,
  }) {
    return LivroModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      autor: autor ?? this.autor,
      status: status ?? this.status,
    );
  }
}

enum StatusLivro {
  possuido,
  lendo,
  queroLer,
}

extension StatusLivroExtension on StatusLivro {
  String get displayName {
    switch (this) {
      case StatusLivro.possuido:
        return 'Possuído';
      case StatusLivro.lendo:
        return 'Lendo';
      case StatusLivro.queroLer:
        return 'Quero Ler';
    }
  }
}
