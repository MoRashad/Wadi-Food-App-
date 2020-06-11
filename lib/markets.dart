import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MarketsPage extends StatefulWidget {
  static final String id = 'markets';
  @override
  _MarketsPageState createState() => _MarketsPageState();
}

class _MarketsPageState extends State<MarketsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(''),
        elevation: 0,
  
      ),
      body: WebView(
            initialUrl: 'https://wadi-food.com/en/market',
            javascriptMode: JavascriptMode.unrestricted,
            
          ),
    );
  }
}