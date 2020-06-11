import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsFeedPage extends StatefulWidget {
  static final String id = 'NewsFeed';
  @override
  _NewsFeedPageState createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(''),
        elevation: 0,
  
      ),
      body: WebView(
            initialUrl: 'https://wadi-food.com/en/news-feed',
            javascriptMode: JavascriptMode.unrestricted,
            
          ),
    );
  }
}