import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
abstract class BaseAuth {
  Future<String> signinwithemailandpassword(String email, String password);
  Future<String> createuserwithemailandpassword(String email, String password, String name);
  Future<String> currentuser();
  Future sendresetpassword(String email);
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

  Future<String> createuserwithemailandpassword(String email, String password, String name) async{
    AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
        if(user != null){
      _firestore.collection('/users').document(user.uid).setData({
        'email' : email,
        'name': name,
        'phonenumber': 312321321,
        'profileimage': "",
        'uid': user.uid
        

    });
    }
    return user.uid;
  }

  Future<String> currentuser() async {
    FirebaseUser user = await _auth.currentUser();
    return user.uid;
  }
  Future sendresetpassword(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }
  Future<void> signout() async{
    return _auth.signOut();
  }



}

