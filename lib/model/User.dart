import 'dart:convert';

class User {

  final int? id;
  final String nome;
  final String email;

  final String password;

  User({this.id, required this.nome, required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      "id": this.id,
      "nome": this.nome,
      "password": this.password,
      "email": this.email
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map["id"] ??= map["id"],
      nome: map["nome"] as String,
      email: map["email"] as String,

      password: map["password"] as String
    );
  }

  String toJson() => jsonEncode(toMap());

  factory User.fromJson(String source) => User.fromMap(jsonDecode(source) as Map<String, dynamic>);
}