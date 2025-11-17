# TODO: Migrar para Firebase com SQLite Local e Sincronização

## Passos a Completar

- [x] Adicionar dependências Firebase no pubspec.yaml (firebase_core, firebase_auth, cloud_firestore)
- [x] Corrigir DatabaseHelper para SQLite funcionar (remover comentário, ajustar implementação)
- [x] Inicializar Firebase no main.dart
- [x] Criar lib/services/firebaseService.dart para autenticação e Firestore
- [x] Modificar lib/database/databaseHelper.dart para integrar Firebase + SQLite com sincronização
- [x] Criar controllers e repositories para gerenciar dados
- [x] Atualizar telas de login/cadastro para usar Firebase Auth
- [x] Atualizar telas que usam DB para sincronização
- [x] Corrigir erros de compilação no main.dart
- [ ] Instalar dependências com flutter pub get
- [ ] Configurar Firebase (baixar google-services.json, etc.)
- [ ] Testar autenticação e CRUD
