import 'package:flutter/material.dart';
import 'package:loja/controller/LoginController.dart';
import 'package:loja/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/User.dart';

enum LoginStatus { notSignIn, signIn }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static LoginStatus loginStatus = LoginStatus.notSignIn;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? _email, _password;
  final _formKey = GlobalKey<FormState>();
  late LoginController controller;
  var value;

  _LoginPageState() {
    this.controller = LoginController();
  }

  void _submit() async {
    final form = _formKey.currentState;

    if (form!.validate()) {
      form.save();

      try {
        User user = await controller.getLogin(_email!, _password!);
        if (user.id != -1) {
          savePref(1, user.email, user.password);
          LoginPage.loginStatus = LoginStatus.signIn;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not registered!')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      preferences.setInt("value", 0);
      LoginPage.loginStatus = LoginStatus.notSignIn;
    });
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      value = preferences.getInt("value");

      LoginPage.loginStatus =
          value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  savePref(int value, String user, String pass) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      preferences.setInt("value", value);
      preferences.setString("email", user);
      preferences.setString("pass", pass);
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (LoginPage.loginStatus) {
      case LoginStatus.notSignIn:
        LoginPage.loginStatus = LoginStatus.notSignIn;
        return Scaffold(
          appBar: AppBar(
            title: Text("Login Page"),
          ),
          body: Container(
            child: Center(
              child: Column(
                children: [
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              onSaved: (newValue) => _email = newValue,
                              decoration: InputDecoration(
                                labelText: "email",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              onSaved: (newValue) => _password = newValue,
                              decoration: InputDecoration(
                                labelText: "Password",
                                border: UnderlineInputBorder(),
                              ),
                            ),
                          )
                        ],
                      )),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text("Login"),
                  )
                ],
              ),
            ),
          ),
        );
      case LoginStatus.signIn:
        LoginPage.loginStatus = LoginStatus.signIn;

        return Home();
    }
  }
}
