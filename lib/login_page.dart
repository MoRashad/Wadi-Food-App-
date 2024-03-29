
import 'dart:math';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'auth.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'user_data.dart';

class LoginPage extends StatefulWidget {
  final String userid;
   LoginPage({this.onSignedIn, this.userid});
  final VoidCallback onSignedIn;
  static final String id = 'Login_Page';
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
  String _name;
  String error;
  String phoneNo;
  String _confirmpassword;
  FormType _formType = FormType.login;
  String smsCode;
  String verificationId;
  static final _firestore = Firestore.instance;
  static final _auth = FirebaseAuth.instance;

  /*Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      print('Inside autoRetrieve');
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResent]) {
      this.verificationId = verId;
      if(this.verificationId == forceCodeResent.toString()){
      smsCodeDialog(context).then((user) {
        print('Signed in');
      });
      }else{
        print('wrong code');
      }
    };

    final PhoneVerificationCompleted verificationSuccess = (AuthCredential phoneAuthCredential) {
      print('Verified');
    };

    final PhoneVerificationFailed verificationFail = (Exception e) {
      print('Inside Verification fail');
      print(e);
      _error = e.toString();
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.phoneNo,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 30),
        verificationCompleted: verificationSuccess,
        verificationFailed: verificationFail);
  }

   Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('Enter sms code'),
            content: new TextField(
              onChanged: (value) {
                this.smsCode = value;
              },
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              new FlatButton(
                child: Text('Done'),
                onPressed: (){
                  Navigator.pop(context);
                  validateandsubmit();
                }
              )
            ],
          );
        });
  }*/


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
      //AuthService.signinwithemailandpassword( context,_email, _password);
       AuthResult result = await _auth.signInWithEmailAndPassword(email: _email, password: _password);
      FirebaseUser user = result.user;
      if(user != null){
        //Navigator.pushReplacementNamed(context, HomePage.id);
        print(user.uid);
      }
      
    }else if(_formType == FormType.register){
      //AuthService.createuserwithemailandpassword(context, _email, _password, _name, phoneNo);
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: _email, password: _password);
    FirebaseUser user = result.user;
      if(user != null){
        _firestore.collection('/users').document(user.uid).setData({
          'email' : _email,
          'name': _name,
          'phonenumber': phoneNo,
          'profileimage': "",
          'uid': user.uid
        });
      }
      Provider.of<Userdata>(context).currentuserid = user.uid;
    }else if(_formType == FormType.reset){
      //AuthService.sendresetpassword(_email);
      _auth.sendPasswordResetEmail(email: _email);
      setState(() {
        _formType = FormType.login;
        error = 'Reset password mail has bee sent to $_email';
      });
    }
    }catch(e){
      print(e.message);
      setState(() {
        error = e.message;
      });
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
    if(error != null){
      return [Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Icon(Icons.error_outline),
            Expanded(
              child: AutoSizeText(error, maxLines: 3, ),
            ),
             Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    error = null;
                  });
                },
              ),
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
              if(value.trim().isEmpty){
                return "email can't be empty";
              }
                return null;
            }, 
            onChanged: (value)  => _email = value.trim(),
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
             SizedBox(height: 20,),
             Text('Confirm Password'),
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
            Text('phone number'),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'phone number',
              ),
              validator: (value) => value.isEmpty ? 'phone number can\'t be empty' : null,
              onChanged: (value) => this.phoneNo = value,
      ),
      new RaisedButton(
        color: Colors.green,
        child: Text('create an account',
         style: new TextStyle(
         fontSize: 20,
        ),
        ),
        onPressed: validateandsubmit, //verifyPhone, 
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