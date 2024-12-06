// lib/tarefa.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Tarefa {
  late String id;
  late String titulo;
  late String descricao;
  late DateTime dataVencimento;
  late bool concluida;

  Tarefa({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.dataVencimento,
    required this.concluida,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'dataVencimento': dataVencimento.toIso8601String(),
      'concluida': concluida,
    };
  }

  Tarefa.fromMap(Map<dynamic, dynamic> map) {
    id = map['id'];
    titulo = map['titulo'];
    descricao = map['descricao'];
    dataVencimento = DateTime.parse(map['dataVencimento']);
    concluida = map['concluida'];
  }

  factory Tarefa.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final data = documentSnapshot.data()!;
    return Tarefa(
      id: documentSnapshot.id,
      titulo: data['titulo'],
      descricao: data['descricao'],
      dataVencimento: DateTime.parse(data['dataVencimento']),
      concluida: data['concluida'],
    );
  }
}