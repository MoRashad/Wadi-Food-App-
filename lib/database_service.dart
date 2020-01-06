import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants.dart';

import 'user_model.dart';

class DatabaseServise{

  static void updateUser(User user){
    userRef.document(user.id).updateData({
      'email': user.email,
      'name': user.name,
      'phonenumber': user.phonenumber,
      'profileimage': user.profileimage,
    });
  }
}