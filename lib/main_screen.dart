import 'package:events_flutter/blocs/global_provider.dart';
import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:events_flutter/resources/search_delegate.dart';
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
  @override
  void initState() {
    controller = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalBloc globalBloc = GlobalProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/eventhub.png'),
        title: Text("EventHub"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {},
          )
        ],
      ),
      bottomNavigationBar: BottomNavBar(controller.animateToPage,
          globalBloc.mainStateStreamController.stream),
      body: PageView.builder(
        itemCount: 4,
        onPageChanged: (i) {
          globalBloc.mainStateStreamController.add(TabState(i, false));
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
    controller.dispose();
    super.dispose();
  }
}
