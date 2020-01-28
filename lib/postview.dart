import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'post_model.dart';
import 'profile.dart';
import 'user_model.dart';

class PostView extends StatelessWidget {

  final String currentuserid;
  final Post post;
  final User author;
  PostView({this.currentuserid, this.post, this.author});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: ()=> Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProfilePage(
                currentuser: currentuserid,
                userid: post.authorid,
              ),
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey,
                  backgroundImage: author.profileimage.isEmpty
                  ? AssetImage('assets/images/user_placeholder')
                  : CachedNetworkImageProvider(author.profileimage),
                ),
                SizedBox(width: 8,),
                Text(author.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(post.imageurl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.favorite_border),
                    iconSize: 30,
                    onPressed: (){},
                  ),
                  IconButton(
                    icon: Icon(Icons.comment),
                    iconSize: 30,
                    onPressed: (){},
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('0 Likes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                ),
              ),
              SizedBox(height: 4,),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 12, right: 6),
                    child: Text(
                      author.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      ' ',//post.description,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12,)
            ],
          ),
        ),
      ],
    );
  }
}