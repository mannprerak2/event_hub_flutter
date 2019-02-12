import 'dart:async';

import 'package:events_flutter/blocs/global_provider.dart';
import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:events_flutter/states/main_states.dart';
import 'package:events_flutter/ui/tabs/discover_tab.dart';
import 'package:events_flutter/ui/tabs/event_tab.dart';
import 'package:events_flutter/ui/tabs/bookmark_tab.dart';
import 'package:events_flutter/ui/tabs/subs_tab.dart';
import 'ui/bottom_nav_bar.dart';

import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() {
    return new MainScreenState();
  }
}

class MainScreenState extends State<MainScreen> {
  PageController controller;
  StreamController<int> pageChangeStream;
  @override
  void initState() {
    controller = PageController();
    pageChangeStream = StreamController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EventHub"),
      ),
      bottomNavigationBar:
          BottomNavBar(controller.animateToPage, pageChangeStream.stream),
      body: PageView.builder(
        itemCount: 4,
        onPageChanged: (i) {
          pageChangeStream.add(i);
        },
        controller: controller,
        itemBuilder: (context, i) {
          switch (i) {
            case 0:
              return EventTab();
            case 1:
              return DiscoverTab();
            case 2:
              return SubsTab();
            case 3:
              return BookmarkTab();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    pageChangeStream.close();
    controller.dispose();
    super.dispose();
  }
}
