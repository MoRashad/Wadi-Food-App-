
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
  register,
  reset
}


class LoginPageState extends State<LoginPage>{
  final _db = Firestore.instance;
  final forekey = new GlobalKey<FormState>();
  String _email;
  String _password;
  TextEditingController _passcontroller;
  String _confirmpassword;
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
      widget.onsignedin();
      }else if(_formType == FormType.register){
        String userid = await widget.auth.createuserwithemailandpassword(_email, _password, _name);
        print('register user: $userid');
        widget.onsignedin();
      }
      
      if(_formType == FormType.reset){
        widget.auth.sendresetpassword(_email);
        setState(() {
          _formType = FormType.login;
        });
      }
      
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
void movetoresetpassword(){
  forekey.currentState.reset();
  setState(() {
    _formType = FormType.reset;
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
      body:SingleChildScrollView( 
       child: Container(
          padding: EdgeInsets.all(20),
          child: new Form(
            key: forekey,
            child: new Column(
              
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: showAlert() + buildInputs() + buildsubmitbutton(),
            ),
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
      ),
      SizedBox(height: 30,),
      ];
    }
    return [SizedBox(height: 0,)];
  }

  List<Widget> buildInputs(){
        if(_formType == FormType.login || _formType == FormType.register)
        {
        return [
           Text('Email'), 
           TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: new InputDecoration(
            labelText: 'Email',
            ),
            validator: (value){
              if(value.isEmpty){
                return "email can't be empty";
              }
                return null;
            }, 
            onChanged: (value)  => _email = value,
          ),
          SizedBox(height: 30),
          Text('Password'), 
          new TextFormField(
            controller: _passcontroller,
        decoration: new InputDecoration(
        labelText: 'Password',
       ),
         obscureText: true,
         validator: (value) {
           if(value.isEmpty){
            return "password can't be empty";
          }
          if(value.length < 6){
            return "Password can't be less than 6 charaters";
          }
            return null;
         },
        
        onChanged: (value)  => _password = value,
      ),    
    ];
    }else{
      return[
        Text('Email'),
        TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: new InputDecoration(
            labelText: 'Email',
            ),
            validator: (value){
              if(value.isEmpty){
                return "email can't be empty";
              }
                return null;
            }, 
            onChanged: (value)  => _email = value,
        ),
      ];
    }
  }
  List<Widget> buildsubmitbutton(){
    if(_formType == FormType.login){

    return[    
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
      FlatButton(
        child: Text('forgot password?',
        style: TextStyle(
          fontSize: 17,
        ),
        ),
        onPressed: movetoresetpassword,
      )
    ];
    }else if(_formType == FormType.register){
      return[
       TextFormField(
        decoration: new InputDecoration(
        labelText: 'confirm Password',
       ),
         obscureText: true,
         validator: (value) { 
           if(value.isEmpty){
             return "Field can\'t be empty";
           }
           if(value != _password){
             return "Passwords don\'t match";
           }
           return null;
         },
        onChanged: (value)  => _confirmpassword = value,
      ), 
       SizedBox(height: 20,),
       Text('Full Name'),
       TextFormField(
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
    }else if(_formType == FormType.reset){
      return[
        SizedBox(height: 20.0),
       RaisedButton(
        color: Colors.green,
        child: Text('send reset mail',
         style: new TextStyle(
         fontSize: 20,
        ),
        ),
        onPressed: validateandsubmit,
      ),
      new FlatButton(
        child: new Text('Back to login',
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