import 'package:cloud_firestore/cloud_firestore.dart';

class Comment{
  final String id;
  final String content;
  final String authorid;
  final Timestamp timestamp;

  Comment({
    this.id,
    this.content,
    this.authorid,
    this.timestamp,
  });

  factory Comment.fromDoc(DocumentSnapshot doc) {
    return Comment(
      id: doc.documentID,
      content: doc['content'],
      authorid: doc['authorid'],
      timestamp: doc['timestamp'],
    );
  }

  static void commentonpost({String currentuserid, String postid, String comment}){
    Firestore.instance.collection('comments').document(postid).collection('postcomments').add({
      'content': comment,
      'authorid': currentuserid,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    });
  }
}