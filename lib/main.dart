import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'firebase_options.dart';
import 'controllers/authController.dart';
import 'controllers/mangaController.dart';
import 'controllers/livroController.dart';
import 'repositories/authRepository.dart';
import 'repositories/mangaRepository.dart';
import 'repositories/livroRepository.dart';
import 'services/mangaSyncService.dart';
import 'services/livroSyncService.dart';
import 'services/sessionService.dart';
import 'screens/loginScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializa o FFI do sqflite para todas as plataformas não-web
  if (!kIsWeb) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (_) => AuthRepository(),
        ),
        Provider<MangaRepository>(
          create: (_) => MangaRepository(),
        ),
        Provider<LivroRepository>(
          create: (_) => LivroRepository(),
        ),
        Provider<MangaSyncService>(
          create: (_) => MangaSyncService(),
        ),
        Provider<LivroSyncService>(
          create: (_) => LivroSyncService(),
        ),
        ChangeNotifierProvider<AuthController>(
          create: (context) => AuthController(
            context.read<AuthRepository>(),
            SessionService(),
          ),
        ),
        ChangeNotifierProvider<MangaController>(
          create: (context) => MangaController(
            context.read<MangaRepository>(),
            context.read<MangaSyncService>(),
          ),
        ),
        ChangeNotifierProvider<LivroController>(
          create: (context) => LivroController(
            context.read<LivroRepository>(),
            context.read<LivroSyncService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Do Books',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 91, 90, 92)),
        ),
        home: const LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
