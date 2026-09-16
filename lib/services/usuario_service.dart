import 'package:sqflite/sqflite.dart';

import '../models/usuario.dart';
import 'banco_service.dart';

class UsuarioService {
  final BancoService _bancoService = BancoService.instance;

  Future<bool> emailExiste(String email) async {
    final db = await _bancoService.banco;

    final resultado = await db.query(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    return resultado.isNotEmpty;
  }

  Future<bool> cadastrarUsuario(Usuario usuario) async {
    final db = await _bancoService.banco;

    if (await emailExiste(usuario.email)) {
      return false;
    }

    await db.insert('usuarios', usuario.toMap());
    print('INSERT → Usuário cadastrado: ${usuario.nome}');
    return true;
  }

  Future<Usuario?> login(String email, String senha) async {
    final db = await _bancoService.banco;

    print('SELECT → Procurando usuário: $email');

    final resultado = await db.query(
      'usuarios',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
      limit: 1,
    );

    if (resultado.isEmpty) {
      print('SELECT → Usuário não encontrado');
      return null;
    }

    final usuario = Usuario.fromMap(resultado.first);
    print('SELECT → Usuário encontrado: ${usuario.nome}');
    return usuario;
  }
}
