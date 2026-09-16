import 'package:flutter/material.dart';

import '../models/usuario.dart';
import '../services/usuario_service.dart';

class UsuarioProvider extends ChangeNotifier {
  final UsuarioService _service = UsuarioService();

  Usuario? usuarioLogado;
  bool carregando = false;

  Future<bool> cadastrar(String nome, String email, String senha) async {
    carregando = true;
    notifyListeners();

    final sucesso = await _service.cadastrarUsuario(
      Usuario(nome: nome, email: email, senha: senha),
    );

    carregando = false;
    notifyListeners();
    return sucesso;
  }

  Future<bool> entrar(String email, String senha) async {
    carregando = true;
    notifyListeners();

    usuarioLogado = await _service.login(email, senha);

    carregando = false;
    notifyListeners();
    return usuarioLogado != null;
  }

  void sair() {
    usuarioLogado = null;
    notifyListeners();
  }
}
