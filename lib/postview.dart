import 'dart:async';

import 'package:WadiFood/comment_page.dart';
import 'package:WadiFood/database_service.dart';
import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'post_model.dart';
import 'profile.dart';
import 'user_model.dart';

class PostView extends StatefulWidget {

  final String currentuserid;
  final Post post;
  final User author;
  PostView({this.currentuserid, this.post, this.author});

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  int _likecount = 0;
  bool _isliked = false;
  bool _heartanim = false;
  @override
  void initState(){
    super.initState();
    _likecount = widget.post.likecount;
    _initpostliked();
  }

  @override
  void didUpdateWidget (PostView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.post.likecount != widget.post.likecount){
      _likecount = widget.post.likecount;
    }
  }

  _initpostliked() async{
    bool isliked = await DatabaseServise.didlikepost(
      currentuserid: widget.currentuserid,
      post: widget.post
    );
    if(mounted){
      setState(() {
        _isliked = isliked;
      });
    }
  }

  _likepost(){
    if(_isliked){
      DatabaseServise.unlikepost(
        currentuserid: widget.currentuserid,
        post: widget.post
      );
      setState(() {
        _isliked = false;
        _likecount = _likecount - 1;
      });
    }else{
      DatabaseServise.likepost(
        currentuserid: widget.currentuserid,
        post: widget.post
      );
      setState(() {
        _heartanim = true;
        _isliked = true;
        _likecount = _likecount + 1;
      });
      Timer(Duration(milliseconds: 350), (){
        setState(() {
          _heartanim = false;
        });
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: ()=> Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProfilePage(
                currentuser: widget.currentuserid,
                userid: widget.post.authorid,
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
                  backgroundImage: widget.author.profileimage.isEmpty
                  ? AssetImage('assets/images/user_placeholder')
                  : CachedNetworkImageProvider(widget.author.profileimage),
                ),
                SizedBox(width: 8,),
                Text(widget.author.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
            onDoubleTap: _likepost,
            child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
             Container(
              height: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(widget.post.imageurl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            _heartanim ? Animator(
              duration: Duration(milliseconds: 300),
              tween: Tween(begin: 0.5, end: 1.4),
              curve: Curves.elasticOut,
              builder: (anim)=> Transform.scale(
                scale: anim.value,
                child: Icon(Icons.favorite,
                size: 100,
                color: Colors.red[400],
                ),
              ),
            )
            : SizedBox.shrink(),
            ],
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
                    icon: _isliked 
                    ? Icon(Icons.favorite,
                    color: Colors.red,
                    )
                    : Icon(Icons.favorite_border),
                    iconSize: 30,
                    onPressed: _likepost,
                  ),
                  IconButton(
                    icon: Icon(Icons.comment),
                    iconSize: 30,
                    onPressed: () => Navigator.push(
                      context,
                       MaterialPageRoute(
                         builder: (_) => CommentsPage(
                           postid: widget.post.id,
                           likecount: _likecount,
                         ),
                       )
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('${_likecount.toString()} Likes',
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
                      widget.author.name,
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