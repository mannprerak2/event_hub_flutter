import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:events_flutter/blocs/global_provider.dart';
import 'package:events_flutter/ui/tiles/society_tile_left.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
            QuerySnapshot snapshot = await FirebaseFirestore.instance
                .collection('societies')
                .orderBy('pos')
                .startAfter([last == null ? null : last.get('pos')])
                .limit(batchSize)
                .get();
            //store it to list
            if (snapshot.docs.length < batchSize) moreAvailable = false;
            globalBloc.societyListCache.addAll(snapshot.docs);
            print(snapshot.docs.length);
            return snapshot.docs;
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
      loadingBuilder: (context) {
        return SpinKitFadingCube(
          color: Theme.of(context).primaryColor,
          size: 40.0,
        );
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
