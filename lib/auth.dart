
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_data.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;
  static String error;
 
  static void signinwithemailandpassword(BuildContext context, String email, String password) async{
     try{
       AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      if(user != null){
        //Navigator.pushReplacementNamed(context, HomePage.id);
        print(user.uid);
      }
     }catch(e){
       print(e.message);
       error = e.message;
       
     }
    
  }

  static void createuserwithemailandpassword(BuildContext context,String email, String password, String name, String phoneNo) async{
    AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
        try{if(user != null){
      _firestore.collection('/users').document(user.uid).setData({
        'email' : email,
        'name': name,
        'phonenumber': phoneNo,
        'profileimage': "",
        'uid': user.uid
    });
      Provider.of<Userdata>(context).currentuserid = user.uid;
    }}catch(e){
      print(e.message);
      error = e.message;
    }
  }

  static void currentuser() async {
     _auth.currentUser();
  }

  static void sendresetpassword(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }

  static void signout(BuildContext context) async{
    _auth.signOut();
    //Navigator.pushReplacementNamed(context, LoginPage.id);

  }



}

