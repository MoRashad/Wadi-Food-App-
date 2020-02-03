import 'searchfood.dart';
import 'package:flutter/material.dart';

class CalorieCalPage extends StatefulWidget {
  final String userid;
  CalorieCalPage({this.userid});
  static final String id = 'Calorie Calculator';
  @override
  _CalorieCalPageState createState() => _CalorieCalPageState();
}

class _CalorieCalPageState extends State<CalorieCalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(''),
        elevation: 0,
  
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 50,
                child: Center(
                  child: Text(
                  'Calorie Calculator',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                  ),
                ),
                color: Colors.green,
              ),
               Container(
            width: double.infinity,
            height: 50,
            child: Center(
              child: Text(
              'Calorie Goal:  2000',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              ),
            ),
            color: Colors.green,
          ),
           Container(
            width: double.infinity,
            height: 50,
            child: Center(
              child: Text(
              'Calories Taken:  1000',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              ),
            ),
            color: Colors.green,
          ),
           Container(
            width: double.infinity,
            height: 50,
            child: Center(
              child: Text(
              'Calories Remain:  1000',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              ),
            ),
            color: Colors.green,
          ),
          ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text('Breakfast',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 18,
            ),),
          ),
          SizedBox(height: 15,),
          Row(
            children: <Widget>[
              Icon(Icons.add),
              Expanded(
                  child: FlatButton(
                  onPressed:()=> Navigator.of(context).pushNamed(SearchFood.id), 
                  child: Text('Add food'),
                  
                ),
              ),
            ],
          ),
          Divider(color: Colors.black,),
          Container(
            alignment: Alignment.centerLeft,
            child: Text('Lunch',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 18,
            ),),
          ),
          SizedBox(height: 15,),
          Row(
            children: <Widget>[
              Icon(Icons.add),
              Expanded(
                  child: FlatButton(
                  onPressed: ()=> Navigator.of(context).pushNamed(SearchFood.id),  
                  child: Text('Add food'),
                  
                ),
              ),
            ],
          ),
          Divider(color: Colors.black,),
          Container(
            alignment: Alignment.centerLeft,
            child: Text('Dinner',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 18,
            ),),
          ),
          SizedBox(height: 15,),
          Row(
            children: <Widget>[
              Icon(Icons.add),
              Expanded(
                  child: FlatButton(
                  onPressed: ()=> Navigator.of(context).pushNamed(SearchFood.id),  
                  child: Text(
                    'Add food',
                  ),
                ),
              ),
            ],
          ),
          Divider(color: Colors.black,),
        ],
      ),
    );
  }
}