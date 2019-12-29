import 'package:flutter/material.dart';
import 'login_page.dart';
import 'auth.dart';
import 'Home.dart';
void main() {

runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      
      title: 'login',
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: new RootPage(auth: new Auth()),
    );
  }
}