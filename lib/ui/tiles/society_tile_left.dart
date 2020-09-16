import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_flutter/blocs/global_provider.dart';
import 'package:events_flutter/ui/tabs/society_page.dart';
import 'package:events_flutter/ui/tiles/subscribe_button.dart';
import 'package:flutter/material.dart';

class SocietyTileLeft extends StatelessWidget {
  final Map<String, dynamic> snapshot;

  SocietyTileLeft(DocumentSnapshot snapshot, {Key key})
      : this.snapshot = snapshot.data(),
        super(key: key) {
    this.snapshot['id'] = snapshot.id;
  }
  SocietyTileLeft.fromMap(Map<String, dynamic> snapshot, {Key key})
      : this.snapshot = snapshot,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SocietyDetailPage(
                  snapshot['id'], GlobalProvider.of(context), snapshot)));
        },
        child: Card(
          elevation: 0.5,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 160,
                padding: EdgeInsets.all(5),
                child: CachedNetworkImage(
                  imageUrl: snapshot['image'],
                  fit: BoxFit.fitHeight,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            snapshot['name'],
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w600),
                          ),
                          SubscribeButton(snapshot, GlobalProvider.of(context))
                        ],
                      ),
                      Expanded(
                          child: Text(
                        snapshot['descp'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            snapshot['college'],
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green[800],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
