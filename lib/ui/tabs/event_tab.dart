import 'package:events_flutter/ui/tiles/event_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class EventTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemExtent: 120,
      itemCount: 5,
      padding: EdgeInsets.fromLTRB(3, 10, 3, 10),
      itemBuilder: (context, i) {
        return EventListTile(
          name: "Name",
          desc: "Some random description",
          date: DateTime.now(),
          going: i,
          url: "https://pbs.twimg.com/profile_images/1011171409471524864/vDjaHTj8_400x400.jpg",
        );
      },
    );
  }
}

