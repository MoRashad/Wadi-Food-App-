import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String profileimage;
  final String phonenumber;

  User({
    this.id,
    this.name,
    this.email,
    this.profileimage,
    this.phonenumber,
  });

  factory User.fromDoc(DocumentSnapshot doc){
    return User(
      id: doc.documentID,
      name: doc['name'],
      email: doc['email'],
      profileimage: doc['profileimage'],
      phonenumber: doc['phonenumber'] ?? '',
    );
  }
}
