import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
abstract class BaseAuth {
  Future<String> signinwithemailandpassword(String email, String password);
  Future<String> createuserwithemailandpassword(String email, String password, String name);
  Future<String> currentuser();
  Future<void> signout();
}

class Auth implements BaseAuth{
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  Future<String> signinwithemailandpassword(String email, String password) async{
    AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
    
  }
test
  Future<String> createuserwithemailandpassword(String email, String password, String name) async{
    AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
        if(user != null){
      _firestore.collection('/users').document(user.uid).setData({
        'email' : email,
        'name': name,

    });
    }
    return user.uid;
  }

  Future<String> currentuser() async {
    FirebaseUser user = await _auth.currentUser();
    return user.uid;
  }

  Future<void> signout() async{
    return _auth.signOut();
  }

}

class emailvalidate{
  static String validate(String value){
    if(value.isEmpty){
      return "email can't be empty";
    }
    return null;
  }
}
class passwordvalidate{
  static String validate(String value){
    if(value.isEmpty){
      return "password can't be empty";
    }
    if(value.length < 6){
      return "email can't be less than 6 charaters";
    }
    return null;
  }
}