import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:events_flutter/blocs/global_provider.dart';
import 'package:events_flutter/states/event_page_states.dart';
import 'package:events_flutter/ui/tabs/photo_page.dart';
import 'package:events_flutter/ui/tiles/bookmark_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

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
      return (e.id == widget.id);
    }, orElse: () => null);

    if (snap != null) {
      controller.add(SucessPage(snap));
    } else {
      //fetch document here...
      FirebaseFirestore.instance
          .collection('events')
          .doc(widget.id)
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
                    child: SpinKitFadingCube(
                      color: Color(0xffB54646),
                      size: 50.0,
                    ),
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
                // doc.data()['id'] = doc.id; // Doesn't work
                return Scaffold(
                  body: CustomScrollView(
                    controller: _scrollController,
                    slivers: <Widget>[
                      SliverAppBar(
                        pinned: true,
                        leading: BackButton(),
                        title: _showTitle ? Text(doc.get('name')) : null,
                        expandedHeight: kExpandedHeight,
                        flexibleSpace: FlexibleSpaceBar(
                          background: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      PhotoPage(doc.get('image'))));
                            },
                            child: CachedNetworkImage(
                              imageUrl: doc.get('image'),
                              placeholder: (context, url) => const Icon(
                                Icons.image_not_supported_sharp,
                                color: Color(0xFFEF9A9A),
                                size: 100.0,
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.image_not_supported_sharp,
                                color: Color(0xFFEF9A9A),
                                size: 100.0,
                              ),
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
                                    doc.get('name'),
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  )),
                                  BookmarkButton(
                                      doc.data()
                                        ..putIfAbsent('id', () => doc.id),
                                      GlobalProvider.of(context))
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Text(
                                "Organised by ${doc.get('society_fullname')} at ${doc.get('location')}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w200),
                              ),
                            ),
                            Divider(),
                            Container(
                              height: 100,
                              child: Row(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () async {
                                      String url =
                                          "https://www.facebook.com/${doc.id}";
                                      if (await canLaunch(url)) {
                                        launch(url);
                                      }
                                    },
                                    child: Card(
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
                                                  FittedBox(
                                                    child: Text(
                                                      formatter.format(doc
                                                          .get('date')
                                                          .toDate()),
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          color:
                                                              Colors.green[600],
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontSize: 30),
                                                    ),
                                                  ),
                                                  FittedBox(
                                                    child: Text(
                                                      formatterTime.format(doc
                                                          .get('date')
                                                          .toDate()),
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          color:
                                                              Colors.green[300],
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontSize: 20),
                                                    ),
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
                                                    child: GestureDetector(
                                                  onTap: () {
                                                    //set reminder
                                                    final Event event = Event(
                                                      title:
                                                          "${doc.get('name')} (reminder by EventHub)",
                                                      description:
                                                          'Event reminder by EventHub',
                                                      location:
                                                          doc.get('location'),
                                                      startDate: doc
                                                          .get('date')
                                                          .toDate(),
                                                      endDate: doc
                                                          .get('date')
                                                          .toDate(),
                                                    );
                                                    Add2Calendar.addEvent2Cal(
                                                        event);
                                                  },
                                                  child: Icon(
                                                    Icons.event_available,
                                                    color: Colors.green[800],
                                                    size: 40,
                                                  ),
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
                                child: Linkify(
                                  text: doc.get('details'),
                                  onOpen: (link) async {
                                    if (await canLaunch(link.url)) {
                                      await launch(link.url);
                                    }
                                  },
                                )),
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
              throw Exception("Unknown state for event page");
            }));
  }
}
