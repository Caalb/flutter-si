import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tarefa.dart';

class DatabaseHelper {
  late FirebaseFirestore _database;

  Future<void> open() async {
    _database = FirebaseFirestore.instance;
  }

  Future<void> insertTarefa(Tarefa tarefa) async {
    await open();
    await _database
        .collection("tarefas").doc().set(tarefa.toMap())
        .onError((e, _) => print("Error writing document: $e"));
  }

  Future<List<Tarefa>> getTarefas() async {
    try {
      await open();
      final snapshot = await _database.collection("tarefas").get();

      final tarefas = snapshot.docs.map((e) => Tarefa.fromSnapshot(e)).toList();

      return tarefas;
    } catch (e) {
      print('Erro ao recuperar tarefas: $e');
      return [];
    }
  }

  Future<void> deleteTarefa(String id) async {
    await _database.collection("tarefas").doc(id).delete();
  }

  Future<void> editarTarefa(Tarefa tarefaAtualizada) async {
    final docRef = _database.collection("tarefas").doc(tarefaAtualizada.id);
    docRef.update(tarefaAtualizada.toMap()).then(
            (value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
  }

  Future<void> deleteAllTarefas() async {
    // Implement the function to delete all tasks if needed
  }

  Future<void> close() async {
    // No need to close the connection in Firebase Firestore
  }
}