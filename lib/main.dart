import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:device_preview/device_preview.dart';

import 'pages/login_page.dart';
import 'providers/produto_provider.dart';
import 'providers/usuario_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Configuração do SQLite para o Flutter Web.
  databaseFactory = databaseFactoryFfiWeb;

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => UsuarioProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => ProdutoProvider(),
          ),
        ],
        child: const ControleEstoqueApp(),
      ),
    ),
  );
}

class ControleEstoqueApp extends StatelessWidget {
  const ControleEstoqueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Configuração do Device Preview
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      title: 'Controle de Estoque',

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
      ),

      home: const LoginPage(),
    );
  }
}