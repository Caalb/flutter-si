import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trabalhofinal/tarefa.dart';
import 'package:trabalhofinal/DB_contato.dart' as db_contato;

class VisualizarRegistrosScreen extends StatefulWidget {
  const VisualizarRegistrosScreen({super.key});

  @override
  _VisualizarRegistrosScreenState createState() =>
      _VisualizarRegistrosScreenState();
}

class _VisualizarRegistrosScreenState extends State<VisualizarRegistrosScreen> {
  List<Tarefa> _tarefas = [];

  @override
  void initState() {
    super.initState();
    _carregarRegistros();
  }

  Future<void> _carregarRegistros() async {
    final dbHelper = db_contato.DatabaseHelper();
    await dbHelper.open();

    final tarefas = await dbHelper.getTarefas();
    setState(() {
      _tarefas = tarefas;
    });

    dbHelper.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registros do Banco'),
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
                    title: Text(
                      _tarefas[index].titulo,
                      style: const TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      _tarefas[index].descricao,
                      style: const TextStyle(color: Colors.black54),
                    ),
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