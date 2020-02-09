import 'package:WadiFood/answer_page.dart';
import 'package:WadiFood/database_service.dart';
import 'package:WadiFood/postquestion.dart';
import 'package:WadiFood/questions_models.dart';
import 'package:flutter/material.dart';

class HealthConsultant extends StatefulWidget {
  static final String id = 'healthconsutlant';
  final String userid;
  HealthConsultant({this.userid});
  @override
  _HealthConsultantState createState() => _HealthConsultantState();
}

class _HealthConsultantState extends State<HealthConsultant> {
  List<Question> _questions = [];

  void initState() {
    super.initState();
    _setupquestions();
  }

  _setupquestions() async {
    List<Question> questions = await DatabaseServise.getallquestions();
    setState(() {
      _questions = questions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health consultant'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () => _setupquestions(),
        child: ListView.builder(
          itemCount: _questions.length,
          itemBuilder: (BuildContext context, int index) {
            Question question = _questions[index];
            return FutureBuilder(
              future: DatabaseServise.getuserwithid(question.authorid),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      fit: StackFit.loose,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.rectangle,
                            border: Border.all(width: 2, color: Colors.grey[300]),
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          padding: EdgeInsets.all(6),
                          margin: EdgeInsets.all(10),
                          width: double.infinity,
                          child: Column(
                            children: <Widget>[
                              Text(question.question,
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 7,),
                              Divider(),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AnswerPage(
                                      questionid: question.id,
                                      question: question.question,
                                    ),
                                  )
                                ),
                                child:  Icon(Icons.question_answer),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(PostQuestion.id);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
