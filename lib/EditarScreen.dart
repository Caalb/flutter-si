import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trabalhofinal/contato.dart';

class EditarContatoScreen extends StatefulWidget {
  final Function(Contato) atualizarContato;
  final Contato contatoExistente;

  const EditarContatoScreen({super.key,
    required this.atualizarContato,
    required this.contatoExistente,
  });

  @override
  _EditarContatoScreenState createState() => _EditarContatoScreenState();
}

class _EditarContatoScreenState extends State<EditarContatoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _cpfController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _avatarUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final contato = widget.contatoExistente;
    _nomeController.text = contato.nome;
    _enderecoController.text = contato.endereco ?? '';
    _cpfController.text = contato.cpf ?? '';
    _emailController.text = contato.email ?? '';
    _telefoneController.text = contato.telefone ?? '';
    _avatarUrlController.text = contato.avatarUrl ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Contato'),
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
            color: Colors.black.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nomeController,
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.6),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Digite o nome do contato';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _telefoneController,
                      decoration: InputDecoration(
                        labelText: 'Telefone',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.6),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Digite o Telefone do contato';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _enderecoController,
                      decoration: InputDecoration(
                        labelText: 'Endereço',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.6),
                      ),
                    ),
                    TextFormField(
                      controller: _cpfController,
                      decoration: InputDecoration(
                        labelText: 'CPF',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.6),
                      ),
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.6),
                      ),
                    ),
                    // Outros campos (endereço, CPF, email, telefone, avatarUrl) aqui
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final novoContato = Contato(
                            id: widget.contatoExistente.id,
                            nome: _nomeController.text,
                            endereco: _enderecoController.text,
                            cpf: _cpfController.text,
                            email: _emailController.text,
                            telefone: _telefoneController.text,
                            avatarUrl: _avatarUrlController.text,
                          );

                          widget.atualizarContato(novoContato);
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        // ignore: deprecated_member_use
                          backgroundColor: const Color.fromARGB(255, 212, 19, 5)),
                      child: const Text('Salvar'),
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
}
