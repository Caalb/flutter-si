
import 'package:cloud_firestore/cloud_firestore.dart';

class Contato {
  late String id;
  late String nome;
  late String endereco;
  late String cpf;
  late String email;
  late String telefone;
  late String avatarUrl;

  Contato({
    required this.id,
    required this.nome,
    required this.endereco,
    required this.cpf,
    required this.email,
    required this.telefone,
    required this.avatarUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'endereco': endereco,
      'cpf': cpf,
      'email': email,
      'telefone': telefone,
      'avatarUrl': avatarUrl,
    };
  }

  Contato.fromMap(Map<dynamic, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
    endereco = map['endereco'];
    cpf = map['cpf'];
    email = map['email'];
    telefone = map['telefone'];
    avatarUrl = map['avatarUrl'];
  }

  factory Contato.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final data = documentSnapshot.data()!;
    return Contato(id: documentSnapshot.id, nome: data['nome'], endereco: data['endereco'], cpf: data['cpf'], email: data['email'], telefone: data['telefone'], avatarUrl: data['avatarUrl'],);
  }
}
