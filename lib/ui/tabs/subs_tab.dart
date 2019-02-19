import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:events_flutter/blocs/global_provider.dart';
import 'package:events_flutter/ui/tiles/event_big_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class SubsTab extends StatelessWidget {
  static const int batchSize = 3;
  static bool moreAvailable = true;
  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = GlobalProvider.of(context);
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            height: 50,
            child: globalBloc.subsNameList.length == 0
                ? Center(
                    child: Text("No Society Subscribed"),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                          itemCount: globalBloc.subsNameList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.all(3),
                              child: Chip(
                                label: Text(
                                  globalBloc.subsNameList[i],
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.blueGrey,
                              ),
                            );
                          },
                        ),
                      ),
                      FlatButton(
                        child: Text(
                          "ALL",
                          textAlign: TextAlign.end,
                        ),
                        onPressed: () {},
                      )
                    ],
                  ),
          ),
        ),
        PagewiseSliverList(
          pageSize: batchSize,
          pageFuture: (pageIndex) {
            return Future<List<DocumentSnapshot>>(() async {
              print('in future');
              if (globalBloc.subsEventListCache.length <=
                  pageIndex * batchSize) {
                String lastFetchName;
                if (globalBloc.subsNameList.length > globalBloc.lastFetch)
                  lastFetchName = globalBloc.subsNameList[globalBloc.lastFetch];

                if (lastFetchName == null) {
                  return List<DocumentSnapshot>();
                }

                print('fetching...');

                DocumentSnapshot last;
                if (globalBloc.subsEventListCache.length > 0)
                  last = globalBloc.subsEventListCache.last;

                //fetch
                QuerySnapshot snapshot = await Firestore.instance
                    .collection('events')
                    .where('society', isEqualTo: lastFetchName)
                    .orderBy('date')
                    .startAfter([last == null ? null : last['date']])
                    .limit(batchSize)
                    .getDocuments();

                //store it to list
                if (snapshot.documents.length < batchSize)
                  globalBloc.lastFetch++;

                globalBloc.subsEventListCache.addAll(snapshot.documents);
                print(snapshot.documents.length);
                return snapshot.documents;
              } else {
                print('from list');
                //show from stored list
                int end = pageIndex * batchSize + batchSize;
                if (globalBloc.subsEventListCache.length < end)
                  end = globalBloc.subsEventListCache.length;
                return globalBloc.subsEventListCache
                    .getRange(pageIndex * batchSize, end)
                    .toList();
              }
            });
          },
          noItemsFoundBuilder: (context) {
            if (globalBloc.subsNameList.length > 0)
              return Center(child: Text("No Events From any Subscriptions"));
            else {
              return Center(
                  child: RaisedButton(
                child: Text("View All Societies"),
                onPressed: () {},
              ));
            }
          },
          itemBuilder: (context, entry, i) {
            return Container(
              height: 250,
              child: EventBigTile(entry),
            );
          },
        ),
      ],
    );
  }
}
