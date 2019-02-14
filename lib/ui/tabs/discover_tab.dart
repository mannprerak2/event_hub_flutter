import 'package:events_flutter/ui/tiles/society_tile_left.dart';
import 'package:events_flutter/ui/tiles/society_tile_right.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class DiscoverTab extends StatelessWidget {
  static const int batchSize = 3;
  static bool moreAvailable = true;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, i) {
        Map<String, dynamic> snapshot = Map();
        snapshot['id'] = 'KASFNKSAKJSDNKAJSD'; //random string
        snapshot['name'] = "name";
        snapshot['image'] =
            "https://scontent.fdel7-1.fna.fbcdn.net/v/t1.0-9/45645078_2190851034464667_6509144927044108288_n.jpg?_nc_cat=101&_nc_ht=scontent.fdel7-1.fna&oh=5ae612363a04aa8b9a2f403e8772bf03&oe=5CEBE62D";
        snapshot['college'] = "college";
        snapshot['desc'] = "descripption............";

        
          return SocietyTileLeft.fromMap(snapshot);
      },
    );
  }
}
