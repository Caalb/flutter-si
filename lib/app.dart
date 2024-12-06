import 'package:flutter/material.dart';
import 'package:trabalhofinal/contato_list_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Contatos',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.light,
        textTheme: const TextTheme(
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          titleTextStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.deepPurple,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: const TarefaListScreen(),
    );
  }
}