import 'package:firebase_database/firebase_database.dart';
import 'package:trabalhofinal/contato.dart';

class ContatosDatabase {
  static final ContatosDatabase instance = ContatosDatabase._init();

  late DatabaseReference _database;

  ContatosDatabase._init() {
    // ignore: deprecated_member_use
    _database = FirebaseDatabase.instance.ref('contatos');
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    DataSnapshot snapshot = (await _database.once()) as DataSnapshot;

    if (!snapshot.exists) {
      return [];
    }

    Object? data = snapshot.value;
    List<Map<String, dynamic>> dataList = [];

    if (data is Map) {
      data.forEach((key, value) {
        if (value is Map) {
          dataList.add(Map<String, dynamic>.from(value));
        }
      });
    }

    return dataList;
  }

  Future<int> insert(Contato contato) async {
    DatabaseReference newRef = _database.push();

    await newRef.set(contato.toMap());
    return 1; // Retorne o valor desejado
  }

  Future<int> update(Contato contato) async {
    await _database.child(contato.id).update(contato.toMap());
    return 1; // Retorne o valor desejado
  }

  Future<int> delete(String id) async {
    await _database.child(id).remove();
    return 1; // Retorne o valor desejado
  }
}
