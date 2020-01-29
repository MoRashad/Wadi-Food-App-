import 'package:WadiFood/database_service.dart';
import 'package:WadiFood/user_data.dart';
import 'package:WadiFood/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'comment_model.dart';

class CommentsPage extends StatefulWidget {
  final String postid;
  final int likecount;
  CommentsPage({this.postid, this.likecount});
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _commentcontroller = TextEditingController();
  bool _iscommenting = false;

  _buildcomment(Comment comment){
    return FutureBuilder(
      future: DatabaseServise.getuserwithid(comment.authorid),
      builder: (BuildContext context, AsyncSnapshot snapshpt){
        if(!snapshpt.hasData){
          return SizedBox.shrink();
        }
        User author = snapshpt.data;
        return ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey,
            backgroundImage: author.profileimage.isEmpty
              ? AssetImage('assets/images/user_placeholder.jpg')
              : CachedNetworkImageProvider(author.profileimage),
          ),
          title: Text(author.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(comment.content),
              SizedBox(height: 6,),
              Text(
                DateFormat.yMd().add_jm().format(comment.timestamp.toDate()),
              ),
            ],
          ),
        );
      },
    );
  }

  _buildcommenttf(){
    final currentuserid = Provider.of<Userdata>(context).currentuserid;
    return IconTheme(
      data: IconThemeData(
        color: _iscommenting
        ? Theme.of(context).accentColor
        : Theme.of(context).disabledColor,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 10,),
            Expanded(
              child: TextField(
                controller: _commentcontroller,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (comment){
                  setState(() {
                    _iscommenting = comment.length > 0;
                  });
                },
                decoration: InputDecoration.collapsed(hintText: 'Write a comment...'),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: (){
                  if(_iscommenting){
                    DatabaseServise.commentonpost(
                      currentuserid: currentuserid,
                      postid: widget.postid,
                      comment: _commentcontroller.text,
                    );
                    _commentcontroller.clear();
                    setState(() {
                      _iscommenting = false;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Comments',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              '${widget.likecount} likes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          StreamBuilder(
            stream: Firestore.instance.collection('comments')
              .document(widget.postid)
              .collection('postcomments')
              .orderBy('timestamp', descending: true)
              .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(!snapshot.hasData){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    Comment comment = Comment.fromDoc(snapshot.data.documents[index]);
                    return _buildcomment(comment);
                 },
                ),
              );
            },
          ),
          Divider(height: 1,),
          _buildcommenttf(),
        ],
      ),
    );
  }
}
