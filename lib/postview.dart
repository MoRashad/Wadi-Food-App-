/*import 'package:WadiFood/database_service.dart';
// import 'package:WadiFood/postview.dart';
import 'package:WadiFood/search_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_profile.dart';
import 'post_model.dart';
import 'postphoto.dart';
import 'user_data.dart';
import 'user_model.dart';
class Test extends StatefulWidget {
  final String userid;
  final String currentuser;
  Test({this.currentuser, this.userid });
  static final String id = 'Test';
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test>{
  bool isfollowing = false;
  int followercount = 0;
  int followingcount = 0;
  List<Post> posts = [];
  int _displayposts = 0;
  User _profileuser;
  @override
  void initState(){
    super.initState();
    //_setupisfollowing();
    _setupfollowers();
    _setupfollowing();
    _setupposts();
    //_setupprofileuser();
  }
  /*_setupisfollowing() async {
    bool isfollowinguser = await DatabaseServise.isfollowinguser(
      widget.currentuser,
       widget.userid);
    setState(() {
      isfollowing = isfollowinguser;
    });
  }*/
  _setupfollowers() async {
    int userfollowercount = await DatabaseServise.numfollowers(widget.userid);
    setState(() {
      followercount = userfollowercount;
    });
  }
  _setupfollowing() async {
    int userfollowingcount = await DatabaseServise.numfollowing(widget.userid);
    setState(() {
      followingcount = userfollowingcount;
    });
  }

  _setupposts() async{
    List<Post> posts = await DatabaseServise.getUserPosts(widget.userid);
    setState(() {
      posts = posts;
    });
  }

  /*_setupprofileuser() async{
    User profileuser = await DatabaseServise.getuserwithid(widget.userid);
    setState(() {
      _profileuser = profileuser;
    });
  }*/

  _followorunfollow(){
    if(isfollowing){
      _unfollowuser();
    }else{
      _followuser();
    }
  }
  _unfollowuser(){
    DatabaseServise.unfollowuser(widget.currentuser, widget.userid);
    setState(() {
      isfollowing = false;
      followingcount--;
    });
  }
  _followuser(){
    DatabaseServise.followuser(widget.currentuser, widget.userid);
    setState(() {
      isfollowing = true;
      followingcount++;
    });
  }

  

  _buildprofileinfo(Post post){
    return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  backgroundImage: 
                     CachedNetworkImageProvider(post.imageurl), 
                ),
              ),
            ]
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
            ),
            onPressed:()=> Navigator.of(context).pushNamed(SearchPage.id),

          ),
        ],
      ),
      body: FutureBuilder(
        future: Firestore.instance.collection('posts').document(widget.userid).collection('usersposts').getDocuments(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),
          );
        }
        Post post = Post.fromDoc(snapshot.data);
        return ListView(
            children: <Widget>[
              _buildprofileinfo(post),
              //_buildtogglebuttons(),
              Divider(),
              //_builddisplayposts(),
            ],
        );
        },
      ),
    );
  }
}
*/