import 'package:flutter/material.dart';
import 'profile.dart';
import 'auth.dart';

class HomePage extends StatelessWidget {
  
  final String userid; 
  HomePage({this.userid});
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
              trailing: Icon(Icons.portrait),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(ProfilePage.id);
              }, 
            ),
            ListTile(
              title: Center(child: Text('Home')),
              trailing: Icon(Icons.home),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/Exersice Calculator');
              }, 
              
            ),
            ListTile(
              title: Center(child: Text('Products')),
              trailing: Icon(Icons.store_mall_directory),
            ),
            ListTile(
              title: Center(child: Text('Exercise Calculator')),
              trailing: Icon(Icons.system_update_alt),
            ),
            ListTile(
              title: Center(child: Text('Calorie Calculator')),
              trailing: Icon(Icons.portrait),
            ),
          ],
        ),
      ),
      body: Container(
        child: Center(
          child: Text('wlecome', style: TextStyle(fontSize: 32.0),),
        ),
      ),
    );
  }
}