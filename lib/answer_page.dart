import 'package:WadiFood/answer_model.dart';
import 'package:WadiFood/database_service.dart';
import 'package:WadiFood/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AnswerPage extends StatefulWidget {
  final String questionid;
  final String question;
  AnswerPage({this.questionid, this.question});
  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  final TextEditingController _answercontroller = TextEditingController();
  bool _isanswering = false;
  final String admin = 'mT9T2iHirsYhWlGhnsNJe9Q0LkM2';
  _buildanswer(Answer answer) {
    return FutureBuilder(
      future: DatabaseServise.getuserwithid(answer.authorid),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        return ListTile(
          title: Text(answer.content),
          subtitle:
              Text(DateFormat.yMd().add_jm().format(answer.timestamp.toDate())),
        );
      },
    );
  }

  _buildanswertf() {
    final currentuserid = Provider.of<Userdata>(context).currentuserid;
    return IconTheme(
      data: IconThemeData(
        color: _isanswering
            ? Theme.of(context).accentColor
            : Theme.of(context).disabledColor,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _answercontroller,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (answer) {
                  setState(() {
                    _isanswering = answer.length > 0;
                  });
                },
                decoration:
                    InputDecoration.collapsed(hintText: 'Post an answer...'),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if(_isanswering){
                    DatabaseServise.answerquestion(
                      currentuserid: currentuserid,
                      questionid: widget.questionid,
                      answer: _answercontroller.text,
                    );
                    _answercontroller.clear();
                    setState(() {
                      _isanswering = false;
                    });
                  }
                }
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Answers'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              widget.question,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          StreamBuilder(
            stream: Firestore.instance
                .collection('answers')
                .document(widget.questionid)
                .collection('postanswer')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    Answer answer =
                        Answer.fromDoc(snapshot.data.documents[index]);
                    return _buildanswer(answer);
                  },
                ),
              );
            },
          ),
          Divider(height: 1,),
          admin == Provider.of<Userdata>(context).currentuserid 
          ? _buildanswertf()
          : SizedBox.shrink(),
        ],
      ),
    );
  }
}
