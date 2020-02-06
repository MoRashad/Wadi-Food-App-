import 'package:WadiFood/exercise.dart';
import 'package:WadiFood/feed_page.dart';
import 'package:WadiFood/healthconsultant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'calorie_cal.dart';
import 'profile.dart';
import 'auth.dart';
import 'user_data.dart';

class HomePage extends StatelessWidget {
  
 // final String userid; 
  //HomePage({this.userid});
  static final String id = 'home_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('welcome',
        textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Logout',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
            ),
            onPressed: ()=> AuthService.signout(context),
          ),
        ],
        //elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Center(child: Text('Profile')),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(ProfilePage.id);
              }, 
            ),
            ListTile(
              title: Center(child: Text('Feed')),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(FeedPage.id);
              }, 
              
            ),
            ListTile(
              title: Center(child: Text('Products')),
            ),
            ListTile(
              title: Center(child: Text('Exercise Calculator')),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(ExersiceCalPage.id);
              },
            ),
            ListTile(
              title: Center(child: Text('Calorie Calculator')),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(CalorieCalPage.id);
              },
            ),
            ListTile(
              title: Center(child: Text('Health Consultant')),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(HealthConsultant.id);
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: Center(
          child: Text('welcome', style: TextStyle(fontSize: 32.0),),
        ),
      ),
    );
  }
}