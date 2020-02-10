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
  int countertime = 0;
  double energyexpenture;
  double calpersec = 0;
  List<String> exercises = ['Walking', 'Running'];
  String selectedexercise;
  var selectedweight;
  var weights = new List<double>.generate(500, (i)=> i.toDouble()+1);

  void starttimer() {
    Timer(duration, keeprunning);
  }

  void keeprunning() {
    if (swatch.isRunning) {
      
      starttimer();
      setState(() {
        stoptimetodisplay = swatch.elapsed.inHours.toString().padLeft(2, '0') +
            ':' +
            (swatch.elapsed.inMinutes % 60).toString().padLeft(2, '0') +
            ':' +
            (swatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');
      });
      countertime = swatch.elapsed.inSeconds;
      if(selectedexercise == 'Running'){
        energyexpenture = (0.0175 * 8 * selectedweight) / 60;
      }else{
        energyexpenture = (0.0175 * 3.5 * selectedweight) / 60;
      }
      calpersec += energyexpenture;
    }
  }

  void startstopwatch() {
    setState(() {
      stopispressed = false;
      startispressed = false;
    });
    swatch.start();
    starttimer();
  }

  void stopstopwatch() {
    setState(() {
      stopispressed = true;
      resettispressed = false;
    });
    swatch.stop();
  }

  void resetstopwatch() {
    setState(() {
      startispressed = true;
      resettispressed = true;
    });
    swatch.reset();
    stoptimetodisplay = '00:00:00';
    calpersec = 0;
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              DropdownButton(
                hint: Text('Choose an exercise'),
                value: selectedexercise,
                onChanged: (newValue) {
                  setState(() {
                    selectedexercise = newValue;
                    print(selectedexercise);
                  });
                },
                items: exercises.map((location) {
                  return DropdownMenuItem(
                    child: Text(location),
                    value: location,
                  );
                }).toList(),
              ),
              DropdownButton(
                hint: Text('Choose your weight'),
                value: selectedweight,
                onChanged: (newValue) {
                  setState(() {
                    selectedweight = double.parse(newValue.toString());
                    print(selectedweight);
                  });
                },
                items: weights.map((location) {
                  return DropdownMenuItem(
                    child: Text(location.toString()),
                    value: location,
                  );
                }).toList(),
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
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
              child: Text(
                stoptimetodisplay,
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
              'Calories Burned',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              child: Text(
                calpersec.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 11,
            child: Container(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: stopispressed ? null : stopstopwatch,
                        color: Colors.red,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        child: Text(
                          'Stop',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      RaisedButton(
                        onPressed: resettispressed ? null : resetstopwatch,
                        color: Colors.pink,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        child: Text(
                          'Reset',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RaisedButton(
                    onPressed: stopispressed ? startstopwatch : null,
                    color: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                    child: Text(
                      'Start',
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
