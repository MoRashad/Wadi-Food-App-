import 'package:WadiFood/database_service.dart';
import 'package:WadiFood/postoffer_page.dart';
import 'package:WadiFood/user_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_alert/easy_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'offers_model.dart';

class SpecialOffersPage extends StatefulWidget {
  static final String id = 'Special Offers';
  final String userid;
  SpecialOffersPage({this.userid});
  @override
  _SpecialOffersPageState createState() => _SpecialOffersPageState();
}

class _SpecialOffersPageState extends State<SpecialOffersPage> {
  List<Offer> _offers = [];
  final String _admin = 'mT9T2iHirsYhWlGhnsNJe9Q0LkM2';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setupoffers();
  }

  _setupoffers() async {
    List<Offer> offers = await DatabaseServise.getalloffers();
    setState(() {
      _offers = offers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Special Offers',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _setupoffers(),
        child: ListView.builder(
          itemCount: _offers.length,
          itemBuilder: (BuildContext context, int index) {
            return FutureBuilder(
              future: DatabaseServise.getalloffers(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                Offer offer = _offers[index];
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
                            border:
                                Border.all(width: 2, color: Colors.grey[300]),
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          padding: EdgeInsets.all(6),
                          margin: EdgeInsets.all(10),
                          width: double.infinity,
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: MediaQuery.of(context).size.width / 2,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        offer.imageurl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                offer.description,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              _admin ==
                                      Provider.of<Userdata>(context)
                                          .currentuserid
                                  ? FlatButton(
                                      onPressed: () async {
                                        await Firestore.instance
                                            .collection('offers')
                                            .document(offer.id)
                                            .delete();
                                        //print(offer.id);
                                        Alert.toast(context, "Offer deleted refresh page",
                                            position: ToastPosition.bottom,
                                            duration: ToastDuration.long);
                                      },
                                      child: Text('delete offer'),
                                    )
                                  : SizedBox.shrink(),
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
      floatingActionButton: _admin == widget.userid
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(PostofferPage.id);
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.green,
            )
          : SizedBox.shrink(),
    );
  }
}
