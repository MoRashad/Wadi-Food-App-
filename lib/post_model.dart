import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String id;
  final String imageurl;
  final String description;
  final int likecount;
  final String authorid;
  final Timestamp timestamp;

  Post({
    this.id,
    this.imageurl,
    this.description,
    this.likecount,
    this.authorid,
    this.timestamp,
  });

  factory Post.fromDoc(DocumentSnapshot doc){
    return Post(
      id: doc.documentID,
      imageurl: doc['imageurl'],
      description: doc['caption'],
      likecount: doc['likecount'],
      authorid: doc['authorid'],
      timestamp: doc['timestamp'],
    );
  }
}