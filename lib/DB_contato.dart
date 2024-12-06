import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'contato.dart';

class DatabaseHelper {
  late FirebaseFirestore _database;

  Future<void> open() async {
    // ignore: deprecated_member_use
    _database = FirebaseFirestore.instance;
  }

  Future<void> insertContato(Contato contato) async {
    await open();
    await _database
        .collection("contatos").doc().set(contato.toMap())
        .onError((e, _) => print("Error writing document: $e"));
  }

  Future<List<Contato>> getContatos() async {
    try {
      await open();
      final snapshot = await _database.collection("contatos").get();

      final contatos = snapshot.docs.map((e) => Contato.fromSnapshot(e)).toList();

      return contatos;
    } catch (e) {
      print('Erro ao recuperar contatos: $e');
      return [];
    }
  }

  Future<void> deleteContato(String id) async {
    await _database.collection("contatos").doc(id).delete();
  }

  Future<void> editarContato(Contato contatoAtualizado) async {
    final docRef = _database.collection("contatos").doc(contatoAtualizado.id);
    docRef.update(contatoAtualizado.toMap()).then(
            (value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
  }

  Future<void> deleteAllContatos() async {
    //await _database.collection("contatos").doc().;
  }

  Future<void> close() async {
    // Não precisa fechar a conexão no Firebase Realtime Database
  }
}
