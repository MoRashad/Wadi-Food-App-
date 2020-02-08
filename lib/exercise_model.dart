import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise{
  final String id;
  final String weight;
  final String authorid;

  Exercise({
    this.id,
    this.authorid,
    this.weight,
  });

  factory Exercise.formDoc(DocumentSnapshot doc){
    return Exercise(
      id: doc.documentID,
      authorid: doc['authorid'],
      weight: doc['weight'],
    );
  }
}