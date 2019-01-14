import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventListTile extends StatelessWidget {
  final String name, desc, url;
  final DateTime date;
  final int going;

  DateFormat formatter = DateFormat('MMM');

  EventListTile(
      {Key key, this.name, this.desc, this.date, this.going, this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        margin: EdgeInsets.fromLTRB(5, 2, 5, 2),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.network(
                url,
                fit: BoxFit.fill,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      Expanded(
                        child: Text(
                          desc,
                          maxLines: 2,
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                      ),
                      Text(
                        "$going people going",
                        maxLines: 2,
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontWeight: FontWeight.w200),
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
        ));
  }
}
