// Importe o pacote necessario
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trabalhofinal/contato.dart';
import 'package:trabalhofinal/DB_contato.dart' as db_contato;

class VisualizarRegistrosScreen extends StatefulWidget {
  const VisualizarRegistrosScreen({super.key});

  @override
  _VisualizarRegistrosScreenState createState() =>
      _VisualizarRegistrosScreenState();
}

class _VisualizarRegistrosScreenState extends State<VisualizarRegistrosScreen> {
  List<Contato> _contatos = [];

  @override
  void initState() {
    super.initState();
    _carregarRegistros();
  }

  Future<void> _carregarRegistros() async {
    final dbHelper = db_contato.DatabaseHelper();
    await dbHelper.open();

    final contatos = await dbHelper.getContatos();
    setState(() {
      _contatos = contatos;
    });

    dbHelper.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registros do Banco'),
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
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: Container(
            color: Colors.black.withOpacity(0.3),
            child: ListView.builder(
              itemCount: _contatos.length,
              itemBuilder: (ctx, index) {
                return ListTile(
                  title: Text(
                    _contatos[index].nome,
                    style:
                    const TextStyle(color: Colors.white), // Cor do texto é branca
                  ),
                  subtitle: Text(
                    _contatos[index].telefone,
                    style:
                    const TextStyle(color: Colors.white), // Cor do texto é branca
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
