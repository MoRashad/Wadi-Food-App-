import 'package:WadiFood/postoffer_page.dart';
import 'package:flutter/material.dart';

class SpecialOffersPage extends StatefulWidget { 
  static final String id = 'Special Offers';
  final String userid;
  SpecialOffersPage({this.userid});
  @override
  _SpecialOffersPageState createState() => _SpecialOffersPageState();
}

class _SpecialOffersPageState extends State<SpecialOffersPage> {
  final String _admin = 'mT9T2iHirsYhWlGhnsNJe9Q0LkM2';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Special Offers',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Text('Special Offers'),
      ),
      floatingActionButton: _admin == widget.userid
      ? FloatingActionButton(
        onPressed: (){
          Navigator.of(context).pushNamed(PostofferPage.id);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      )
      : SizedBox.shrink(), 
    );
  }
}