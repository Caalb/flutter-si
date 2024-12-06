import 'package:firebase_database/firebase_database.dart';
import 'package:trabalhofinal/tarefa.dart';

class ContatosDatabase {
  static final ContatosDatabase instance = ContatosDatabase._init();

  late DatabaseReference _database;

  ContatosDatabase._init() {
    _database = FirebaseDatabase.instance.ref('tarefas');
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

  Future<int> insert(Tarefa tarefa) async {
    DatabaseReference newRef = _database.push();

    await newRef.set(tarefa.toMap());
    return 1; // Return the desired value
  }

  Future<int> update(Tarefa tarefa) async {
    await _database.child(tarefa.id).update(tarefa.toMap());
    return 1; // Return the desired value
  }

  Future<int> delete(String id) async {
    await _database.child(id).remove();
    return 1; // Return the desired value
  }
}