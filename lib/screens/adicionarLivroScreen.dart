import 'package:flutter/material.dart';
import '../models/livroModel.dart';

class AddEditLivroScreen extends StatefulWidget {
  final LivroModel? livro;

  const AddEditLivroScreen({super.key, this.livro});

  @override
  State<AddEditLivroScreen> createState() => _AddEditLivroScreenState();
}

class _AddEditLivroScreenState extends State<AddEditLivroScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomeController;
  late TextEditingController _autorController;
  late StatusLivro _selectedStatus;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.livro?.nome ?? '');
    _autorController = TextEditingController(text: widget.livro?.autor ?? '');
    _selectedStatus = widget.livro?.status ?? StatusLivro.queroLer;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _autorController.dispose();
    super.dispose();
  }

  void _saveLivro() {
    if (_formKey.currentState!.validate()) {
      final livro = LivroModel(
        id: widget.livro?.id, // Mantém o ID se estiver editando
        nome: _nomeController.text,
        autor: _autorController.text,
        status: _selectedStatus,
      );
      // Retorna o livro criado/editado para a tela anterior
      Navigator.of(context).pop(livro);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.livro == null ? 'Adicionar Livro' : 'Editar Livro'),
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
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _autorController,
                decoration: const InputDecoration(labelText: 'Autor'),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              DropdownButtonFormField<StatusLivro>(
                value: _selectedStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: StatusLivro.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.displayName),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedStatus = value!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveLivro,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}