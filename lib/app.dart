import 'package:flutter/material.dart';
import 'package:trabalhofinal/contato_list_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Contatos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ContatoListScreen(),
    );
  }
}
