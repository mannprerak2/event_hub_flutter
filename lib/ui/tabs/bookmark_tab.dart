import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import '../../blocs/global_provider.dart';
import '../../blocs/global_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:events_flutter/ui/tiles/event_list_tile.dart';

class BookmarkTab extends StatelessWidget {
  static const int batchSize = 8;
  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = GlobalProvider.of(context);
    return kIsWeb
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                iconSize: 50,
                icon: Icon(
                  Icons.bookmark_border_sharp,
                  color: Colors.red,
                ),
                onPressed: () {
                  // Do nothing, just for effect.
                },
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Bookmarks are not available on web",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          )
        : PagewiseListView(
            padding: EdgeInsets.all(8.0),
            pageSize: batchSize,
            pageFuture: (pageIndex) {
              return Future<List<Map<String, dynamic>>>(() async {
                print('db fetch...');
                //fetch
                List<Map<String, dynamic>> documents = await globalBloc.sqlite
                    .getSavedEvents(batchSize, pageIndex);

                return documents;
              });
            },
            noItemsFoundBuilder: (context) {
              return Column(
                children: <Widget>[
                  Text(
                    "No Bookmarks",
                    style: TextStyle(
                      fontSize: 26.0,
                    ),
                  ),
                  Divider(),
                  Text("\nClick on"),
                  Icon(
                    Icons.bookmark_border,
                    color: Colors.yellow[800],
                  ),
                  Text("to bookmark events")
                ],
              );
            },
            itemBuilder: (context, entry, i) {
              return EventListTile.bookmark(entry);
            },
          );
  }
}
