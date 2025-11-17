import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/mangaModel.dart';
import '../models/livroModel.dart';
import '../controllers/mangaController.dart';
import '../controllers/livroController.dart';
import 'adicionarMangaScreen.dart';
import 'adicionarLivroScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() => _isLoading = true);

    final mangaController = context.read<MangaController>();
    final livroController = context.read<LivroController>();

    await Future.wait([
      mangaController.loadMangas(),
      livroController.loadLivros(),
    ]);

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _reloadData() {
    _loadData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mangaController = context.watch<MangaController>();
    final livroController = context.watch<LivroController>();

    // Agrupar mangas por nome (título da coleção)
    final Map<String, List<MangaModel>> groupedMangas = {};
    for (final manga in mangaController.mangas) {
      if (!groupedMangas.containsKey(manga.nome)) {
        groupedMangas[manga.nome] = [];
      }
      groupedMangas[manga.nome]!.add(manga);
    }

    final List<Widget> _widgetOptions = <Widget>[
      // View de Mangás (index 0)
      _isLoading
          ? const Center(child: CircularProgressIndicator())
          : groupedMangas.isEmpty
              ? const Center(child: Text('Nenhum mangá adicionado ainda.'))
              : ListView.builder(
                  itemCount: groupedMangas.keys.length,
                  itemBuilder: (context, index) {
                    final title = groupedMangas.keys.elementAt(index);
                    final volumes = groupedMangas[title]!;
                    // Ordena os volumes em ordem crescente
                    volumes.sort((a, b) => a.volume.compareTo(b.volume));
                    return ExpansionTile(
                      title: Text(title),
                      subtitle: Text('${volumes.length} volume(s)'),
                      children: volumes.map((manga) {
                        return _buildMangaTile(manga);
                      }).toList(),
                    );
                  },
                ),
      // View de Livros (index 1)
      _isLoading
          ? const Center(child: CircularProgressIndicator())
          : livroController.livros.isEmpty
              ? const Center(child: Text('Nenhum livro adicionado ainda.'))
              : ListView.builder(
                  itemCount: livroController.livros.length,
                  itemBuilder: (context, index) {
                    final livro = livroController.livros[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: _buildLivroTile(livro),
                    );
                  },
                ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Coleção de Mangás' : 'Coleção de Livros'),
        actions: [
          // Este botão pode ser removido se a nav bar for suficiente
          PopupMenuButton<String>(
            onSelected: (value) {
              // Navegação para diferentes coleções
              if (value == 'mangas') {
                // Navegar para coleção de mangás
              } else if (value == 'livros') {
                // Navegar para coleção de livros
              } else if (value == 'geral') {
                // Navegar para coleção geral
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'mangas',
                child: Text('Coleção de Mangás'),
              ),
              const PopupMenuItem<String>(
                value: 'livros',
                child: Text('Coleção de Livros'),
              ),
              const PopupMenuItem<String>(
                value: 'geral',
                child: Text('Coleção Geral'),
              ),
            ],
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_selectedIndex == 0) {
            // Adicionar apenas se estiver na aba de mangás
            final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddEditMangaScreen()));
            if (result == true) {
              _reloadData();
            }
          } else {
            // Navega para a tela de adicionar livro
            final novoLivro = await Navigator.push<LivroModel>(
              context,
              MaterialPageRoute(builder: (context) => const AddEditLivroScreen()),
            );

            if (novoLivro != null) {
              await livroController.addLivro(novoLivro);
              _reloadData();
            }
          }
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Mangás',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Livros',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  // Widget extraído para melhor organização
  Widget _buildMangaTile(MangaModel manga) {
    final mangaController = context.read<MangaController>();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: ListTile(
        title: Text('Vol. ${manga.volume}'),
        subtitle: Text('${manga.autor} - ${manga.colecaoCompleta ? 'Coleção Completa' : 'Coleção Incompleta'}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(manga.status.displayName),
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'edit') {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return AddEditMangaScreen(manga: manga);
                    }),
                  );
                  if (result == true) {
                    _reloadData();
                  }
                } else if (value == 'delete') {
                  await mangaController.deleteManga(manga.id!);
                  _reloadData();
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('Editar'),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('Deletar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget para construir o tile de um livro
  Widget _buildLivroTile(LivroModel livro) {
    final livroController = context.read<LivroController>();
    return ListTile(
      title: Text(livro.nome),
      subtitle: Text(livro.autor),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(livro.status.displayName),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'edit') {
                // Simula a edição exibindo uma mensagem
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Simulando edição para: ${livro.nome}')),
                );
                // A lógica de edição pode ser implementada aqui, similar à de adicionar
                final livroEditado = await Navigator.push<LivroModel>(
                    context, MaterialPageRoute(builder: (context) => AddEditLivroScreen(livro: livro)));
                if (livroEditado != null) {
                  await livroController.updateLivro(livroEditado);
                  _reloadData();
                }
              } else if (value == 'delete') {
                await livroController.deleteLivro(livro.id!);
                _reloadData();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${livro.nome} foi removido.')),
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'edit',
                child: Text('Editar'),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Deletar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
