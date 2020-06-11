import 'package:WadiFood/Products.dart';
import 'package:WadiFood/aboutUs.dart';
import 'package:WadiFood/exercise.dart';
import 'package:WadiFood/feed_page.dart';
import 'package:WadiFood/healthconsultant.dart';
import 'package:WadiFood/markets.dart';
import 'package:WadiFood/recipes.dart';
import 'package:WadiFood/specialoffers_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Awards.dart';
import 'LifeStyle.dart';
import 'Newsfeed.dart';
import 'calorie_cal.dart';
import 'profile.dart';
import 'auth.dart';
import 'user_data.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';



class HomePage extends StatefulWidget {
  static final String id = 'Homepage';
 // final String userid; 
  //HomePage({this.userid});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WebViewPlusController _controller;
  String url = 'https://wadi-food.com/';
  double _height = 1000;

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
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(Products.id);
              },
            ),
            ListTile(
              title: Center(child: Text('About us')),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(AboutUsPage.id);
              },
            ),
            ListTile(
              title: Center(child: Text('Awards')),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(AwardsPage.id);
              },
            ),
            ListTile(
              title: Center(child: Text('Market')),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(MarketsPage.id);
              },
            ),
            ListTile(
              title: Center(child: Text('Recipes')),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(RecipesPage.id);
              },
            ),
            ListTile(
              title: Center(child: Text('News Feed')),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(NewsFeedPage.id);
              },
            ),
            ListTile(
              title: Center(child: Text('Life Style')),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(LifeStylePage.id);
              },
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
            ListTile(
              title: Center(child: Text('Special Offers')),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(SpecialOffersPage.id);
              },
            ),
          ],
          
        ),
      ),
      body:/* WebViewPlus(
        onWebViewCreated: (controller) {
                this._controller = controller;
                controller.loadAsset('assets/index.html');
              },
              onPageFinished: (url) {
                _controller.getWebviewPlusHeight().then((double height) {
                  print("Height: " + height.toString());
                  setState(() {
                    _height = height;
                  });
                });
              },
              javascriptMode: JavascriptMode.unrestricted,
      ), */
      WebView(
            initialUrl: 'https://wadi-food.com/',
            javascriptMode: JavascriptMode.unrestricted,
            
          ),
    );
  }
}