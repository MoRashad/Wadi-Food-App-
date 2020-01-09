import 'package:cloud_firestore/cloud_firestore.dart';

import 'post_model.dart';
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
  static void createpost(Post post){
    Firestore.instance.collection('posts').document(post.authorid).collection('usersposts').add({
      'imageurl': post.imageurl,
      'description': post.description,
      'like': post.likes,
      'authorid': post.authorid,
      'timestamp': post.timestamp,
    });
  }
}