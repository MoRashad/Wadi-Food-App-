import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipesPage extends StatefulWidget {
  static final String id = 'recipes';
  @override
  _RecipesPageState createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(''),
        elevation: 0,
  
      ),
      body: WebView(
            initialUrl: 'https://wadi-food.com/en/recipes',
            javascriptMode: JavascriptMode.unrestricted,
            
          ),
    );
  }
}