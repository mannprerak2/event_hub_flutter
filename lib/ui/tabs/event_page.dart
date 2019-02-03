import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:events_flutter/blocs/global_provider.dart';
import 'package:events_flutter/states/event_page_states.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class EventDetailPage extends StatefulWidget {
  final String id;
  final GlobalBloc globalBloc;

  EventDetailPage(this.id, this.globalBloc);

  @override
  EventDetailPageState createState() => EventDetailPageState();
}

class EventDetailPageState extends State<EventDetailPage> {
  StreamController<EventPageStates> controller;
  ScrollController _scrollController;
  static const kExpandedHeight = 220.0;

  @override
  void initState() {
    controller = StreamController<EventPageStates>();
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    //check if document is in cache
    DocumentSnapshot snap = widget.globalBloc.eventPageCache.firstWhere((e) {
      return (e.documentID == widget.id);
    }, orElse: () => null);

    if (snap != null) {
      controller.add(SucessPage(snap));
    } else {
      //fetch document here...
      Firestore.instance
          .collection('events')
          .document(widget.id)
          .get()
          .then((snapshot) {
        //save to cache
        widget.globalBloc.eventPageCache.add(snapshot);
        controller.add(SucessPage(snapshot));
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: StreamBuilder<Object>(
            initialData: LoadingPage(),
            stream: controller.stream,
            builder: (context, snapshot) {
              if (snapshot.data is LoadingPage) {
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    leading: BackButton(
                      color: Colors.grey,
                    ),
                  ),
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.data is ErrorPage) {
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    leading: BackButton(
                      color: Colors.grey,
                    ),
                  ),
                  body: Center(
                    child: Text('Some Error Occured'),
                  ),
                );
              } else if (snapshot.data is SucessPage) {
                DocumentSnapshot doc = (snapshot.data as SucessPage).snap;
                return CustomScrollView(
                  controller: _scrollController,
                  slivers: <Widget>[
                    SliverAppBar(
                      pinned: true,
                      leading: BackButton(),
                      title: _showTitle ? Text(doc['name']) : null,
                      expandedHeight: kExpandedHeight,
                      flexibleSpace: FlexibleSpaceBar(
                        background: CachedNetworkImage(
                          imageUrl: doc['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                            color: Colors.white,
                            height: 100.0,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.calendar_today, size: 50),
                                  Padding(
                                    padding: EdgeInsets.only(top: 30, left: 20),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          'Event Name',
                                          style: TextStyle(
                                            fontSize: 28,
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontWeight: FontWeight.normal,
                                            decoration: TextDecoration.none,
                                            fontFamily: "Times New Roman",
                                          ),
                                        ),
                                        Text(
                                          'Society Name',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontWeight: FontWeight.normal,
                                            decoration: TextDecoration.none,
                                            fontFamily: "Times New Roman",
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )),
                        Container(
                            color: Colors.white,
                            height: 80.0,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Icon(Icons.star,
                                      size: 40, semanticLabel: 'Fav'),
                                  Icon(Icons.desktop_windows, size: 40),
                                  Icon(Icons.share, size: 40),
                                  Icon(Icons.more, size: 40),
                                ],
                              ),
                            )),
                        Container(
                            color: Colors.white,
                            child: ListView(
                              shrinkWrap: true,
                              padding: EdgeInsets.only(left: 10, top: 10),
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.thumb_up),
                                        Text(
                                          '  43 people are going',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontWeight: FontWeight.normal,
                                            decoration: TextDecoration.none,
                                            fontFamily: "Times New Roman",
                                          ),
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.cloud_circle),
                                        Text(
                                          '  Fri, 14 Jan at 10:00 to 13:00 IST',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontWeight: FontWeight.normal,
                                            decoration: TextDecoration.none,
                                            fontFamily: "Times New Roman",
                                          ),
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.pin_drop),
                                        Text(
                                          '  B.R. Auditorium',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontWeight: FontWeight.normal,
                                            decoration: TextDecoration.none,
                                            fontFamily: "Times New Roman",
                                          ),
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.bookmark),
                                        Text(
                                          '  Tickets Available',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontWeight: FontWeight.normal,
                                            decoration: TextDecoration.none,
                                            fontFamily: "Times New Roman",
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            )),
                        Container(
                          color: Colors.white,
                          height: 150.0,
                          child: Text(
                            'Section 1',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none,
                              fontFamily: "Times New Roman",
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          height: 150.0,
                          child: Text(
                            'Section 2',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none,
                              fontFamily: "Times New Roman",
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          height: 150.0,
                          child: Text(
                            'Section 3',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none,
                              fontFamily: "Times New Roman",
                            ),
                          ),
                        ),
                      ]),
                    )
                  ],
                );
              }
            }));
  }
}
