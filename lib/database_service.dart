import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_model.dart';

class DatabaseServise{

  static void updateUser(User user){
    Firestore.instance.collection('users').document(user.id).updateData({
      'email': user.email,
      'name': user.name,
      'phonenumber': user.phonenumber,
      'profileimage': user.profileimage,
    });
  }
}