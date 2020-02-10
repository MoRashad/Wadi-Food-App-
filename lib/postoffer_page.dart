import 'dart:io';
import 'package:WadiFood/database_service.dart';
import 'package:WadiFood/storage_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'offers_model.dart';

class PostofferPage extends StatefulWidget {
  final String userid;
  PostofferPage({this.userid, Offer offer});
  static final String id = 'PostOffer';

  @override
  _PostofferPageState createState() => _PostofferPageState();
}

class _PostofferPageState extends State<PostofferPage> {
  File _image;
  TextEditingController _captioncontroller = TextEditingController();
  String _caption = '';
  bool _isloading = false;
  _showselectedimagedialog() {
    return Platform.isIOS ? _iosbottomsheet() : _androiddialog();
  }

  _iosbottomsheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text('Add Photo'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                onPressed: () {
                  _handleimage(ImageSource.gallery);
                },
                child: Text('Choose from gallery'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          );
        });
  }

  _androiddialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Add Photo'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Choose from gallery'),
                onPressed: () {
                  _handleimage(ImageSource.gallery);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  _handleimage(ImageSource source) async {
    Navigator.pop(context);
    File imagefile = await ImagePicker.pickImage(source: source);
    if (imagefile != null) {
      imagefile = await _cropimage(imagefile);
      setState(() {
        _image = imagefile;
      });
    }
  }

  _cropimage(File imagefile) async {
    File croppedimage = await ImageCropper.cropImage(
      sourcePath: imagefile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 0.5),
    );
    return croppedimage;
  }

  _submit() async{
  if(!_isloading && _image != null && _caption.isNotEmpty){
    setState(() {
      _isloading = true;
    });
    String imageurl = await StorageService.uploadofferphoto(_image);
    Offer offer = Offer(
      imageurl: imageurl,
      description: _caption,
      authorid: widget.userid,
    );
    DatabaseServise.createoffer(offer);

    _captioncontroller.clear();

    setState(() {
      _caption = '';
      _image = null;
      _isloading = false;
      Navigator.pop(context);
    });
  }
}

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.width / 2;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Offer'),
        elevation: 0,
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                _submit();
                print('post');
              }),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                _isloading
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.blue[200],
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                        ))
                    : SizedBox.shrink(),
                GestureDetector(
                  onTap: _showselectedimagedialog,
                  child: Container(
                    height: height,
                    width: width,
                    color: Colors.grey,
                    child: _image == null
                        ? Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                            size: 150,
                        )
                        : Image(
                            image: FileImage(_image),
                            fit: BoxFit.cover,
                        ),
                  ),
                ),
                SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: TextField(
                    controller: _captioncontroller,
                    style: TextStyle(fontSize: 18,),
                    decoration: InputDecoration(
                      hintText: 'Description',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _caption = value.trim(),
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
