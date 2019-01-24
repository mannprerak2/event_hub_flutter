import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Shopping App',
        home: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              leading: Icon(Icons.arrow_back),
              expandedHeight: 220.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Event'),
                collapseMode: CollapseMode.pin,
                background: Image.asset('images/lake.jpg', fit: BoxFit.cover),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                    color: Colors.white,
                    height: 100.0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.calendar_today, size: 50),
                          Padding(
                            padding: EdgeInsets.only(top: 30, left: 20),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Event Name',
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.none,
                                    fontFamily: "Times New Roman",
                                  ),
                                ),
                                Text(
                                  'Society Name',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.none,
                                    fontFamily: "Times New Roman",
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
                Container(
                    color: Colors.white,
                    height: 80.0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(Icons.star, size: 40, semanticLabel: 'Fav'),
                          Icon(Icons.desktop_windows, size: 40),
                          Icon(Icons.share, size: 40),
                          Icon(Icons.more, size: 40),
                        ],
                      ),
                    )),
                Container(
                    color: Colors.white,
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 10, top: 10),
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.thumb_up),
                                Text(
                                  '  43 people are going',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.none,
                                    fontFamily: "Times New Roman",
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.cloud_circle),
                                Text(
                                  '  Fri, 14 Jan at 10:00 to 13:00 IST',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.none,
                                    fontFamily: "Times New Roman",
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.pin_drop),
                                Text(
                                  '  B.R. Auditorium',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.none,
                                    fontFamily: "Times New Roman",
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.bookmark),
                                Text(
                                  '  Tickets Available',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.none,
                                    fontFamily: "Times New Roman",
                                  ),
                                ),
                              ],
                            )),
                      ],
                    )),
                Container(
                  color: Colors.white,
                  height: 150.0,
                  child: Text(
                    'Section 1',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                      fontFamily: "Times New Roman",
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  height: 150.0,
                  child: Text(
                    'Section 2',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                      fontFamily: "Times New Roman",
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  height: 150.0,
                  child: Text(
                    'Section 3',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                      fontFamily: "Times New Roman",
                    ),
                  ),
                ),
              ]),
            )
          ],
        ));
  }
}

void main() {
  runApp(MyApp());
}
