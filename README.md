# Do Books - Documentação

## Visão Geral

**Do Books** é um aplicativo Flutter desenvolvido para gerenciar coleções pessoais de mangás e livros. O app permite aos usuários organizar suas coleções, acompanhar o status de leitura e manter um inventário digital de suas obras favoritas.

### Funcionalidades Principais

- **Autenticação**: Tela de login e cadastro via Firebase Authentication.
- **Gerenciamento de Mangás**:
  - Adicionar, editar e remover mangás.
  - Acompanhar volumes individuais.
  - Status: Possuído, A caminho, Comprado.
  - Indicação se a coleção está completa.
- **Gerenciamento de Livros**:
  - Adicionar, editar e remover livros.
  - Status: Possuído, Lendo, Quero Ler.
- **Interface Intuitiva**: Navegação por abas (Mangás e Livros), listas expansíveis para mangás agrupados por título.
- **Banco de Dados**: SQLite local para persistência de dados.
- **Sincronização**: Serviços para sincronização de dados (mangás e livros) com Firebase Firestore.

### Tecnologias Utilizadas

- **Flutter**: Framework para desenvolvimento multiplataforma.
- **Dart**: Linguagem de programação.
- **SQLite (sqflite)**: Banco de dados local.
- **sqflite_common_ffi**: Suporte para plataformas desktop.
- **Firebase Core**: Inicialização do Firebase.
- **Firebase Auth**: Autenticação de usuários.
- **Cloud Firestore**: Banco de dados NoSQL em nuvem.
- **Provider**: Gerenciamento de estado.
- **Shared Preferences**: Armazenamento local de preferências.
- **table_calendar**: Biblioteca para calendários (não utilizada no código atual).
- **Path**: Manipulação de caminhos de arquivos.

## Arquitetura do Projeto

O projeto segue uma arquitetura MVC (Model-View-Controller) com separação de responsabilidades, utilizando Provider para gerenciamento de estado:

```
lib/
├── main.dart                 # Ponto de entrada do app
├── controllers/
│   ├── authController.dart   # Controlador para autenticação
│   ├── livroController.dart  # Controlador para livros
│   ├── loginController.dart  # Controlador para login
│   └── mangaController.dart  # Controlador para mangás
├── models/
│   ├── livroModel.dart       # Modelo de dados para Livro
│   ├── mangaModel.dart       # Modelo de dados para Mangá
│   └── userModel.dart        # Modelo de dados para Usuário
├── repositories/
│   ├── authRepository.dart   # Repositório para operações de autenticação
│   ├── livroRepository.dart  # Repositório para operações de livros
│   └── mangaRepository.dart  # Repositório para operações de mangás
├── screens/
│   ├── adicionarLivroScreen.dart  # Tela para adicionar/editar livro
│   ├── adicionarMangaScreen.dart  # Tela para adicionar/editar mangá
│   ├── cadastroScreen.dart   # Tela de cadastro
│   ├── homeScreen.dart       # Tela principal com coleções
│   └── loginScreen.dart      # Tela de login
├── services/
│   ├── authService.dart      # Serviço de autenticação Firebase
│   ├── firebaseService.dart  # Serviço Firebase geral
│   ├── livroSyncService.dart # Serviço de sincronização de livros
│   ├── mangaSyncService.dart # Serviço de sincronização de mangás
│   └── sessionService.dart   # Serviço de sessão
├── database/
│   └── databaseHelper.dart   # Helper para operações no banco de dados SQLite
└── utils/
    ├── cores.dart            # Definições de cores
    └── validadores.dart      # Funções de validação
```

### Modelos de Dados

#### Manga
- `id`: Identificador único (int?)
- `nome`: Nome da série (String)
- `volume`: Número do volume (int)
- `autor`: Autor da obra (String)
- `status`: Status da posse (enum Status: possuido, aCaminho, comprado)
- `colecaoCompleta`: Indica se a coleção está completa (bool)

#### Livro
- `id`: Identificador único (int?)
- `nome`: Título do livro (String)
- `autor`: Autor da obra (String)
- `status`: Status de leitura (enum StatusLivro: possuido, lendo, queroLer)

### Banco de Dados

O banco de dados SQLite é configurado com duas tabelas principais:

#### Tabela `mangas`
```sql
CREATE TABLE mangas(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  volume INTEGER NOT NULL,
  autor TEXT NOT NULL,
  status TEXT NOT NULL,
  colecaoCompleta INTEGER NOT NULL
)
```

#### Tabela `livros`
```sql
CREATE TABLE livros(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  autor TEXT NOT NULL,
  status TEXT NOT NULL
)
```

**Nota**: Atualmente, o app usa dados mockados na `HomeScreen` em vez de consultar o banco diretamente. O `DatabaseHelper` está implementado mas não integrado completamente.

### Telas e Navegação

1. **LoginScreen**: Tela inicial com formulário de login (validação básica).
2. **CadastroScreen**: Tela de registro (não lida na documentação atual).
3. **HomeScreen**: Tela principal com navegação por abas.
   - Aba Mangás: Lista expansível agrupada por título da série.
   - Aba Livros: Lista simples de livros.
   - FAB para adicionar novos itens.
4. **AddEditMangaScreen**: Formulário para adicionar/editar mangás.
5. **AddEditLivroScreen**: Formulário para adicionar/editar livros.

### Utilitários

- **Cores**: Classe com constantes de cores para manter consistência visual.
- **Validadores**: Funções estáticas para validação de formulários (emails, senhas, etc.).

## Instalação e Execução

Para plataformas desktop (Windows/Linux/Mac), o sqflite_ffi é usado automaticamente.

## Uso do Aplicativo

1. **Login**: Insira qualquer email e senha (mín. 6 caracteres) para acessar.
2. **Navegação**: Use a barra inferior para alternar entre Mangás e Livros.
3. **Adicionar Itens**: Toque no botão "+" para adicionar mangás ou livros.
4. **Editar/Deletar**: Use o menu de três pontos em cada item para editar ou remover.
5. **Visualização**: Mangás são agrupados por série; livros são listados individualmente.

## Melhorias Futuras

- Integração completa com o banco de dados (remover dados mockados).
- Sincronização em nuvem (já parcialmente implementada com Firestore).
- Funcionalidades avançadas: busca, filtros, estatísticas de leitura.
- Suporte a capas de livros/mangás.
- Calendário de leitura integrado (usando table_calendar).
- Tema escuro/claro.

