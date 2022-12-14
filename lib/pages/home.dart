import 'package:flutter/material.dart';
import 'package:loja/pages/produtos.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cadastro.dart';
import 'login.dart';

class Home extends StatelessWidget {
  static int? var_logado;

  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loja de Anuncios',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Loja de Anúncios'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  String? email_logado;

  MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? email_logado;

  Future<int> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString("email");

    if (email != null && email != '') {
      return 1;
    } else {
      return 0;
    }
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
    main().then((retorno) {
      Home.var_logado = retorno;
      setState(() {});

    });
    if (Home.var_logado != 0) {
      return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.title,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          body: Column(children: [
            Center(
            child:Container(
              margin: const EdgeInsets.all(10.0),
              child: Column(
              children: <Widget>[
                  OutlinedButton(
                    onPressed: () {
                      signOut();
                    },
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: const <Widget>[
                          Text('Logout'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ),
            Container(
              margin: const EdgeInsets.all(10.0),
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
                      width: 150,
                      padding: const EdgeInsets.all(20.0),
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
            Container(
              margin: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Produto()),
                      );
                    },
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: const <Widget>[
                          Text('Ver produtos'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]));
    } else {
      setState(() {});

      return Scaffold(
        
          appBar: AppBar(
            title: Text(
              widget.title,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          body: Column(children: [
            Center(
              child: Container(
                margin: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    OutlinedButton(
                      onPressed: () {
                        if (Home.var_logado == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Já está logado')),
                        );
                      }
                    },
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: const <Widget>[
                          Text('Fazer Login'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ),
            Container(
              margin: const EdgeInsets.all(10.0),
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
                      width: 150,
                      padding: const EdgeInsets.all(20.0),
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
            Container(
              margin: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Produto()),
                      );
                    },
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: const <Widget>[
                          Text('Ver produtos'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
          ])
          
          );

    }
  }
}
