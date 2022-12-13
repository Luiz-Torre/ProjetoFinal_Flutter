import 'package:flutter/material.dart';
import 'package:loja/helper/DatabaseHelper.dart';
import 'package:loja/model/User.dart';


class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController nomeController = TextEditingController();  
  var _db = DatabaseHelper();
  List<User> annotations = [];

  void _insertUser() async {
    String email = emailController.text;
    String senha = senhaController.text;
    String nome = nomeController.text;

    User user =
        User(nome:nome, password:senha, email: email);

    int result = await _db.insertUser(user);

    emailController.clear();
    senhaController.clear();
    nomeController.clear();
  }

  void _showRegisterScreen({User? annotation}) {
    String saveUpdateText = "";

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _controllerEditarTitulo = TextEditingController();
    TextEditingController _controllerEditarDescricao = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
        backgroundColor: Color.fromARGB(255, 36, 36, 42),
      ),
      body: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                controller: nomeController,
                autofocus: true,
                decoration: InputDecoration(
                    labelText: "Nome", hintText: "Digite o nome"),
              ),
              TextField(
                controller: emailController,
                autofocus: true,
                decoration: InputDecoration(
                    labelText: "Email", hintText: "Digite o email"),
              ),
              TextField(
                controller: senhaController,
                autofocus: true,
                decoration: InputDecoration(
                    labelText: "Senha", hintText: "Digite a senha"),
              ),
              TextButton(
                  onPressed: () {
                    _insertUser();
                    Navigator.pop(context);
                  },
                  child: Text("Finalizar Cadastro"))
            ]),

    );
  }
}
