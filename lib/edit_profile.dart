import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'database_service.dart';
import 'storage_service.dart';
import 'user_model.dart';

class EditProfile extends StatefulWidget {
  final User user;
  final String userid;
  EditProfile({this.user, this.userid});
  static final String id = 'EditProfile';
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formkey = GlobalKey<FormState>();
  File _profileimage;
  String _name;
  String _email;
  String _phonenummber;
  void initState(){
    super.initState();
    _name = widget.user.name;
    _email = widget.user.email;
    _phonenummber = widget.user.phonenumber;
  }

  _handleImageFromGallery() async{
    File imagefile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(imagefile != null){
      setState(() {
        _profileimage = imagefile;
      });
    }
  }
  _displayprofileimage(){
    if(_profileimage == null){
      if(widget.user.profileimage.isEmpty){
        return AssetImage('assets/images/user_placeholder.jpg');
      }
      else{
        return CachedNetworkImageProvider(widget.user.profileimage);
      }
    }else{
        return FileImage(_profileimage);
      }
  }
  _submit() async {
    if(_formkey.currentState.validate()){
      _formkey.currentState.save();
      String _profileimageUrl = '';
      if(_profileimage == null){
        _profileimageUrl = widget.user.profileimage;
      }else{
        _profileimageUrl = await StorageService.uploadUserProfileImage(widget.user.profileimage, _profileimage);
      }
      User user = User(
        id: widget.user.id,
        name: _name,
        email: _email,
        profileimage: _profileimageUrl,
        phonenumber: _phonenummber,
      );
      DatabaseServise.updateUser(user);
      Navigator.pop(context);

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Form(
              key: _formkey,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey,
                      backgroundImage: _displayprofileimage(),
                    ),
                    FlatButton(
                      onPressed: _handleImageFromGallery,
                      child: Text('Change Profile Picture', 
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      ),
                    ),
                    TextFormField(
                      initialValue: _name,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        icon: Icon(Icons.person,size: 20,),
                        labelText:'Name', 
                      ),
                      validator: (value){
                        if(value.trim().length<2){
                          return 'Enter A valid Name';
                        }
                        return null;
                      },
                      onSaved: (value){
                        _name = value;
                      },
                    ),
                    TextFormField(
                      initialValue: _email,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        icon: Icon(Icons.email,size: 20,),
                        labelText:'Email', 
                      ),
                      validator: (value){
                        if(value.isEmpty){
                          return 'Email Can\'t be empty';
                        }
                        return null;
                      },
                      onSaved: (value){
                        _email = value;
                      },
                    ),
                    TextFormField(
                      initialValue: _phonenummber,
                      style: TextStyle(
                        fontSize: 18,
                      ),

                      decoration: InputDecoration(
                        icon: Icon(Icons.phone,size: 20,),
                        labelText:'Phone Number', 
                      ),
                      validator: (value){
                        if(value.isEmpty){
                          return 'Field can\'t be empty';
                        }
                        return null;
                      },
                      onSaved: (value){
                        _phonenummber = value;
                      },
                    ),
                    Container(
                      margin: EdgeInsets.all(40),
                      height: 40,
                      width: 250,
                      child: FlatButton(
                        onPressed: _submit,
                        color: Colors.green,
                        child: Text('Save Changes',
                        style: TextStyle(fontSize: 16),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}