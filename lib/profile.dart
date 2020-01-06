import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'edit_profile.dart';
import 'constants.dart';
import 'user_model.dart';
class ProfilePage extends StatefulWidget {
  final String userid;
  ProfilePage({this.userid});
  static final String id = 'profile';
  @override
  _ProfilePageState createState() => _ProfilePageState();
}
String mCurrentUser;
FirebaseAuth _auth;

getCurrentUser () async {
  mCurrentUser = await _auth.currentUser().then((user){
    mCurrentUser = user.uid;
    return mCurrentUser;
  });
}
class _ProfilePageState extends State<ProfilePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'),

      ),
      body: FutureBuilder(
        future: userRef.document(widget.userid).get(),
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
                    child: Text(user.email,
                    style: TextStyle(
                      fontSize: 17,
                    ),
                    ),
                  ),
                  Padding(
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
                  ),
                ],
              ),
            ],
          ),
        );
        },
      ),
    );
  }
}