import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventListTile extends StatelessWidget {
  final String name, url;
  final DateTime date;

  final DateFormat formatter = DateFormat('MMM');

  EventListTile(
      {Key key, this.name, this.date, this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        margin: EdgeInsets.fromLTRB(5, 2, 5, 2),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(url),
                        fit: BoxFit.cover),
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
                          name,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        formatter.format(date).toUpperCase(),
                        style: TextStyle(color: Colors.green),
                      )
                    ]),
              ],
            ),
          ),
        ));
  }
}
