import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:events_flutter/blocs/global_provider.dart';
import 'package:events_flutter/states/event_page_states.dart';
import 'package:events_flutter/ui/tabs/photo_page.dart';
import 'package:events_flutter/ui/tiles/bookmark_button.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

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
  final DateFormat formatter = DateFormat("EEE, MMM d");
  final DateFormat formatterTime = DateFormat("h:mm a");

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
                doc.data['id'] = doc.documentID;
                return Scaffold(
                  body: CustomScrollView(
                    controller: _scrollController,
                    slivers: <Widget>[
                      SliverAppBar(
                        pinned: true,
                        actions: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.share,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          )
                        ],
                        leading: BackButton(),
                        title: _showTitle ? Text(doc['name']) : null,
                        expandedHeight: kExpandedHeight,
                        flexibleSpace: FlexibleSpaceBar(
                          background: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      PhotoPage(doc['image'])));
                            },
                            child: CachedNetworkImage(
                              imageUrl: doc['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Text(
                                    doc['name'],
                                    style: TextStyle(fontSize: 25, ),
                                  )),
                                  BookmarkButton(
                                      doc.data, GlobalProvider.of(context))
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Text(
                                "Organised by ${doc['society_fullname']} at ${doc['location']}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w200),
                              ),
                            ),
                            Divider(),
                            Container(
                              height: 90,
                              child: Row(
                                children: <Widget>[
                                  Card(
                                    color: Colors.blue[900],
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              'f',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 35),
                                            ),
                                          ),
                                          Text(
                                            'Open on Facebook',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Card(
                                      color: Colors.white,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Text(
                                                    formatter.format(
                                                        doc['date'].toDate()),
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        color:
                                                            Colors.green[600],
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 30),
                                                  ),
                                                  Text(
                                                    formatterTime.format(
                                                        doc['date'].toDate()),
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        color:
                                                            Colors.green[300],
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 20),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            RotatedBox(
                                              quarterTurns: 1,
                                              child: Divider(),
                                            ),
                                            Column(
                                              children: <Widget>[
                                                Expanded(
                                                    child: Icon(
                                                  Icons.calendar_today,
                                                  color: Colors.green[800],
                                                )),
                                                Text(
                                                  'Set Reminder',
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Details',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 20.0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(doc['details']),
                            ),
                            Container(
                              height: 150,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
            }));
  }
}
