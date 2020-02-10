import 'package:cloud_firestore/cloud_firestore.dart';

class Offer{
  final String id;
  final String imageurl;
  final String description;
  final String authorid;

  Offer({
    this.id,
    this.authorid,
    this.description,
    this.imageurl,
  });

  factory Offer.fromDoc(DocumentSnapshot doc){
    return Offer(
      id: doc.documentID,
      imageurl: doc['imageurl'],
      description: doc['description'],
      authorid: doc['authorid'],
    );
  }
}