const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.onFollowUser = functions.firestore
    .document('/followers/{userid}/userfollowers/{followerid}')
    .onCreate(async(snapshot, context) => {
        console.log(snapshot.data());
        const userid = context.params.userid;
        const followerid = context.params.followerid;
        const followeduserpostref = admin.firestore()
            .collection('posts')
            .doc(userid)
            .collection('usersposts');
        const userfeedref = admin.firestore()
            .collection('feeds')
            .doc(followerid).collection('userfeed');
        const followeduserpostsnapshot = await followeduserpostref.get();
        followeduserpostsnapshot.forEach(doc => {
            if (doc.exists) {
                userfeedref.doc(doc.id).set(doc.data());
            }
        });
    });