import 'package:events_flutter/blocs/global_provider.dart';
import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:events_flutter/models/main_states.dart';
import 'package:events_flutter/ui/tabs/discover_tab.dart';
import 'package:events_flutter/ui/tabs/event_tab.dart';
import 'package:events_flutter/ui/tabs/saved_tab.dart';
import 'package:events_flutter/ui/tabs/subs_tab.dart';
import 'ui/bottom_nav_bar.dart';

import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = GlobalProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("EventHub"),
      ),
      bottomNavigationBar: BottomNavBar(),
      body: StreamBuilder(
        initialData: TabState(0),
        stream: globalBloc.mainStateStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.data is TabState) {
            switch ((snapshot.data as TabState).tabIndex) {
              case 0:
                return EventTab();
              case 1:
                return DiscoverTab();
              case 2:
                return SubsTab();
              case 3:
                return SavedTab();
            }
          }
          return Container();
        },
      ),
    );
  }
}
