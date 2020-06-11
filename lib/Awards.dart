import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AwardsPage extends StatefulWidget {
  static final String id = 'awards';
  @override
  _AwardsPageState createState() => _AwardsPageState();
}

class _AwardsPageState extends State<AwardsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(''),
        elevation: 0,
  
      ),
      body: WebView(
            initialUrl: 'https://wadi-food.com/en/awards',
            javascriptMode: JavascriptMode.unrestricted,
            
          ),
    );
  }
}