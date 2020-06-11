import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Products extends StatefulWidget {
  static final String id = 'products';
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(''),
        elevation: 0,
  
      ),
      body: WebView(
            initialUrl: 'https://wadi-food.com/en/product',
            javascriptMode: JavascriptMode.unrestricted,
            
          ),
    );
  }
}