
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'database_service.dart';
import 'storage_service.dart';
import 'post_model.dart';

class PostPhoto extends StatefulWidget {
  final String userid;
  PostPhoto({this.userid, Post post});
  static final String id = 'postphoto';
  @override
  _PostPhotoState createState() => _PostPhotoState();
}

class _PostPhotoState extends State<PostPhoto> {
  File _image;
  TextEditingController _captioncontroller = TextEditingController();
  String _caption = '';
  bool _isloading = false;
  _showselectedimagedialog(){
  return Platform.isIOS ? _iosbottomsheet() : _androiddialog();
}
_iosbottomsheet(){
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context){
      return CupertinoActionSheet(
        title: Text('Add Photo'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text('Take Photo'),
            onPressed: (){
              _handleimage(ImageSource.camera);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Choose from gallery'),
            onPressed: (){
              _handleimage(ImageSource.gallery);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text('Cancel'),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      );
    },
  );
}
_androiddialog(){
  showDialog(
    context: context,
    builder: (BuildContext context){
      return SimpleDialog(
        title: Text('Add Photo'),
        children: <Widget>[
          SimpleDialogOption(
            child: Text('Take Photo'),
            onPressed: (){
              _handleimage(ImageSource.camera);
            },
          ),
          SimpleDialogOption(
            child: Text('Choose from gallery'),
            onPressed: (){
              _handleimage(ImageSource.gallery);
            },
          ),
          SimpleDialogOption(
          child: Text('Cancel',style: TextStyle(color: Colors.redAccent),),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        ],
      );
    },
  );
}

_handleimage(ImageSource source) async{
  Navigator.pop(context);
  File imagefile = await ImagePicker.pickImage(source: source);
  if(imagefile != null){
    imagefile = await _cropimage(imagefile);
    setState((){
      _image = imagefile;
    });
  }

}

_cropimage(File imagefile) async{
  File croppedimage = await ImageCropper.cropImage(
    sourcePath: imagefile.path,
    aspectRatio: CropAspectRatio(ratioX: 1.0 , ratioY: 1.0),
  );
  return croppedimage;
}
_submit() async{
  if(!_isloading && _image != null && _caption.isNotEmpty){
    setState(() {
      _isloading = true;
    });
    String imageurl = await StorageService.uploadpost(_image);
    Post post = Post(
      imageurl: imageurl,
      description: _caption,
      likecount: 0,
      authorid: widget.userid,
      timestamp: Timestamp.fromDate(DateTime.now())
    );
    DatabaseServise.createpost(post);

    _captioncontroller.clear();

    setState(() {
      _caption = '';
      _image = null;
      _isloading = false;
    });
  }
}
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.width;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text('Post A Photo'),
        actions: <Widget>[
          IconButton(
            onPressed: (){
              _submit();
              Navigator.pop(context);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                _isloading 
                ? 
                Padding(
                  padding: EdgeInsets.only(bottom: 10,),
                  child:  LinearProgressIndicator(
                    backgroundColor: Colors.blue[200],
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  ),
                )
                : SizedBox.shrink(),
                GestureDetector(
                  onTap: _showselectedimagedialog,  
                  child: Container(
                    height: height,
                    width: width,
                    color: Colors.green,
                    child: _image == null 
                    ? Icon(Icons.add_a_photo,
                      color: Colors.white,
                      size: 150,)
                    : Image(
                      image: FileImage(_image),
                      fit: BoxFit.cover
                    ),
                  ) 
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: TextField(
                    controller: _captioncontroller,
                    style: TextStyle(fontSize: 18,),
                    decoration: InputDecoration(labelText: 'Description'),
                    onChanged: (value) => _caption = value,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}