import 'package:WadiFood/database_service.dart';
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
class ProfilePage extends StatefulWidget {
  final String userid;
  final String currentuser;
  ProfilePage({this.currentuser, this.userid });
  static final String id = 'profile';
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>{
  bool isfollowing = false;
  int followercount = 0;
  int followingcount = 0;
  @override
  void initState(){
    super.initState();
    _setupisfollowing();
    _setupfollowers();
    _setupfollowing();
  }
  _setupisfollowing() async {
    bool isfollowinguser = await DatabaseServise.isfollowinguser(
      widget.currentuser,
       widget.userid);
    setState(() {
      isfollowing = isfollowinguser;
    });
  }
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

  _displaybutton(User user){
    return user.id == Provider.of<Userdata>(context).currentuserid 
    ?  Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlatButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_)=> EditProfile(user: user,)
          ));
        },
        color: Colors.green,
        textColor: Colors.white,
        child: Text('edit profile',
        style: TextStyle(
          fontSize: 18,
        ),
        ),
      ),
    )
    : Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlatButton(
        onPressed: _followorunfollow,
        color: isfollowing ? Colors.grey :Colors.green,
        textColor: isfollowing ? Colors.black : Colors.white,
        child: Text(isfollowing ? 'Unfollow' : 'Follow',
        style: TextStyle(
          fontSize: 18,
        ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'),
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
        future:  Firestore.instance.collection('users').document(widget.userid).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),
          );
        }
        User user = User.fromDoc(snapshot.data);
        return Center(
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey,
                      backgroundImage: 
                      user.profileimage.isEmpty
                       ? AssetImage('assets/images/user_placeholder.jpg') 
                       : CachedNetworkImageProvider(user.profileimage), 
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(user.name,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text('Followers',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            ),
                            Text(followercount.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text('Following',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            ),
                            Text(followingcount.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _displaybutton(user),
                  Divider(
                    color: Colors.black,
                    thickness: 1,
                    endIndent: 60,
                    indent: 60,
                  ),
                ],
              ),
              
            ],
          ),
        );
        },
      ),
      floatingActionButton: 
      FloatingActionButton(
        onPressed: (){
          Navigator.of(context).pushNamed(PostPhoto.id);
          print('post photo');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

}