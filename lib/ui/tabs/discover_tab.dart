import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:events_flutter/blocs/global_provider.dart';
import 'package:events_flutter/ui/tiles/society_tile_left.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class DiscoverTab extends StatelessWidget {
  static const int batchSize = 3;
  static bool moreAvailable = true;

  @override
  Widget build(BuildContext context) {
    GlobalBloc globalBloc = GlobalProvider.of(context);
    return PagewiseListView(
      pageSize: batchSize,
      pageFuture: (pageIndex) {
        return Future<List<DocumentSnapshot>>(() async {
          if (globalBloc.societyListCache.length <= pageIndex * batchSize) {
            if (!moreAvailable) return List<DocumentSnapshot>();
            print('fetching...');
            DocumentSnapshot last;
            if (globalBloc.societyListCache.length > 0)
              last = globalBloc.societyListCache.last;
            //fetch
            QuerySnapshot snapshot = await Firestore.instance
                .collection('societies')
                .orderBy('pos')
                .startAfter([last == null ? null : last['pos']])
                .limit(batchSize)
                .getDocuments();
            //store it to list
            if (snapshot.documents.length < batchSize) moreAvailable = false;
            globalBloc.societyListCache.addAll(snapshot.documents);
            print(snapshot.documents.length);
            return snapshot.documents;
          } else {
            print('from list');
            //show from stored list
            int end = pageIndex * batchSize + batchSize;
            if (globalBloc.societyListCache.length < end)
              end = globalBloc.societyListCache.length;
            return globalBloc.societyListCache
                .getRange(pageIndex * batchSize, end)
                .toList();
          }
        });
      },
      noItemsFoundBuilder: (context) {
        return Text("Its Empty In Here...");
      },
      itemBuilder: (context, entry, i) {
        return SocietyTileLeft(entry);
      },
    );
  }
}
