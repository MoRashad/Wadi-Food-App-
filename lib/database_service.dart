import 'package:cloud_firestore/cloud_firestore.dart';

import 'post_model.dart';
import 'user_model.dart';

class DatabaseServise {
  static void updateUser(User user) {
    Firestore.instance.collection('users').document(user.id).updateData({
      'email': user.email,
      'name': user.name,
      'phonenumber': user.phonenumber,
      'profileimage': user.profileimage,
    });
  }

  static void createpost(Post post) {
    Firestore.instance
        .collection('posts')
        .document(post.authorid)
        .collection('usersposts')
        .add({
      'imageurl': post.imageurl,
      'description': post.description,
      'likecount': post.likecount,
      'authorid': post.authorid,
      'timestamp': post.timestamp,
    });
  }

  static Future<QuerySnapshot> searchusers(String name) {
    Future<QuerySnapshot> users = Firestore.instance
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: name)
        .getDocuments();
    return users;
  }

  static void followuser(String currentuser, String userid) {
    Firestore.instance
        .collection('following')
        .document(currentuser)
        .collection('userfollowing')
        .document(userid)
        .setData({});

    Firestore.instance
        .collection('followers')
        .document(userid)
        .collection('userfollowers')
        .document(currentuser)
        .setData({});
  }

  static void unfollowuser(String currentuser, String userid) {
    Firestore.instance
        .collection('following')
        .document(currentuser)
        .collection('userfollowing')
        .document(userid)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    Firestore.instance
        .collection('followers')
        .document(userid)
        .collection('userfollowers')
        .document(currentuser)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static Future<bool> isfollowinguser(String currentuser, String userid) async {
    DocumentSnapshot followingdoc = await Firestore.instance
        .collection('followers')
        .document(userid)
        .collection('userfollowers')
        .document(currentuser)
        .get();
    return followingdoc.exists;
  }

  static Future<int> numfollowing(String userid) async {
    QuerySnapshot followingsnapshot = await Firestore.instance
        .collection('following')
        .document(userid)
        .collection('userfollowing')
        .getDocuments();
    return followingsnapshot.documents.length;
  }

  static Future<int> numfollowers(String userid) async {
    QuerySnapshot followersnapshot = await Firestore.instance
        .collection('followers')
        .document(userid)
        .collection('userfollowers')
        .getDocuments();
    return followersnapshot.documents.length;
  }

  static Future<List<Post>> getfeedposts(String userid) async {
    QuerySnapshot feedsnapshot = await Firestore.instance
        .collection('feeds')
        .document(userid)
        .collection('userfeed')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<Post> posts =
        feedsnapshot.documents.map((doc) => Post.fromDoc(doc)).toList();
    return posts;
  }

  static Future<List<Post>> getuserposts(String userid) async {
    QuerySnapshot userpostsnapshot = await Firestore.instance
        .collection('posts')
        .document(userid)
        .collection('usersposts')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<Post> posts =
        userpostsnapshot.documents.map((doc) => Post.fromDoc(doc)).toList();
    return posts;
  }

  static Future<User> getuserwithid(String userid) async {
    DocumentSnapshot userdocsnapshot =
        await Firestore.instance.collection('users').document(userid).get();
    if (userdocsnapshot.exists) {
      return User.fromDoc(userdocsnapshot);
    }
    return User();
  }

  static void likepost({String currentuserid, Post post}) {
    DocumentReference postref = Firestore.instance
        .collection('posts')
        .document(post.authorid)
        .collection('usersposts')
        .document(post.id);
    postref.get().then((doc) {
      int likecount = doc.data['likecount'];
      postref.updateData({'likecount': likecount + 1});
      Firestore.instance
          .collection('likes')
          .document(post.id)
          .collection('postlikes')
          .document(currentuserid)
          .setData({});
    });
  }

  static void unlikepost({String currentuserid, Post post}) {
    DocumentReference postref = Firestore.instance
        .collection('posts')
        .document(post.authorid)
        .collection('usersposts')
        .document(post.id);
    postref.get().then((doc) {
      int likecount = doc.data['likecount'];
      postref.updateData({'likecount': likecount - 1});
      Firestore.instance
          .collection('likes')
          .document(post.id)
          .collection('postlikes')
          .document(currentuserid)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    });
  }

  static Future<bool> didlikepost({String currentuserid, Post post}) async {
    DocumentSnapshot userdoc = await Firestore.instance
        .collection('likes')
        .document(post.id)
        .collection('postlikes')
        .document(currentuserid)
        .get();
    return userdoc.exists;
  }

  static void commentonpost(
      {String currentuserid, String postid, String comment}) {
    Firestore.instance
        .collection('comments')
        .document(postid)
        .collection('postcomments')
        .add({
      'content': comment,
      'authorid': currentuserid,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    });
  }
}
