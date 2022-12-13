import 'package:flutter/material.dart';
import 'package:loja/helper/AnuncioHelper.dart';
import 'package:loja/model/Anuncio.dart';
import "package:intl/intl.dart";
import 'package:loja/pages/home.dart';
import 'package:loja/pages/produtos.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loja/pages/login.dart';

import '../model/Anuncio.dart';
import 'cadastro.dart';

class meuAnuncio extends StatefulWidget {
  const meuAnuncio({super.key});

  @override
  State<meuAnuncio> createState() => _meuAnuncioState();
}

class _meuAnuncioState extends State<meuAnuncio> {
  String? email_logado;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  var _db = AnuncioHelper();
  List<Anuncio> anuncios = [];

  Future<String?> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString("email");
    email_logado = email;
    return email;
  }

  void _insertUpdateAnuncio({Anuncio? selectedAnuncio}) async {
    String title = titleController.text;
    String description = descriptionController.text;
    String state = stateController.text;
    String price = priceController.text;
    String telephone = telephoneController.text;
    String category = categoryController.text;
    var emailUser = await main();

    if (selectedAnuncio == null) {
      Anuncio anuncio = Anuncio(
          state, title, price, telephone, category, description, emailUser);

      int result = await _db.insertAnuncio(anuncio);
    } else {
      selectedAnuncio.title = title;
      selectedAnuncio.description = description;
      selectedAnuncio.state = state;
      selectedAnuncio.price = price;
      selectedAnuncio.telephone = telephone;
      selectedAnuncio.category = category;
      selectedAnuncio.emailUser = await main();
      int result = await _db.updateAnuncio(selectedAnuncio);
    }

    titleController.clear();
    descriptionController.clear();
    stateController.clear();
    priceController.clear();
    telephoneController.clear();
    categoryController.clear();

    _getAnuncios();
  }

  void _getAnuncios() async {
    List results = await _db.getAnuncios();
    anuncios.clear();

    var emailUser = await main();
    for (var item in results) {
      Anuncio anuncio = Anuncio.fromMap(item);
      if(anuncio.emailUser == emailUser){
        anuncios.add(anuncio);
      }
      
    }

    setState(() {});
  }

  _removeAnuncio(int? id) async {
    await _db.deleteAnuncio(id!);

    _getAnuncios();
  }

  void _showRegisterScreen({Anuncio? anuncio}) {
    String saveUpdateText = "";

    if (anuncio == null) {
      titleController.text = "";
      descriptionController.text = "";
      saveUpdateText = "Salvar";
    } else {
      titleController.text = anuncio.title!;
      descriptionController.text = anuncio.description!;
      stateController.text = anuncio.state!;
      priceController.text = anuncio.price!;
      telephoneController.text = anuncio.telephone!;
      categoryController.text = anuncio.category!;
      saveUpdateText = "Atualizar";
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(saveUpdateText),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                controller: titleController,
                autofocus: true,
                decoration: InputDecoration(
                    labelText: "Título", hintText: "Digite o título"),
              ),
              TextField(
                controller: descriptionController,
                autofocus: true,
                decoration: InputDecoration(
                    labelText: "Descrição", hintText: "Digite a descrição"),
              ),
              TextField(
                controller: stateController,
                autofocus: true,
                decoration: InputDecoration(
                    labelText: "Sigla do Estado",
                    hintText: "Digite a sigla do Estado"),
              ),
              TextField(
                controller: priceController,
                autofocus: true,
                decoration: InputDecoration(
                    labelText: "Preço", hintText: "Digite o preço"),
              ),
              TextField(
                controller: telephoneController,
                autofocus: true,
                decoration: InputDecoration(
                    labelText: "Telefone", hintText: "Digite o telefone"),
              ),
              TextField(
                controller: categoryController,
                autofocus: true,
                decoration: InputDecoration(
                    labelText: "Categoria", hintText: "Digite a categoria"),
              )
            ]),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar")),
              TextButton(
                  onPressed: () {
                    _insertUpdateAnuncio(selectedAnuncio: anuncio);
                    Navigator.pop(context);
                  },
                  child: Text(saveUpdateText))
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _getAnuncios();
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      preferences.setInt("value", 0);
      preferences.setString("email", '');

      LoginPage.loginStatus = LoginStatus.notSignIn;
    });
    LoginPage.loginStatus = LoginStatus.notSignIn;
    Home.var_logado = 0;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Home()));
  }

  @override
  Widget build(BuildContext context) {
    String? var_logado;
    main().then((retorno) {});
      return Scaffold(
        appBar: AppBar(
          title: Text("Lista de Produtos"),
          backgroundColor: Color.fromARGB(255, 36, 36, 42),
        ),
        body: Column(
          children: [
            Center(
            child: Column(
              children: <Widget>[
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Produto()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(0.0),
                    child: Column(
                      children: <Widget>[
                        Text('Voltar para Todos Produtos'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
            Expanded(
                child: ListView.builder(
                    itemCount: anuncios.length,
                    itemBuilder: (context, index) {
                      final item = anuncios[index];

                      return Dismissible(
                        key: ValueKey(item),
                        child: ListTile(
                          title: Text(item.title!),
                          subtitle: Text(
                              "Descrição do produto: ${item.description}\nTelefone de contato: ${item.telephone}\nEstado: ${item.price}\nPreço: ${item.price}\nCategoria: ${item.category}"),
                        ),
                        confirmDismiss: (DismissDirection direction) async {
                          if (direction == DismissDirection.endToStart) {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Tela de confirmação"),
                                  content: const Text(
                                      "Tem certeza que deseja excluir?"),
                                  actions: <Widget>[
                                    ElevatedButton(
                                        onPressed: () {
                                          _removeAnuncio(item.id);
                                          Navigator.of(context).pop(true);
                                        },
                                        child: const Text("Aceito Deletar")),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text("Cancelar"),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            _showRegisterScreen(anuncio: item);
                          }
                        },
                        secondaryBackground: Container(
                          color: Colors.red,
                          padding: EdgeInsets.all(16),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                )
                              ]),
                        ),
                        background: Container(
                          color: Colors.green,
                          padding: EdgeInsets.all(16),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                )
                              ]),
                        ),
                      );
                    }))
          ],
        ),
      );
  }
}
