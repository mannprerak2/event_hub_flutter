import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:events_flutter/states/event_page_states.dart';
import 'package:events_flutter/ui/tabs/photo_page.dart';
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
                        background: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PhotoPage(doc['image'])));
                          },
                          child: CachedNetworkImage(
                            imageUrl: doc['image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            }));
  }
}
