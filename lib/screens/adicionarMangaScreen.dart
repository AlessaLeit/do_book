import 'package:flutter/material.dart';
import '../models/mangaModel.dart';
import '../controllers/mangaController.dart';
import 'package:provider/provider.dart';

class AddEditMangaScreen extends StatefulWidget {
  final MangaModel? manga;

  const AddEditMangaScreen({super.key, this.manga});

  @override
  State<AddEditMangaScreen> createState() => _AddEditMangaScreenState();
}

class _AddEditMangaScreenState extends State<AddEditMangaScreen> {
  final _formKey = GlobalKey<FormState>();
  late MangaController _mangaController;

  late TextEditingController _nomeController;
  late TextEditingController _volumeController;
  late TextEditingController _autorController;
  late Status _selectedStatus;
  late bool _colecaoCompleta;

  @override
  void initState() {
    super.initState();
    _mangaController = context.read<MangaController>();
    _nomeController = TextEditingController(text: widget.manga?.nome ?? '');
    _volumeController = TextEditingController(text: widget.manga?.volume.toString() ?? '');
    _autorController = TextEditingController(text: widget.manga?.autor ?? '');
    _selectedStatus = widget.manga?.status ?? Status.possuido;
    _colecaoCompleta = widget.manga?.colecaoCompleta ?? false;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _volumeController.dispose();
    _autorController.dispose();
    super.dispose();
  }

  Future<void> _saveManga() async {
    if (_formKey.currentState!.validate()) {
      try {
        final manga = MangaModel(
          id: widget.manga?.id,
          nome: _nomeController.text,
          volume: int.parse(_volumeController.text),
          autor: _autorController.text,
          status: _selectedStatus,
          colecaoCompleta: _colecaoCompleta,
        );

        if (widget.manga == null) {
          await _mangaController.addManga(manga);
        } else {
          await _mangaController.updateManga(manga);
        }

        Navigator.of(context).pop(true); // Return true to indicate success
      } catch (e) {
        print('Erro ao salvar mangá: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar mangá: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.manga == null ? 'Adicionar Manga' : 'Editar Manga'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _volumeController,
                decoration: const InputDecoration(labelText: 'Volume'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Campo obrigatório';
                  if (int.tryParse(value) == null) return 'Digite um número válido';
                  return null;
                },
              ),
              TextFormField(
                controller: _autorController,
                decoration: const InputDecoration(labelText: 'Autor'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              DropdownButtonFormField<Status>(
                value: _selectedStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: Status.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.displayName),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedStatus = value!),
              ),
              SwitchListTile(
                title: const Text('Coleção Completa'),
                value: _colecaoCompleta,
                onChanged: (value) => setState(() => _colecaoCompleta = value),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveManga,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
