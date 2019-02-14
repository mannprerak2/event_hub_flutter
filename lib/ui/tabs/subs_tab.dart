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
            child: globalBloc.subsIdList.length == 0
                ? Center(
                    child: Text("No subscriptions"),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                          itemCount: globalBloc.subsIdList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.all(3),
                              child: Chip(
                                label: Text(globalBloc.subsIdList[i]),
                              ),
                            );
                          },
                        ),
                      ),
                      FlatButton(
                        child: Text(
                          "ALL",
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
              if (globalBloc.subEventListCache.length <=
                  pageIndex * batchSize) {
                if (!moreAvailable) return List<DocumentSnapshot>();
                print('fetching...');
                DocumentSnapshot last;
                if (globalBloc.subEventListCache.length > 0)
                  last = globalBloc.subEventListCache.last;
                //fetch
                QuerySnapshot snapshot = await Firestore.instance
                    .collection('events')
                    .where('location', isEqualTo: 'DTU')
                    .limit(batchSize)
                    .getDocuments();
                moreAvailable = false;
                //store it to list
                if (snapshot.documents.length < batchSize)
                  moreAvailable = false;
                globalBloc.subEventListCache.addAll(snapshot.documents);
                print(snapshot.documents.length);
                return snapshot.documents;
              } else {
                print('from list');
                //show from stored list
                int end = pageIndex * batchSize + batchSize;
                if (globalBloc.subEventListCache.length < end)
                  end = globalBloc.subEventListCache.length;
                return globalBloc.subEventListCache
                    .getRange(pageIndex * batchSize, end)
                    .toList();
              }
            });
          },
          noItemsFoundBuilder: (context) {
            return Text("Its Empty In Here...");
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
