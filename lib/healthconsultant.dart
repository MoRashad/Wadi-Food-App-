import 'package:flutter/material.dart';

class HealthConsultant extends StatefulWidget {
  static final String id = 'healthconsutlant';
  final String userid;
  HealthConsultant({this.userid});
  @override
  _HealthConsultantState createState() => _HealthConsultantState();
}

class _HealthConsultantState extends State<HealthConsultant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health consultant'),
        elevation: 0,

      ),
      body: Text('health consultant'),
    );
  }
}