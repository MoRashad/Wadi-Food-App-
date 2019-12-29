
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';
import 'package:auto_size_text/auto_size_text.dart';



class LoginPage extends StatefulWidget {
  final BaseAuth auth;  
  LoginPage({this.auth, this.onsignedin});
  final VoidCallback onsignedin;
  @override
  State<StatefulWidget> createState() => new LoginPageState();
}

enum FormType{
  login,
  register
}

class LoginPageState extends State<LoginPage>{
  final _db = Firestore.instance;
  final forekey = new GlobalKey<FormState>();
  String _email;
  String _password;
  String _name;
  String _error;
  FormType _formType = FormType.login;
  bool validateandsave(){

    final form = forekey.currentState;
    if(form.validate()){
          form.save();
          return true;
    }
    return false;

  }
void validateandsubmit() async {
  if(validateandsave()){
    try{
      if(_formType == FormType.login){

      //FirebaseUser user = (await _auth.signInWithEmailAndPassword(email: _email, password: _password)).user;      
      String userid = await widget.auth.signinwithemailandpassword(_email, _password);
      print('signed in: $userid');

      }else{
        String userid = await widget.auth.createuserwithemailandpassword(_email, _password, _name);
        print('register user: $userid');
      }
      widget.onsignedin();
    }catch(e){
      setState(() {
        _error = e.message;
      });
      print('error: $e');
    }
  }
}

void moveToRegister(){
  forekey.currentState.reset();
  setState(() {
      _formType = FormType.register;
  });

}
void moveToLogin(){
  forekey.currentState.reset();
  setState(() {
      _formType = FormType.login;
  });

}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text('login'),
        elevation: 0.0,
      ),
      body:  new Container(
          padding: EdgeInsets.all(20),
          child: new Form(
            key: forekey,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: showAlert() + buildInputs() + buildsubmitbutton(),
            ),
          ),
        ),
      );
  }

   List<Widget> showAlert(){
    if(_error != null){
      return [Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Icon(Icons.error_outline),
            Expanded(
              child: AutoSizeText(_error, maxLines: 3, ),
            ),
          ],
        ),
      )];
    }
    return [SizedBox(height: 0,)];
  }

  List<Widget> buildInputs(){
    return [
      new TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: new InputDecoration(
        labelText: 'Email',
        ),
        validator: emailvalidate.validate, 
        onChanged: (value)  => _email = value,
      ),
      SizedBox(height: 30),
      new TextFormField(
        decoration: new InputDecoration(
        labelText: 'Password',
       ),
         obscureText: true,
         validator: passwordvalidate.validate, /*(value) => value.isEmpty ? 'Password can\'t be empty' : null,*/
        onChanged: (value)  => _password = value,
      ),    
    ];
  }
  List<Widget> buildsubmitbutton(){
    if(_formType == FormType.login){

    return[    
      SizedBox(height: 30,),
      new RaisedButton(
        color: Colors.green,
        child: Text('Login',
         style: new TextStyle(
         fontSize: 20,
        ),
        ),
        onPressed: validateandsubmit,
      ),
      new FlatButton(
        child: new Text('create an account',
         style: new TextStyle(
         fontSize: 20,
        ),
        ),
        onPressed: moveToRegister,
      ),
    ];
    }else{
      return[
      new TextFormField(
        decoration: new InputDecoration(
        labelText: 'Full Name',
        ),
        validator: (value) => value.trim().isEmpty ? 'Name can\'t be empty' : null,
        onChanged: (value)  => _name = value,
      ),
      SizedBox(height: 20.0),
      new RaisedButton(
        color: Colors.green,
        child: Text('create an account',
         style: new TextStyle(
         fontSize: 20,
        ),
        ),
        onPressed: validateandsubmit,
      ),
      new FlatButton(
        child: new Text('Have an account? login',
         style: new TextStyle(
         fontSize: 20,
        ),
        ),
        onPressed: moveToLogin,
      ),
      ];
    }
  }
}