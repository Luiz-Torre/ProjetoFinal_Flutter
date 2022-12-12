import 'package:flutter/material.dart';
import 'package:loja/pages/login.dart';

import 'pages/home.dart';


void main() {
  LoginStatus? notSignIn;
  runApp(MaterialApp(
    title:  "Loja",
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}