import 'dart:async';

import 'package:flutter/material.dart';

class ExersiceCalPage extends StatefulWidget {
  static final String id = 'Exersice_cal';
  final String userid;
  ExersiceCalPage({this.userid});
  @override
  _ExersiceCalPageState createState() => _ExersiceCalPageState();
}

class _ExersiceCalPageState extends State<ExersiceCalPage> {
  bool startispressed = true;
  bool stopispressed = true;
  bool resettispressed = true;
  String stoptimetodisplay = '00:00:00';
  var swatch = Stopwatch();
  final duration = const Duration(seconds: 1);

  void starttimer(){
    Timer(duration, keeprunning);
  }
  void keeprunning(){
    if(swatch.isRunning){
      starttimer();
      setState(() {
        stoptimetodisplay = swatch.elapsed.inHours.toString().padLeft(2, '0') + ':'
                          + (swatch.elapsed.inMinutes %60).toString().padLeft(2, '0') + ':'
                          + (swatch.elapsed.inSeconds %60).toString().padLeft(2, '0');
      });
    }
  }
  void startstopwatch(){
    setState(() {
      stopispressed = false;
      startispressed = false;
    });
    swatch.start();
    starttimer();
  }
  void stopstopwatch(){
    setState(() {
      stopispressed = true;
      resettispressed = false;
    });
    swatch.stop();
  }
  void resetstopwatch(){
    setState(() {
      startispressed = true;
      resettispressed = true;
    });
    swatch.reset();
    stoptimetodisplay = '00:00:00';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('exersice'),
        elevation: 0,
  
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 200,
            child: Center(
              child: Text(
              'Exersice Calculator',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
              ),
              ),
            ),
            color: Colors.green,
          ),
          SizedBox(height: 40,),
          Container(
            child: Text(
              'Duration',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: Text(stoptimetodisplay,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              ),
            ),
          ),
          //SizedBox(height: 40,),
          Container(
            child: Text(
              'Calories Burnt',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              child: Text('0',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: stopispressed ? null : stopstopwatch,
                        color: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        child: Text('Stop',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),),
                      ),
                      RaisedButton(
                        onPressed: resettispressed ? null : resetstopwatch,
                        color: Colors.grey,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        child: Text('Reset',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15,),
                  RaisedButton(
                        onPressed: stopispressed ? startstopwatch : null,
                        color: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                        child: Text('Start',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}