import 'package:WadiFood/postview.dart';
import 'package:WadiFood/profile.dart';

import 'database_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'post_model.dart';
import 'user_model.dart';

class FeedPage extends StatefulWidget {
  final String currentuserid;
  FeedPage({this.currentuserid});
  static final String id = 'feedpage';

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Post> _posts = [];

  @override
  void initState(){
    super.initState();
    _setupfeed();
  }
  _setupfeed() async{
    List<Post> posts = await DatabaseServise.getfeedposts(widget.currentuserid);
    setState(() {
      _posts = posts;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('feed'),

      ),
      body: RefreshIndicator(
        onRefresh: () => _setupfeed(),
        child: ListView.builder(
          itemCount: _posts.length,
          itemBuilder: (BuildContext context, int index) {
            Post post = _posts[index];
            return FutureBuilder(
              future: DatabaseServise.getuserwithid(post.authorid),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if(!snapshot.hasData){
                  return SizedBox.shrink();
                }
                User author = snapshot.data;
                return PostView(
                  currentuserid: widget.currentuserid,
                  post: post,
                  author: author,
                );
              }
            );
          },
        ),
      ),
    );
  }
}