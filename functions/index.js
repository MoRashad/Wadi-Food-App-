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

exports.unUnfollowUser = functions.firestore
    .document('/followers/{userid}/userfollowers/{followerid}')
    .onDelete(async(snapshot, context) => {
        const userid = context.params.userid;
        const followerid = context.params.followerid;
        const userfeedref = admin.firestore()
            .collection('feeds')
            .doc(followerid)
            .collection('userfeed')
            .where('authorid', '==', userid);
        const userpostssnapshot = await userfeedref.get();
        userpostssnapshot.forEach(doc => {
            if (doc.exists) {
                doc.ref.delete();
            }
        });
    });

exports.onUploadPost = functions.firestore
    .document('/posts/{userid}/usersposts/{postid}')
    .onCreate(async(snapshot, context) => {
        console.log(snapshot.data());
        const userid = context.params.userid;
        const postid = context.params.postid;
        const userfollowerref = admin.firestore()
            .collection('followers')
            .doc(userid)
            .collection('userfollowers');
        const userfollowersnapshot = await userfollowerref.get();
        userfollowersnapshot.forEach(doc => {
            admin.firestore()
                .collection('feeds')
                .doc(doc.id)
                .collection('userfeed')
                .doc(postid)
                .set(snapshot.data());
        });
    });

exports.onUpdatePost = functions.firestore
    .document('/posts/{userid}/usersposts/{postid}')
    .onUpdate(async(snapshot, context) => {
        const userid = context.params.userid;
        const postid = context.params.postid;
        const newpostdata = snapshot.after.data();
        console.log(newpostdata);
        const userfollowerref = admin.firestore()
            .collection('followers')
            .doc(userid)
            .collection('userfollowers');
        const userfollowersnapshot = await userfollowerref.get();
        userfollowersnapshot.forEach(async userdoc => {
            const postref = admin.firestore()
                .collection('feeds')
                .doc(userdoc.id)
                .collection('userfeed');
            const postdoc = await postref.doc(postid).get();
            if (postdoc.exists) {
                postdoc.ref.update(newpostdata);
            }
        });
    });