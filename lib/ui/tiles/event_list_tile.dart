import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_flutter/blocs/global_provider.dart';
import 'package:events_flutter/ui/tabs/photo_page.dart';
import 'package:events_flutter/ui/tiles/bookmark_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:events_flutter/ui/tabs/event_page.dart';

class EventListTile extends StatelessWidget {
  final Map<String, dynamic> snapshot;
  final DateFormat formatter = DateFormat('MMM');

  EventListTile(DocumentSnapshot snapshot, {Key key})
      : this.snapshot = snapshot.data,
        super(key: key) {
    this.snapshot['id'] = snapshot.documentID;
  }

  EventListTile.bookmark(Map<String, dynamic> snapshot, {Key key})
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
          elevation: 0.5,
          margin: EdgeInsets.fromLTRB(5, 2, 5, 2),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PhotoPage(snapshot['image'])));
                    },
                    child: Hero(
                      tag: snapshot['image'],
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image:
                                  CachedNetworkImageProvider(snapshot['image']),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            snapshot['name'],
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800]),
                          ),
                          Text(
                            snapshot['location'],
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey),
                          ),
                          Text(
                            "${snapshot['society']} \u25CF ${snapshot['college']}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(color: Colors.blueGrey),
                          )
                        ],
                      ),
                    ),
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          snapshot['date'].day.toString(),
                          style:
                              TextStyle(fontSize: 28, color: Colors.grey[800]),
                        ),
                        Text(
                          formatter.format(snapshot['date']).toUpperCase(),
                          style: TextStyle(color: Colors.green),
                        ),
                        BookmarkButton(snapshot, GlobalProvider.of(context))
                      ]),
                ],
              ),
            ),
          )),
    );
  }
}
