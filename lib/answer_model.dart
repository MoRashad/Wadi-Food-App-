import 'package:cloud_firestore/cloud_firestore.dart';

class Answer{
  final String id;
  final String content;
  final String authorid;
  final Timestamp timestamp;

  Answer({
    this.id,
    this.content,
    this.authorid,
    this.timestamp,
  });

  factory Answer.fromDoc(DocumentSnapshot doc) {
    return Answer(
      id: doc.documentID,
      content: doc['content'],
      authorid: doc['authorid'],
      timestamp: doc['timestamp'],
    );
  }
  
}