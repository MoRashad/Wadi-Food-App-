import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LifeStylePage extends StatefulWidget {
  static final String id = 'LifeStyle';
  @override
  _LifeStylePageState createState() => _LifeStylePageState();
}

class _LifeStylePageState extends State<LifeStylePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(''),
        elevation: 0,
  
      ),
      body: WebView(
            initialUrl: 'https://wadi-food.com/en/life-style',
            javascriptMode: JavascriptMode.unrestricted,
            
          ),
    );
  }
}