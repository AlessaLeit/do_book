import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../services/firebaseService.dart';
import '../models/mangaModel.dart';
import '../models/livroModel.dart';

// DatabaseHelper com SQLite local e integração com Firebase para sincronização
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  final FirebaseService _firebaseService = FirebaseService();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'collections.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE mangas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        volume INTEGER NOT NULL,
        autor TEXT NOT NULL,
        status TEXT NOT NULL,
        colecaoCompleta INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE livros(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        autor TEXT NOT NULL,
        status TEXT NOT NULL
      )
    ''');
  }

  // Métodos para Mangás (local + Firebase)
  Future<void> insertManga(MangaModel manga) async {
    // Inserir local
    final db = await database;
    int localId = await db.insert('mangas', manga.toMap());
    manga.id = localId.toString();
    // Sincronizar com Firebase se logado
    if (_firebaseService.currentUser != null) {
      try {
        await _firebaseService.addManga(manga);
      } catch (e) {
        // Se falhar, continua local
        print('Erro ao sincronizar manga com Firebase: $e');
      }
    }
  }

  Future<List<MangaModel>> getMangas() async {
    // Tentar pegar do Firebase se logado, senão local
    if (_firebaseService.currentUser != null) {
      try {
        List<MangaModel> remoteMangas = await _firebaseService.getMangas();
        // Sincronizar local com remoto
        final db = await database;
        await db.delete('mangas'); // Limpar local
        for (var manga in remoteMangas) {
          await db.insert('mangas', manga.toMap());
        }
        return remoteMangas;
      } catch (e) {
        print('Erro ao pegar mangas do Firebase: $e');
        // Fallback para local
      }
    }

    // Pegar do local
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('mangas');
    return List.generate(maps.length, (i) => MangaModel.fromMap(maps[i]));
  }

  Future<void> updateManga(MangaModel manga) async {
    // Atualizar local
    final db = await database;
    await db.update('mangas', manga.toMap(), where: 'id = ?', whereArgs: [manga.id]);

    // Sincronizar com Firebase se logado
    if (_firebaseService.currentUser != null) {
      try {
        await _firebaseService.updateManga(manga);
      } catch (e) {
        print('Erro ao sincronizar update manga com Firebase: $e');
      }
    }
  }

  Future<void> deleteManga(int id) async {
    // Deletar local
    final db = await database;
    await db.delete('mangas', where: 'id = ?', whereArgs: [id]);

    // Sincronizar com Firebase se logado
    if (_firebaseService.currentUser != null) {
      try {
        await _firebaseService.deleteManga(id.toString());
      } catch (e) {
        print('Erro ao sincronizar delete manga com Firebase: $e');
      }
    }
  }

  // Métodos para Livros (local + Firebase)
  Future<void> insertLivro(LivroModel livro) async {
    // Inserir local
    final db = await database;
    int localId = await db.insert('livros', livro.toMap());
    livro.id = localId.toString();

    // Sincronizar com Firebase se logado
    if (_firebaseService.currentUser != null) {
      try {
        await _firebaseService.addLivro(livro);
      } catch (e) {
        print('Erro ao sincronizar livro com Firebase: $e');
      }
    }
  }

  Future<List<LivroModel>> getLivros() async {
    // Tentar pegar do Firebase se logado, senão local
    if (_firebaseService.currentUser != null) {
      try {
        List<LivroModel> remoteLivros = await _firebaseService.getLivros();
        // Sincronizar local com remoto
        final db = await database;
        await db.delete('livros'); // Limpar local
        for (var livro in remoteLivros) {
          await db.insert('livros', livro.toMap());
        }
        return remoteLivros;
      } catch (e) {
        print('Erro ao pegar livros do Firebase: $e');
        // Fallback para local
      }
    }

    // Pegar do local
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('livros');
    return List.generate(maps.length, (i) => LivroModel.fromMap(maps[i]));
  }

  Future<void> updateLivro(LivroModel livro) async {
    // Atualizar local
    final db = await database;
    await db.update('livros', livro.toMap(), where: 'id = ?', whereArgs: [livro.id]);

    // Sincronizar com Firebase se logado
    if (_firebaseService.currentUser != null) {
      try {
        await _firebaseService.updateLivro(livro);
      } catch (e) {
        print('Erro ao sincronizar update livro com Firebase: $e');
      }
    }
  }

  Future<void> deleteLivro(int id) async {
    // Deletar local
    final db = await database;
    await db.delete('livros', where: 'id = ?', whereArgs: [id]);

    // Sincronizar com Firebase se logado
    if (_firebaseService.currentUser != null) {
      try {
        await _firebaseService.deleteLivro(id.toString());
      } catch (e) {
        print('Erro ao sincronizar delete livro com Firebase: $e');
      }
    }
  }
}
