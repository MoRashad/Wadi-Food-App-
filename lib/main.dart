import 'package:WadiFood/feed_page.dart';
import 'package:WadiFood/healthconsultant.dart';
import 'package:WadiFood/postquestion.dart';
import 'package:provider/provider.dart';
import 'calorie_cal.dart';
import 'search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'edit_profile.dart';
import 'exercise.dart';
import 'postphoto.dart';
import 'profile.dart';
import 'Home_page.dart';
import 'login_page.dart';
import 'searchfood.dart';
import 'user_data.dart';
void main() {

runApp(MyApp());

}

class MyApp extends StatelessWidget { 
 //String userdata;
  Widget _getScreenId(){
     return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder:(BuildContext context, snapshot){
          if(snapshot.hasData){
            //userdata = snapshot.data.uid;
            Provider.of<Userdata>(context).currentuserid = snapshot.data.uid;
            return HomePage();
          }else{
            return LoginPage();
          }
     },
    );
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=> Userdata(),
      child: MaterialApp(
        title: 'login',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primaryColor: Colors.white,
        ),
        home: _getScreenId(),
        routes: {
          //LoginPage.id : (context)=> LoginPage(),
          HomePage.id : (context)=> HomePage(),
          ProfilePage.id : (context)=> ProfilePage(currentuser: Provider.of<Userdata>(context).currentuserid, userid: Provider.of<Userdata>(context).currentuserid),
          EditProfile.id : (context)=> EditProfile(userid: Provider.of<Userdata>(context).currentuserid),
          ExersiceCalPage.id : (context)=> ExersiceCalPage(userid: Provider.of<Userdata>(context).currentuserid),
          PostPhoto.id : (context)=> PostPhoto(userid: Provider.of<Userdata>(context).currentuserid),
          SearchPage.id : (context)=> SearchPage(userid: Provider.of<Userdata>(context).currentuserid,),
          FeedPage.id : (context)=> FeedPage(currentuserid: Provider.of<Userdata>(context).currentuserid,),
          CalorieCalPage.id : (context) => CalorieCalPage(userid: Provider.of<Userdata>(context).currentuserid,),
          SearchFood.id : (context) => SearchFood(userid: Provider.of<Userdata>(context).currentuserid,),
          HealthConsultant.id : (context) => HealthConsultant(userid: Provider.of<Userdata>(context).currentuserid,),
          PostQuestion.id : (context) => PostQuestion(userid: Provider.of<Userdata>(context).currentuserid,),
  },
  ),
    );
  }
}