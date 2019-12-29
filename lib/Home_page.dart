import 'package:flutter/material.dart';
import 'auth.dart';

class HomePage extends StatelessWidget {
  HomePage({this.auth, this.onsignedout});
  final BaseAuth auth;
  final VoidCallback onsignedout;
  void _signout() async{
    try {
      await auth.signout();
      onsignedout();
    } catch (e) {
      print(e);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('welcome'),
        actions: <Widget>[
          FlatButton(
            child: Text('Logout',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
            ),
            onPressed: _signout,
          ),
        ],
        elevation: 0,
      ),
      body: Container(
        child: Center(
          child: Text('wlecome', style: TextStyle(fontSize: 32.0),),
        ),
      ),
    );
  }
}