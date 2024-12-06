import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trabalhofinal/contato.dart';

class AdicionarContatoScreen extends StatefulWidget {
  final Function(Contato) adicionarContato;
  final Contato? contatoExistente; // Aceita um contato existente

  const AdicionarContatoScreen({super.key,
    required this.adicionarContato,
    this.contatoExistente, // Pode ser nulo
  });

  @override
  _AdicionarContatoScreenState createState() => _AdicionarContatoScreenState();

  void atualizarContato(Contato contato) {}
}

class _AdicionarContatoScreenState extends State<AdicionarContatoScreen> {
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
    // Preencha os campos com os dados do contato existente, se estiver definido
    if (widget.contatoExistente != null) {
      final contato = widget.contatoExistente!;
      _nomeController.text = contato.nome;
      _enderecoController.text = contato.endereco ?? ''; // Pode ser nulo
      _cpfController.text = contato.cpf ?? ''; // Pode ser nulo
      _emailController.text = contato.email ?? ''; // Pode ser nulo
      _telefoneController.text = contato.telefone; // Pode ser nulo
      _avatarUrlController.text = contato.avatarUrl ?? ''; // Pode ser nulo
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contatoExistente != null
            ? 'Editar Contato'
            : 'Adicionar Contato'),
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
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
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
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final contato = Contato(
                            id: widget.contatoExistente != null
                                ? widget.contatoExistente!.id
                                : DateTime.now().toString(),
                            nome: _nomeController.text,
                            endereco: _enderecoController.text,
                            cpf: _cpfController.text,
                            email: _emailController.text,
                            telefone: _telefoneController.text,
                            avatarUrl: _avatarUrlController.text,
                          );

                          if (widget.contatoExistente != null) {
                            widget.atualizarContato(
                                contato); // Atualize o contato existente
                          } else {
                            widget.adicionarContato(contato);
                          }

                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        // ignore: deprecated_member_use
                          backgroundColor: const Color.fromARGB(255, 212, 19, 5)),
                      child: Text(widget.contatoExistente != null
                          ? 'Salvar'
                          : 'Adicionar Contato'), // Altere o rótulo do botão com base na edição ou adição
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
