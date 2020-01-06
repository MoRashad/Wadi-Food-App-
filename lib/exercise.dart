import 'package:flutter/material.dart';

class ExersiceCalPage extends StatefulWidget {
  static final String id = 'Exersice_cal';
  @override
  _ExersiceCalPageState createState() => _ExersiceCalPageState();
}

class _ExersiceCalPageState extends State<ExersiceCalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('exersice'),

      ),
      body: Container(
        child: Text('exersice'),
      ),
    );
  }
}