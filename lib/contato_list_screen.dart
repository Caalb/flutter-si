//contato_list_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:trabalhofinal/contato.dart';
import 'package:trabalhofinal/EditarScreen.dart' as edit;
import 'package:trabalhofinal/AdicionarScreen.dart' as addScreen;
import 'package:trabalhofinal/visualizar_registros_screen.dart';

import 'DB_contato.dart';

class ContatoListScreen extends StatefulWidget {
  const ContatoListScreen({super.key});

  @override
  _ContatoListScreenState createState() => _ContatoListScreenState();
}

class _ContatoListScreenState extends State<ContatoListScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Contato> _contatos = [];

  @override
  void initState() {
    super.initState();
    _carregarRegistros();
  }

  void _carregarRegistros() async {
    await _databaseHelper.open();
    List<Contato> contatos = await _databaseHelper.getContatos();
    setState(() {
      _contatos = contatos;
    });
  }

  Future<void> _confirmarRemoverContato(String id, String nome) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Deseja realmente excluir o contato: $nome?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () {
                _removerContato(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmarRemoverTodosContatos() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dica Firebase'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Não é recomendável excluir coleções do cliente.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _adicionarContato(Contato novoContato) async {
    await _databaseHelper.insertContato(novoContato);
    _contatos = await _databaseHelper.getContatos();

    setState(() {});
  }

  void _removerContato(String id) {
    setState(() {
      _contatos.removeWhere((contato) => contato.id == id);
      _databaseHelper.deleteContato(id);
    });
  }

  void _removerTodosContatos() {
    setState(() {
      _contatos.clear();
      _databaseHelper.deleteAllContatos();
    });
  }

  void _editarContato(Contato contatoExistente) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => edit.EditarContatoScreen(
          atualizarContato: (novoContato) {
            _atualizarContato(contatoExistente.id, novoContato);
          },
          contatoExistente: contatoExistente,
        ),
      ),
    );
  }

  void _atualizarContato(String id, Contato novoContato) {
    _databaseHelper.editarContato(novoContato);
    setState(() {
      final index = _contatos.indexWhere((contato) => contato.id == id);

      if (index != -1) {
        _contatos[index] = novoContato;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Contatos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              _confirmarRemoverTodosContatos();
            },
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const VisualizarRegistrosScreen(),
                ),
              );
            },
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 212, 19, 5),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imagen/img.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: 3.0,
              sigmaY:
              3.0), // Ajuste o valor de sigmaX e sigmaY para controlar o nível de desfoque
          child: Container(
            color: Colors.black.withOpacity(0.3), // Cor e opacidade do filtro
            child: ListView.builder(
              itemCount: _contatos.length,
              itemBuilder: (ctx, index) {
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage('assets/imagen/person.png'),
                  ),
                  title: Text(_contatos[index].nome),
                  textColor: const Color.fromARGB(255, 255, 255, 255),
                  subtitle: Text(_contatos[index].telefone),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        color: Colors.amber,
                        onPressed: () {
                          _editarContato(_contatos[index]);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: const Color.fromARGB(255, 139, 5, 5),
                        onPressed: () {
                          _confirmarRemoverContato(
                              _contatos[index].id, _contatos[index].nome);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => addScreen.AdicionarContatoScreen(
                adicionarContato: _adicionarContato,
              ),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 212, 19, 5),
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 212, 19, 5),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Sobre'),
              onTap: () {
                // Adicionar navegação para a página "Sobre"
                Navigator.pop(context); // Fecha o Drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SobrePage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Help'),
              onTap: () {
                // Adicionar navegação para a página "Help"
                Navigator.pop(context); // Fecha o Drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelpPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Página "Sobre"
class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
        backgroundColor: const Color.fromARGB(255, 212, 19, 5),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imagen/img.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3.0,
            sigmaY: 3.0,
          ),
          child: Container(
            color: Colors.black.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'O app de gerenciamento de contatos foi criado para oferecer uma maneira eficiente e intuitiva de organizar informações de contatos. Destinado a qualquer pessoa que queira manter uma lista personalizada, o app permite adição, edição, exclusão e visualização detalhada de registros.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Versão: 1.0',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Data de criação: 26/10/2024',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 35),
                  const Text(
                    'Membros do grupo:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildMembro('Ana Júlia', 'assets/imagen/avatar1.png'),
                  // const SizedBox(height: 20),
                  // _buildMembro('Bianca Rangel', 'assets/imagen/avatar2.png'),
                  // const SizedBox(height: 20),
                  // _buildMembro('Pedro Henrique', 'assets/imagen/avatar3.jpg'),
                  // const SizedBox(height: 20),
                  // _buildMembro('Gabriel Ferreira', 'assets/imagen/avatar4.jpg'),
                  // const SizedBox(height: 20),
                  // _buildMembro('Lucas Gabriel', 'assets/imagen/avatar5.jpg'),
                  // const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMembro(String nome, String avatarUrl) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage(avatarUrl),
        ),
        const SizedBox(width: 8),
        Text(
          nome,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

// Página "Help"
class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
        backgroundColor: const Color.fromARGB(255, 212, 19, 5),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imagen/img.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3.0,
            sigmaY: 3.0,
          ),
          child: Container(
            color: Colors.black.withOpacity(0.3),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Instruções de como usar o App:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '1. Adicione contatos clicando no botão de adicionar (+).',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '2. Para editar um contato, clique no ícone de edição.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '3. Para excluir um contato, clique no ícone de lixeira.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '4. Para visualizar todos os registros do banco, clique no ícone de lista.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '5. No menu lateral, você encontra as opções "Sobre" e "Help".',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
