import 'package:WadiFood/database_service.dart';
import 'package:WadiFood/postview.dart';
import 'package:WadiFood/search_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'comment_page.dart';
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
  bool _isfollowing = false;
  int _followercount = 0;
  int _followingcount = 0;
  List<Post> _posts = [];
  int _displayposts = 0; 
  User _profileuser;
  @override
  void initState(){
    super.initState();
    _setupisfollowing();
    _setupfollowers();
    _setupfollowing();
    _setupposts();
    _setupprofileuser();
  }
  _setupisfollowing() async {
    bool isfollowinguser = await DatabaseServise.isfollowinguser(
      widget.currentuser,
       widget.userid);
    setState(() {
      _isfollowing = isfollowinguser;
    });
  }
  _setupfollowers() async {
    int userfollowercount = await DatabaseServise.numfollowers(widget.userid);
    setState(() {
      _followercount = userfollowercount;
    });
  }
  _setupfollowing() async {
    int userfollowingcount = await DatabaseServise.numfollowing(widget.userid);
    setState(() {
      _followingcount = userfollowingcount;
    });
  }

  _setupposts() async{
    List<Post> posts = await DatabaseServise.getuserposts(widget.userid);
    setState(() {
      _posts = posts;
    });
  }

  _setupprofileuser() async {
    User profileuser = await DatabaseServise.getuserwithid(widget.userid);
    setState(() {
      _profileuser = profileuser;
    });
  }

  _followorunfollow(){
    if(_isfollowing){
      _unfollowuser();
    }else{
      _followuser();
    }
  }
  _unfollowuser(){
    DatabaseServise.unfollowuser(widget.currentuser, widget.userid);
    setState(() {
      _isfollowing = false;
      _followingcount--;
    });
  }
  _followuser(){
    DatabaseServise.followuser(widget.currentuser, widget.userid);
    setState(() {
      _isfollowing = true;
      _followingcount++;
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
        color: _isfollowing ? Colors.grey :Colors.green,
        textColor: _isfollowing ? Colors.black : Colors.white,
        child: Text(_isfollowing ? 'Unfollow' : 'Follow',
        style: TextStyle(
          fontSize: 18,
        ),
        ),
      ),
    );
  }

  _buildprofileinfo(User user){
    return Column(
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text('Followers',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            ),
                            Text(_followercount.toString(),
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
                            Text(_followingcount.toString(),
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
              );
  }

  _buildtogglebuttons(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.grid_on),
          iconSize: 30,
          color: _displayposts == 0 ? Colors.green : Colors.grey,
          onPressed: () => setState((){
            _displayposts = 0;
          }),
        ),
        IconButton(
          icon: Icon(Icons.list),
          iconSize: 30,
          color: _displayposts == 1 ? Colors.green : Colors.grey,
          onPressed: () => setState((){
            _displayposts = 1;
          }),
        ),
      ],
    );
  }
  _buildtilepost(Post post) {
    return GridTile(
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
            MaterialPageRoute(
              builder: (_) => CommentsPage(
                postid: post.id,
                likecount: post.likecount,
              ),
            )
        ),
          child: Image(
          image: CachedNetworkImageProvider(post.imageurl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
  _builddisplayposts(){
    if(_displayposts==0){
      List<GridTile> tiles = [];
      _posts.forEach(
        (post) => tiles.add(_buildtilepost(post)), );
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: tiles,
      );
    }else{
      List<PostView> postviews = [];
      _posts.forEach((post) {
        postviews.add(PostView(
          currentuserid: widget.currentuser,
          post: post,
          author: _profileuser,
        ),);
      });
      return Column(children: postviews);
    }
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
      body: RefreshIndicator(
        onRefresh: () => _setupposts(),
          child: FutureBuilder(
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
                _buildprofileinfo(user),
                _buildtogglebuttons(),
                Divider(),
                _builddisplayposts(),
              ],
            ),
          );
          },
        ),
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