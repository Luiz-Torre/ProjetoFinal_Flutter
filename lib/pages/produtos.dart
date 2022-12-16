import 'package:flutter/material.dart';
import 'package:loja/helper/AnuncioHelper.dart';
import 'package:loja/model/Anuncio.dart';
import "package:intl/intl.dart";
import 'package:loja/pages/home.dart';
import 'package:loja/pages/meus_anuncios.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loja/pages/login.dart';

import '../model/Anuncio.dart';
import 'cadastro.dart';

const List<String> list = <String>[
  'Todos',
  'AC',
  'AL',
  'AM',
  'AP',
  'BA',
  'CE',
  'DF',
  'ES',
  'GO',
  'MA',
  'MG',
  'MS',
  'MT',
  'PA',
  'PB',
  'PE',
  'PI',
  'PR',
  'RJ',
  'RN',
  'RO',
  'RR',
  'RS',
  'SC',
  'SE',
  'SP',
  'TO'
];

class Produto extends StatefulWidget {
  const Produto({super.key});

  @override
  State<Produto> createState() => _ProdutoState();
}

class _ProdutoState extends State<Produto> {
  TextEditingController _catFiltroController = TextEditingController(text: "");
  String _filtroEstado = list.first;

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

  void _insertAnuncio() async {
    String title = titleController.text;
    String description = descriptionController.text;
    String state = stateController.text;
    String price = priceController.text;
    String telephone = telephoneController.text;
    String category = categoryController.text;
    var emailUser = await main();
    Anuncio anuncio = Anuncio(
        state, title, price, telephone, category, description, emailUser);

    int result = await _db.insertAnuncio(anuncio);

    titleController.clear();
    descriptionController.clear();
    stateController.clear();
    priceController.clear();
    telephoneController.clear();
    categoryController.clear();
    _getAnuncios();
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

    for (var item in results) {
      Anuncio anuncio = Anuncio.fromMap(item);
      if ((anuncio.category!.toLowerCase().contains(_catFiltroController.text.toLowerCase())) &&
          (anuncio.state == _filtroEstado || _filtroEstado == 'Todos')) {
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
            content: SingleChildScrollView(
              child:Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                controller: titleController,
                autofocus: true,
                decoration: const InputDecoration(
                    labelText: "Título", hintText: "Digite o título"),
              ),
              TextField(
                controller: descriptionController,
                autofocus: true,
                decoration: const InputDecoration(
                    labelText: "Descrição", hintText: "Digite a descrição"),
              ),
              TextField(
                controller: stateController,
                autofocus: true,
                decoration: const InputDecoration(
                    labelText: "Sigla do Estado",
                    hintText: "Digite a sigla do Estado"),
              ),
              TextField(
                controller: priceController,
                autofocus: true,
                decoration: const InputDecoration(
                    labelText: "Preço", hintText: "Digite o preço"),
              ),
              TextField(
                controller: telephoneController,
                autofocus: true,
                decoration: const InputDecoration(
                    labelText: "Telefone", hintText: "Digite o telefone"),
              ),
              TextField(
                controller: categoryController,
                autofocus: true,
                decoration: const InputDecoration(
                    labelText: "Categoria", hintText: "Digite a categoria"),
              )
            ])
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar")),
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
    if (email_logado != null && email_logado != '') {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Lista de Produtos"),
          backgroundColor: const Color.fromARGB(255, 36, 36, 42),
        ),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                signOut();
              },
              child: Container(
                width: 150,
                child:const Text("Logout", textAlign: TextAlign.center,) ,),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const meuAnuncio()),
                      );
                    },
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        children: const <Widget>[
                          Text('Meus Anuncios'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(children: [
              DropdownButton<String>(
                value: _filtroEstado,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? value) {
                  setState(() {
                    _filtroEstado = value!;
                    _getAnuncios();
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ]),
            TextField(
              decoration: const InputDecoration(
                  labelText: "Digite corretamente a categoria desejada "),
              controller: _catFiltroController,
              onChanged: (var num) async{
                _getAnuncios();
              },
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: anuncios.length,
                    itemBuilder: (context, index) {
                      final item = anuncios[index];

                      return Center(
                        key: ValueKey(item),
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 164, 209, 221),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                          title: Text(item.title!),
                          subtitle: Text(
                              "Descrição do produto: ${item.description}\nTelefone de contato: ${item.telephone}\nEstado: ${item.price}\nPreço: ${item.state}\nCategoria: ${item.category}\nEmail do Vendedor: ${item.emailUser}"),
                        ),
                      )
                    );
                    }))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 36, 36, 42),
          foregroundColor: const Color.fromARGB(255, 75, 74, 79),
          child: const Icon(Icons.add),
          onPressed: () => _showRegisterScreen(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Lista de Produtos"),
          backgroundColor: const Color.fromARGB(255, 36, 36, 42),
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
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        children: const <Widget>[
                          Text('Fazer Login'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Cadastro()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        children: const <Widget>[
                          Text('Cadastrar Conta'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Text("Todos os produtos cadastrados"),
            Expanded(
                child: ListView.builder(
                    itemCount: anuncios.length,
                    itemBuilder: (context, index) {
                      final item = anuncios[index];

                      return Center(
                          key: ValueKey(item),
                          child: ListTile(
                            title: Text(item.title!),
                            subtitle: Text(
                                "Descrição do produto: ${item.description}\nTelefone de contato: ${item.telephone}\nEstado: ${item.state}\nPreço: ${item.price}\nCategoria: ${item.category}"),
                          ));
                    }))
          ],
        ),
      );
    }
  }
}
