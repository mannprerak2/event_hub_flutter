import 'package:events_flutter/ui/tiles/event_list_tile.dart';
import 'package:events_flutter/ui/tiles/featured_swiper.tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../blocs/global_provider.dart';
import '../../blocs/global_bloc.dart';

class EventTab extends StatefulWidget {
  static const int batchSize = 3;
  static bool moreAvailable = true;

  static const int pastBatchSize = 3;
  static bool pastMoreAvailable = true;
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Upcoming Events',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20.0),
            ),
          ),
        ),
        PagewiseSliverList(
          pageSize: EventTab.batchSize,
          pageFuture: (pageIndex) {
            return Future<List<DocumentSnapshot>>(() async {
              if (globalBloc.eventListCache.length <=
                  pageIndex * EventTab.batchSize) {
                if (!EventTab.moreAvailable) return List<DocumentSnapshot>();
                print('fetching...');
                DocumentSnapshot last;
                if (globalBloc.eventListCache.length > 0)
                  last = globalBloc.eventListCache.last;
                //fetch
                QuerySnapshot snapshot = await Firestore.instance
                    .collection('events_mini')
                    .where('date',
                        isGreaterThan:
                            last == null ? DateTime.now() : last['date'])
                    .orderBy('date')
                    .limit(EventTab.batchSize)
                    .getDocuments();
                //store it to list
                if (snapshot.documents.length < EventTab.batchSize) {
                  EventTab.moreAvailable = false;

                  // show past events as no more upcoming are available
                  globalBloc.showPast = true;
                  if (this.mounted) setState(() {});
                }
                globalBloc.eventListCache.addAll(snapshot.documents);
                print(snapshot.documents.length);

                return snapshot.documents;
              } else {
                print('from list');
                //show from stored list
                int end = pageIndex * EventTab.batchSize + EventTab.batchSize;
                if (globalBloc.eventListCache.length < end)
                  end = globalBloc.eventListCache.length;
                return globalBloc.eventListCache
                    .getRange(pageIndex * EventTab.batchSize, end)
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
              ],
            );
          },
          itemBuilder: (context, entry, i) {
            return EventListTile(entry);
          },
        ),
        SliverToBoxAdapter(
          child: !globalBloc.showPast
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
        !globalBloc.showPast
            ? SliverToBoxAdapter()
            : PagewiseSliverList(
                pageSize: EventTab.pastBatchSize,
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
                      QuerySnapshot snapshot = await Firestore.instance
                          .collection('events_mini')
                          .where('date',
                              isLessThan:
                                  last == null ? DateTime.now() : last['date'])
                          .orderBy('date', descending: true)
                          .limit(EventTab.pastBatchSize)
                          .getDocuments();
                      //store it to list
                      if (snapshot.documents.length < EventTab.pastBatchSize) {
                        EventTab.pastMoreAvailable = false;
                      }
                      globalBloc.pastEventListCache.addAll(snapshot.documents);
                      print(snapshot.documents.length);

                      return snapshot.documents;
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
