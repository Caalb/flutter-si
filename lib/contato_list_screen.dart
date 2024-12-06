import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:trabalhofinal/tarefa.dart';
import 'package:trabalhofinal/EditarScreen.dart' as edit;
import 'package:trabalhofinal/AdicionarScreen.dart' as addScreen;
import 'package:trabalhofinal/visualizar_registros_screen.dart';
import 'DB_contato.dart';

class TarefaListScreen extends StatefulWidget {
  const TarefaListScreen({super.key});

  @override
  _TarefaListScreenState createState() => _TarefaListScreenState();
}

class _TarefaListScreenState extends State<TarefaListScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Tarefa> _tarefas = [];

  @override
  void initState() {
    super.initState();
    _carregarRegistros();
  }

  void _carregarRegistros() async {
    await _databaseHelper.open();
    List<Tarefa> tarefas = await _databaseHelper.getTarefas();
    setState(() {
      _tarefas = tarefas;
    });
  }

  Future<void> _confirmarRemoverTarefa(String id, String titulo) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Deseja realmente excluir a tarefa: $titulo?'),
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
                _removerTarefa(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmarRemoverTodasTarefas() async {
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

  void _adicionarTarefa(Tarefa novaTarefa) async {
    await _databaseHelper.insertTarefa(novaTarefa);
    _tarefas = await _databaseHelper.getTarefas();

    setState(() {});
  }

  void _removerTarefa(String id) {
    setState(() {
      _tarefas.removeWhere((tarefa) => tarefa.id == id);
      _databaseHelper.deleteTarefa(id);
    });
  }

  void _removerTodasTarefas() {
    setState(() {
      _tarefas.clear();
      _databaseHelper.deleteAllTarefas();
    });
  }

  void _editarTarefa(Tarefa tarefaExistente) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => edit.EditarTarefaScreen(
          atualizarTarefa: (novaTarefa) {
            _atualizarTarefa(tarefaExistente.id, novaTarefa);
          },
          tarefaExistente: tarefaExistente,
        ),
      ),
    );
  }

  void _atualizarTarefa(String id, Tarefa novaTarefa) {
    _databaseHelper.editarTarefa(novaTarefa);
    setState(() {
      final index = _tarefas.indexWhere((tarefa) => tarefa.id == id);

      if (index != -1) {
        _tarefas[index] = novaTarefa;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              _confirmarRemoverTodasTarefas();
            },
            color: Colors.white,
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
        backgroundColor: const Color(0xFF6200EE),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imagen/img.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: Container(
            color: Colors.black.withOpacity(0.3),
            child: ListView.builder(
              itemCount: _tarefas.length,
              itemBuilder: (ctx, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage('assets/imagen/person.png'),
                    ),
                    title: Text(_tarefas[index].titulo),
                    subtitle: Text(_tarefas[index].descricao),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: Colors.amber,
                          onPressed: () {
                            _editarTarefa(_tarefas[index]);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            _confirmarRemoverTarefa(_tarefas[index].id, _tarefas[index].titulo);
                          },
                        ),
                      ],
                    ),
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
              builder: (ctx) => addScreen.AdicionarTarefaScreen(
                adicionarTarefa: _adicionarTarefa,
              ),
            ),
          );
        },
        backgroundColor: const Color(0xFF6200EE),
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF6200EE),
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
                Navigator.pop(context);
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
                Navigator.pop(context);
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

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
        backgroundColor: const Color(0xFF6200EE),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imagen/img.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
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

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
        backgroundColor: const Color(0xFF6200EE),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imagen/img.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
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