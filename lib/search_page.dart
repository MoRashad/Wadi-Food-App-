import 'package:WadiFood/database_service.dart';
import 'package:WadiFood/profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'user_model.dart';

class SearchPage extends StatefulWidget {
  final String userid;
  SearchPage({this.userid});
  static final String id = 'Search';
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchcontroller = TextEditingController();
  Future<QuerySnapshot> _users;

  _buildertile(User user){
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: user.profileimage.isEmpty
        ? AssetImage('assets/images/user_placeholder.jpg')
        : CachedNetworkImageProvider(user.profileimage),
      ),
      title: Text(user.name),
      onTap: ()=> Navigator.push(
        context,
        MaterialPageRoute(builder: (_)=> ProfilePage(userid: user.id,))   
      ),
    );
  }
  _clearsearch(){
    WidgetsBinding.instance.addPostFrameCallback((_) => _searchcontroller.clear());
    setState(() {
      _users = null;
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
                _users = DatabaseServise.searchusers(value);
              });
            }
          },
        ),
      ),
      body: _users == null
      ? Center(child: Text('Search for a user'),)
      : FutureBuilder(
        future: _users,
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.data.documents.length == 0){
            return Center(
              child: Text('No Users Found'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index){
              User user = User.fromDoc(snapshot.data.documents[index]);
              return _buildertile(user);
            },
          );
        },
      ),
    );
  }
}