import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trabalhofinal/tarefa.dart';

class AdicionarTarefaScreen extends StatefulWidget {
  final Function(Tarefa) adicionarTarefa;
  final Tarefa? tarefaExistente;

  const AdicionarTarefaScreen({
    super.key,
    required this.adicionarTarefa,
    this.tarefaExistente,
  });

  @override
  _AdicionarTarefaScreenState createState() => _AdicionarTarefaScreenState();
}

class _AdicionarTarefaScreenState extends State<AdicionarTarefaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _dataVencimentoController = TextEditingController();
  bool _concluida = false;

  @override
  void initState() {
    super.initState();
    if (widget.tarefaExistente != null) {
      final tarefa = widget.tarefaExistente!;
      _tituloController.text = tarefa.titulo;
      _descricaoController.text = tarefa.descricao;
      _dataVencimentoController.text = tarefa.dataVencimento.toIso8601String();
      _concluida = tarefa.concluida;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.tarefaExistente != null ? 'Editar Tarefa' : 'Adicionar Tarefa',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF6200EE),
        elevation: 0,
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
            color: Colors.black.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildTextField(
                      controller: _tituloController,
                      label: 'Título',
                      icon: Icons.title,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _descricaoController,
                      label: 'Descrição',
                      icon: Icons.description,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _dataVencimentoController,
                      label: 'Data de Vencimento',
                      icon: Icons.calendar_today,
                      isDate: true,
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Concluída'),
                      value: _concluida,
                      activeColor: const Color(0xFF6200EE),
                      onChanged: (bool? value) {
                        setState(() {
                          _concluida = value ?? false;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final tarefa = Tarefa(
                            id: widget.tarefaExistente != null
                                ? widget.tarefaExistente!.id
                                : DateTime.now().toString(),
                            titulo: _tituloController.text,
                            descricao: _descricaoController.text,
                            dataVencimento: DateTime.parse(_dataVencimentoController.text),
                            concluida: _concluida,
                          );

                          widget.adicionarTarefa(tarefa);

                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: const Color(0xFF6200EE),
                      ),
                      child: Text(
                        widget.tarefaExistente != null ? 'Salvar' : 'Adicionar Tarefa',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isDate = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Por favor, preencha o campo $label.';
        }
        if (isDate) {
          try {
            DateTime.parse(value);
          } catch (e) {
            return 'Por favor, insira uma data válida.';
          }
        }
        return null;
      },
      onTap: isDate
          ? () async {
        FocusScope.of(context).requestFocus(FocusNode());
        await _selectDate(context);
      }
          : null,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dataVencimentoController.text = picked.toIso8601String();
      });
    }
  }
}

