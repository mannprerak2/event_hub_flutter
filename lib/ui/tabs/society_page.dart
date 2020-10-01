import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:events_flutter/ui/tabs/photo_page.dart';
import 'package:events_flutter/ui/tiles/event_list_tile.dart';
import 'package:events_flutter/ui/tiles/subscribe_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class SocietyDetailPage extends StatefulWidget {
  final String id;
  final GlobalBloc globalBloc;
  final Map<String, dynamic> snapshot;

  SocietyDetailPage(this.id, this.globalBloc, this.snapshot);

  @override
  SocietyDetailPageState createState() => SocietyDetailPageState();
}

class SocietyDetailPageState extends State<SocietyDetailPage> {
  ScrollController _scrollController;
  static const kExpandedHeight = 220.0;

  final List<DocumentSnapshot> eventListCache = [];
  final List<DocumentSnapshot> pastEventListCache = [];

  int batchSize = 3;
  bool moreAvailable = true;

  int pastBatchSize = 3;
  bool pastMoreAvailable = true;

  bool showPast = false;
  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    super.initState();
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Scaffold(
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
                title: _showTitle ? Text(widget.snapshot['name']) : null,
                expandedHeight: kExpandedHeight,
                flexibleSpace: FlexibleSpaceBar(
                  background: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              PhotoPage(widget.snapshot['image'])));
                    },
                    child: CachedNetworkImage(
                      imageUrl: widget.snapshot['image'],
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
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Text(
                            widget.snapshot['fullName'],
                            style: TextStyle(fontSize: 25),
                          )),
                          SubscribeButton(widget.snapshot, widget.globalBloc)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        "${widget.snapshot['descp']}",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w200),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        String url =
                            "https://www.facebook.com/${widget.snapshot['id']}";
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
                              Text(
                                'Open on Facebook',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Upcoming Events',
                    style:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 20.0),
                  ),
                ),
              ),
              PagewiseSliverList(
                pageSize: batchSize,
                pageFuture: (pageIndex) {
                  return Future<List<DocumentSnapshot>>(() async {
                    if (eventListCache.length <= pageIndex * batchSize) {
                      if (!moreAvailable) return List<DocumentSnapshot>();
                      print('fetching...');
                      DocumentSnapshot last;
                      if (eventListCache.length > 0) last = eventListCache.last;
                      //fetch
                      QuerySnapshot snapshot = await FirebaseFirestore.instance
                          .collection('events_mini')
                          .where('date',
                              isGreaterThan: last == null
                                  ? DateTime.now()
                                  : last.get('date'))
                          .where('society', isEqualTo: widget.snapshot['name'])
                          .orderBy('date')
                          .limit(batchSize)
                          .get();
                      //store it to list
                      if (snapshot.docs.length < batchSize) {
                        moreAvailable = false;

                        // show past events as no more upcoming are available
                        showPast = true;
                        if (this.mounted) setState(() {});
                      }
                      eventListCache.addAll(snapshot.docs);
                      print(snapshot.docs.length);

                      return snapshot.docs;
                    } else {
                      print('from list');
                      //show from stored list
                      int end = pageIndex * batchSize + batchSize;
                      if (eventListCache.length < end)
                        end = eventListCache.length;
                      return eventListCache
                          .getRange(pageIndex * batchSize, end)
                          .toList();
                    }
                  });
                },
                noItemsFoundBuilder: (context) {
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("No Upcoming Events"),
                      ),
                      Divider()
                    ],
                  );
                },
                itemBuilder: (context, entry, i) {
                  return EventListTile(entry);
                },
              ),
              SliverToBoxAdapter(
                child: !showPast
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Past Events',
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 20.0),
                        ),
                      ),
              ),
              !showPast
                  ? SliverToBoxAdapter()
                  : PagewiseSliverList(
                      pageSize: pastBatchSize,
                      pageFuture: (pageIndex) {
                        return Future<List<DocumentSnapshot>>(() async {
                          if (pastEventListCache.length <=
                              pageIndex * pastBatchSize) {
                            if (!pastMoreAvailable)
                              return List<DocumentSnapshot>();
                            print('fetching...');
                            DocumentSnapshot last;
                            if (pastEventListCache.length > 0)
                              last = pastEventListCache.last;
                            //fetch
                            QuerySnapshot snapshot = await FirebaseFirestore
                                .instance
                                .collection('events_mini')
                                .where('date',
                                    isLessThan: last == null
                                        ? DateTime.now()
                                        : last.get('date'))
                                .where('society',
                                    isEqualTo: widget.snapshot['name'])
                                .orderBy('date', descending: true)
                                .limit(pastBatchSize)
                                .get();
                            //store it to list
                            if (snapshot.docs.length < pastBatchSize) {
                              pastMoreAvailable = false;
                            }
                            pastEventListCache.addAll(snapshot.docs);
                            print(snapshot.docs.length);

                            return snapshot.docs;
                          } else {
                            print('from list');
                            //show from stored list
                            int end = pageIndex * pastBatchSize + pastBatchSize;
                            if (pastEventListCache.length < end)
                              end = pastEventListCache.length;
                            return pastEventListCache
                                .getRange(pageIndex * pastBatchSize, end)
                                .toList();
                          }
                        });
                      },
                      noItemsFoundBuilder: (context) {
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("No Past Events"),
                            ),
                          ],
                        );
                      },
                      itemBuilder: (context, entry, i) {
                        return EventListTile(entry);
                      },
                    ),
            ],
          ),
        ));
  }
}
