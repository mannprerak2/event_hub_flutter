import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_flutter/blocs/global_provider.dart';
import 'package:events_flutter/ui/tabs/photo_page.dart';
import 'package:events_flutter/ui/tiles/bookmark_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:events_flutter/ui/tabs/event_page.dart';

class EventListTile extends StatefulWidget {
  final Map<String, dynamic> snapshot;

  EventListTile(DocumentSnapshot snapshot, {Key key})
      : this.snapshot = snapshot.data(),
        super(key: key) {
    this.snapshot['id'] = snapshot.id;
  }

  EventListTile.bookmark(Map<String, dynamic> snapshot, {Key key})
      : this.snapshot = snapshot,
        super(key: key);

  @override
  _EventListTileState createState() => _EventListTileState();
}

class _EventListTileState extends State<EventListTile> {
  final DateFormat formatter = DateFormat('MMM');
  bool eventImage = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EventDetailPage(
                widget.snapshot['id'], GlobalProvider.of(context))));
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
                          builder: (context) =>
                              PhotoPage(widget.snapshot['image'])));
                    },
                    child: Hero(
                      tag: widget.snapshot['image'],
                      child: Container(
                        width: 70,
                        height: 70,
                        child: CircleAvatar(
                          maxRadius: 10.0,
                          child: Text(''),
                          backgroundImage: eventImage
                              ? CachedNetworkImageProvider(
                                  widget.snapshot['image'])
                              : AssetImage('assets/false.png'),
                          onBackgroundImageError: (exception, stackTrace) {
                            setState(() {
                              eventImage = !eventImage;
                            });
                          },
                          backgroundColor: Colors.white,
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
                            widget.snapshot['name'],
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800]),
                          ),
                          Text(
                            widget.snapshot['location'],
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey),
                          ),
                          Text(
                            "${widget.snapshot['society']} \u25CF ${widget.snapshot['college']}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 12,
                            ),
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
                          widget.snapshot['date'].toDate().day.toString(),
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[800]),
                        ),
                        Text(
                          formatter
                              .format(widget.snapshot['date'].toDate())
                              .toUpperCase(),
                          style: TextStyle(color: Colors.green),
                        ),
                        BookmarkButton(
                            widget.snapshot, GlobalProvider.of(context))
                      ]),
                ],
              ),
            ),
          )),
    );
  }
}
