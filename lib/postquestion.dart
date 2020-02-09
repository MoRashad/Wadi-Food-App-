import 'package:WadiFood/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'questions_models.dart';

class PostQuestion extends StatefulWidget {
  final String userid;
  PostQuestion({this.userid, Question question});
  static final String id = 'postquestion';
  @override
  _PostQuestionState createState() => _PostQuestionState();
}

class _PostQuestionState extends State<PostQuestion> {
  TextEditingController _captioncontroller = TextEditingController();
  String _caption = '';
  bool _isloading = false;

  _submit() async{
    if(!_isloading && _caption.isNotEmpty){
      setState(() {
        _isloading = true;
      });
      Question question = Question(
        authorid: widget.userid,
        question: _caption,
        timestamp: Timestamp.fromDate(DateTime.now()),
      );
      DatabaseServise.postquestion(question);
      _captioncontroller.clear();
      setState(() {
        _caption = '';
        _isloading = false;
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text('Post a question'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.send), onPressed: () { _submit();}),
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
                        padding: EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.blue[200],
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                        ),
                      )
                    : SizedBox.shrink(),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: TextField(
                    maxLines: 15,
                    controller: _captioncontroller,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Post a question...',
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
