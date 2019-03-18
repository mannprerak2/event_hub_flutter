import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_flutter/blocs/global_provider.dart';
import 'package:events_flutter/ui/tabs/event_page.dart';
import 'package:events_flutter/ui/tiles/bookmark_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//to be used inside a container because this tile has no height contraint
class EventBigTile extends StatelessWidget {
  final Map<String, dynamic> snapshot;
  final DateFormat formatter = DateFormat('MMM');

  EventBigTile(DocumentSnapshot snapshot, {Key key})
      : this.snapshot = snapshot.data,
        super(key: key) {
    this.snapshot['id'] = snapshot.documentID;
  }

  EventBigTile.fromMap(Map<String, dynamic> snapshot, {Key key})
      : this.snapshot = snapshot,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                EventDetailPage(snapshot['id'], GlobalProvider.of(context))));
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        elevation: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: CachedNetworkImage(
                imageUrl: snapshot['image'],
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          snapshot['name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800]),
                        ),
                        Text(
                          "${snapshot['society']} \u25CF ${snapshot['location']} \u25CF ${snapshot['college']}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                  BookmarkButton(snapshot, GlobalProvider.of(context)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          snapshot['date'].toDate().day.toString(),
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[800]),
                        ),
                        Text(
                          formatter.format(snapshot['date'].toDate()).toUpperCase(),
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
