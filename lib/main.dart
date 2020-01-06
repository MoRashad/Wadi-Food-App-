import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_demo1/edit_profile.dart';
import 'package:login_demo1/exercise.dart';
import 'package:login_demo1/profile.dart';
import 'Home_page.dart';
import 'login_page.dart';
import 'package:provider/provider.dart';

void main() {

runApp(MyApp());

}

class MyApp extends StatelessWidget { 
  String userdata;
  Widget _getScreenId(){
     return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder:(BuildContext context, snapshot){
          if(snapshot.hasData){
            userdata = snapshot.data.uid;
            return HomePage(userid: snapshot.data.uid);
          }else{
            return LoginPage();
          }
        },
    );
  }
  @override
  Widget build(BuildContext context) {
    
        return MaterialApp(
          title: 'login',
          debugShowCheckedModeBanner: false,
          theme: new ThemeData(
            primaryColor: Colors.white,
          ),
          home: _getScreenId(),
          routes: {
            //LoginPage.id : (context)=> LoginPage(),
            HomePage.id : (context)=> HomePage(userid:userdata),
            ProfilePage.id : (context)=> ProfilePage(userid: userdata),
            EditProfile.id : (context)=> EditProfile(userid: userdata,),
            ExersiceCalPage.id : (context)=> ExersiceCalPage(),
      },
    );
  }
}