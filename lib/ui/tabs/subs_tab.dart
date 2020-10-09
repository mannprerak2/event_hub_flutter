import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:events_flutter/blocs/global_provider.dart';
import 'package:events_flutter/states/main_states.dart';
import 'package:events_flutter/ui/tabs/subs_societies_page.dart';
import 'package:events_flutter/ui/tiles/event_big_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:flare_flutter/flare_actor.dart';

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
            child: globalBloc.subsNameList.length == 0
                ? Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          height: 350,
                          width: 400,
                          child: FlareActor(
                            'assets/subscription.flr',
                            alignment: Alignment.center,
                            fit: BoxFit.contain,
                            animation: "nosubs",
                            // nosubs is an animation defination inside flare editor
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          'No society subscribed',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
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
                        onPressed: () {
                          //open subscribed societies here
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SubsSocietiesPage()));
                        },
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
                QuerySnapshot snapshot = await FirebaseFirestore.instance
                    .collection('events_mini')
                    .where('society', isEqualTo: lastFetchName)
                    .where('date',
                        isGreaterThan:
                            last == null ? DateTime.now() : last.get('date'))
                    .orderBy('date')
                    .limit(batchSize)
                    .get();

                //store it to list
                if (snapshot.docs.length < batchSize) globalBloc.lastFetch++;

                globalBloc.subsEventListCache.addAll(snapshot.docs);
                print(snapshot.docs.length);
                return snapshot.docs;
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
              return Center(
                  child: Text("No Upcoming Events from Subscriptions"));
            else {
              return Center(
                  child: RaisedButton(
                child: Text(
                  "View All Societies",
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  globalBloc.mainStateStreamController
                      .add(TabState(1, true)); // 1 is for discover tab
                },
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
