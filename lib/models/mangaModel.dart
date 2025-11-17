class MangaModel {
  String? id;
  String nome;
  int volume;
  String autor;
  Status status;
  bool colecaoCompleta;

  MangaModel({
    this.id,
    required this.nome,
    required this.volume,
    required this.autor,
    required this.status,
    required this.colecaoCompleta,
  });

  @override
  String toString() {
    return 'MangaModel{id: $id, nome: $nome, volume: $volume, autor: $autor, status: $status, colecaoCompleta: $colecaoCompleta}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'volume': volume,
      'autor': autor,
      'status': status.name,
      'colecaoCompleta': colecaoCompleta ? 1 : 0,
    };
  }

  factory MangaModel.fromMap(Map<String, dynamic> map) {
    return MangaModel(
      id: map['id']?.toString(),
      nome: map['nome'],
      volume: map['volume'],
      autor: map['autor'],
      status: Status.values.firstWhere((e) => e.name == map['status']),
      colecaoCompleta: map['colecaoCompleta'] == 1 || map['colecaoCompleta'] == true,
    );
  }

  MangaModel copyWith({
    String? id,
    String? nome,
    int? volume,
    String? autor,
    Status? status,
    bool? colecaoCompleta,
  }) {
    return MangaModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      volume: volume ?? this.volume,
      autor: autor ?? this.autor,
      status: status ?? this.status,
      colecaoCompleta: colecaoCompleta ?? this.colecaoCompleta,
    );
  }
}

enum Status {
  possuido,
  aCaminho,
  comprado,
}

extension StatusExtension on Status {
  String get displayName {
    switch (this) {
      case Status.possuido:
        return 'Possuído';
      case Status.aCaminho:
        return 'A caminho';
      case Status.comprado:
        return 'Comprado';
    }
  }
}
