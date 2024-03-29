import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class StorageService{
  static Future<String> uploadUserProfileImage(String url, File imagefile) async{
    String photoId = Uuid().v4();
    File image = await compressImage(photoId, imagefile);
    if(url.isNotEmpty){
      RegExp exp = RegExp(r'userprofile_(.*).jpg');
      photoId = exp.firstMatch(url)[1];
    }
    StorageUploadTask uploadtask = FirebaseStorage.instance.ref().child('images/users/userprofile_$photoId.jpg').putFile(image);
    StorageTaskSnapshot storagesnap = await uploadtask.onComplete;
    String downloadUrl = await storagesnap.ref.getDownloadURL();
    return downloadUrl;
  }
  static Future<File> compressImage(String photoId, File image) async{
    final tempDir = await getTemporaryDirectory();
    final path  = tempDir.path;
    File compressedImageFile = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      '$path/img_$photoId.jpg',
      quality: 70, 
    );
    return compressedImageFile;
  }
  static Future<String> uploadpost(File imagefile) async{
    String photoId = Uuid().v4();
    File image = await compressImage(photoId, imagefile);
    StorageUploadTask uploadtask = FirebaseStorage.instance.ref().child('images/posts/post_$photoId.jpg').putFile(image);
    StorageTaskSnapshot storagesnap = await uploadtask.onComplete;
    String downloadUrl = await storagesnap.ref.getDownloadURL();
    return downloadUrl;
  }
  static Future<String> uploadofferphoto(File imagefile) async{
    String photoId = Uuid().v4();
    File image = await compressImage(photoId, imagefile);
    StorageUploadTask uploadtask = FirebaseStorage.instance.ref().child('images/offer/offer_$photoId.jpg').putFile(image);
    StorageTaskSnapshot storagesnap = await uploadtask.onComplete;
    String downloadUrl = await storagesnap.ref.getDownloadURL();
    return downloadUrl;
  }
}