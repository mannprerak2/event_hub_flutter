import 'package:events_flutter/ui/tiles/event_list_tile.dart';
import 'package:events_flutter/ui/tiles/featured_swiper.tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../blocs/global_provider.dart';
import '../../blocs/global_bloc.dart';

class EventTab extends StatefulWidget {
  static const int batchSize = 3;
  static bool moreAvailable = true;

  static const int pastBatchSize = 3;
  static bool pastMoreAvailable = true;
  static bool showPast = false;

  @override
  _EventTabState createState() => _EventTabState();
}

class _EventTabState extends State<EventTab> {
  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = GlobalProvider.of(context);
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: FeaturedSwiper(),
        ),
        SliverToBoxAdapter(
          child: !EventTab.moreAvailable
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Upcoming Events',
                    style:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 20.0),
                  ),
                ),
        ),
        !EventTab.moreAvailable
            ? SliverToBoxAdapter()
            : PagewiseSliverList(
                pageSize: EventTab.batchSize,
                loadingBuilder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SpinKitFadingCube(
                      color: Theme.of(context).primaryColor,
                      size: 40.0,
                    ),
                  );
                },
                pageFuture: (pageIndex) {
                  return Future<List<DocumentSnapshot>>(() async {
                    if (globalBloc.eventListCache.length <=
                        pageIndex * EventTab.batchSize) {
                      if (!EventTab.moreAvailable)
                        return List<DocumentSnapshot>();
                      print('fetching...');
                      DocumentSnapshot last;
                      if (globalBloc.eventListCache.length > 0)
                        last = globalBloc.eventListCache.last;
                      //fetch
                      QuerySnapshot snapshot = await FirebaseFirestore.instance
                          .collection('events_mini')
                          .where('date',
                              isGreaterThan: last == null
                                  ? DateTime.now()
                                  : last.get('date'))
                          .orderBy('date')
                          .limit(EventTab.batchSize)
                          .get();
                      //store it to list
                      if (snapshot.docs.length < EventTab.batchSize) {
                        EventTab.moreAvailable = false;

                        // show past events as no more upcoming are available
                        EventTab.showPast = true;
                        if (this.mounted) setState(() {});
                      }
                      globalBloc.eventListCache.addAll(snapshot.docs);

                      return snapshot.docs;
                    } else {
                      print('from list');
                      //show from stored list
                      int end =
                          pageIndex * EventTab.batchSize + EventTab.batchSize;
                      if (globalBloc.eventListCache.length < end)
                        end = globalBloc.eventListCache.length;
                      return globalBloc.eventListCache
                          .getRange(pageIndex * EventTab.batchSize, end)
                          .toList();
                    }
                  });
                },
                itemBuilder: (context, entry, i) {
                  return EventListTile(entry);
                },
              ),
        SliverToBoxAdapter(
          child: !EventTab.showPast
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Past Events',
                    style:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 20.0),
                  ),
                ),
        ),
        !EventTab.showPast
            ? SliverToBoxAdapter()
            : PagewiseSliverList(
                pageSize: EventTab.pastBatchSize,
                loadingBuilder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SpinKitFadingCube(
                      color: Theme.of(context).primaryColor,
                      size: 40.0,
                    ),
                  );
                },
                pageFuture: (pageIndex) {
                  return Future<List<DocumentSnapshot>>(() async {
                    if (globalBloc.pastEventListCache.length <=
                        pageIndex * EventTab.pastBatchSize) {
                      if (!EventTab.pastMoreAvailable)
                        return List<DocumentSnapshot>();
                      print('fetching...');
                      DocumentSnapshot last;
                      if (globalBloc.pastEventListCache.length > 0)
                        last = globalBloc.pastEventListCache.last;
                      //fetch
                      QuerySnapshot snapshot = await FirebaseFirestore.instance
                          .collection('events_mini')
                          .where('date',
                              isLessThan: last == null
                                  ? DateTime.now()
                                  : last.get('date'))
                          .orderBy('date', descending: true)
                          .limit(EventTab.pastBatchSize)
                          .get();
                      //store it to list
                      if (snapshot.docs.length < EventTab.pastBatchSize) {
                        EventTab.pastMoreAvailable = false;
                      }
                      globalBloc.pastEventListCache.addAll(snapshot.docs);
                      print(snapshot.docs.length);

                      return snapshot.docs;
                    } else {
                      print('from list');
                      //show from stored list
                      int end = pageIndex * EventTab.pastBatchSize +
                          EventTab.pastBatchSize;
                      if (globalBloc.pastEventListCache.length < end)
                        end = globalBloc.pastEventListCache.length;
                      return globalBloc.pastEventListCache
                          .getRange(pageIndex * EventTab.pastBatchSize, end)
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
    );
  }
}
