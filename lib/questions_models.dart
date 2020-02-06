import 'package:cloud_firestore/cloud_firestore.dart';

class Question{
  final String id;
  final String question;
  final String authorid;
  final Timestamp timestamp;

  Question({
    this.id,
    this.authorid,
    this.question,
    this.timestamp,
  });

  factory Question.fromDoc(DocumentSnapshot doc){
    return Question(
      id: doc.documentID,
      authorid: doc['author'],
      question: doc['question'],
      timestamp: doc['timestamp'],
    );
  }
}