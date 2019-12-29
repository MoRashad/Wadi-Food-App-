
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'auth.dart';
import 'Home_page.dart';
class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;
  @override
  _RootPageState createState() => _RootPageState();
}

enum AuthStatus {
  notsignedin,
  signedin
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notsignedin;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.auth.currentuser().then((userid){
      setState(() {
        authStatus = userid == null ? AuthStatus.notsignedin : AuthStatus.signedin;
      });
    });
  }
  void _signedin(){
    setState(() {
      authStatus = AuthStatus.signedin;
    });
  }
  void _signedout(){
    setState(() {
      authStatus = AuthStatus.notsignedin;
    });
  }
  @override
  Widget build(BuildContext context) {
    switch(authStatus){
      case AuthStatus.notsignedin:
        return new LoginPage(
          auth: widget.auth,
          onsignedin: _signedin,
        );
      case AuthStatus.signedin:
      return new HomePage(
        auth: widget.auth,
        onsignedout: _signedout,
      );
    }
  }
}