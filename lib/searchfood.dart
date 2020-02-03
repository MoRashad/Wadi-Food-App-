import 'package:flutter/material.dart';

class SearchFood extends StatefulWidget {
  final String userid;
  SearchFood({this.userid});
  static final String id = 'Searchfood';
  @override
  _SearchFoodState createState() => _SearchFoodState();
}

class _SearchFoodState extends State<SearchFood> {
  TextEditingController _searchcontroller = TextEditingController();
  _clearsearch(){
    WidgetsBinding.instance.addPostFrameCallback((_) => _searchcontroller.clear());
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          controller: _searchcontroller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15),
            border: InputBorder.none,
            hintText: 'Search',
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
              size: 30,
            ),suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.black,
              ),
              onPressed: _clearsearch,
            ),
            filled: true,
          ),
          onSubmitted: (value){
            if(value.isNotEmpty){  
              setState(() {
              });
            }
          },
        ),
      ),
      body: Center(
        child: Text('Search food'),
      ),
    );
  }
}