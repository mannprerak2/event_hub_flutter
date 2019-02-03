import 'package:events_flutter/states/main_states.dart';
import 'package:flutter/material.dart';

import './../blocs/global_bloc.dart';
import './../blocs/global_provider.dart';

// using setstate here because this is a very trivial case
// and performance would be similar even with reactive programming
class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  GlobalBloc globalBloc;
  int currentItem = 0;
  @override
  Widget build(BuildContext context) {
    globalBloc = GlobalProvider.of(context);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
        currentIndex: currentItem,
        onTap: (i) {
          globalBloc.mainStateStreamController.add(TabState(i));
          setState(() {
            currentItem = i;
          });
        },
        items: [
          BottomNavigationBarItem(
              backgroundColor: Colors.blue,
              title: Text(
                "Events",
              ),
              icon: Icon(
                Icons.event,
              )),
          BottomNavigationBarItem(
              backgroundColor: Colors.blue,
              title: Text(
                "Discover",
              ),
              icon: Icon(
                Icons.explore,
              )),
          BottomNavigationBarItem(
              backgroundColor: Colors.blue,
              title: Text(
                "Subscription",
              ),
              icon: Icon(
                Icons.subscriptions,
              )),
          BottomNavigationBarItem(
              backgroundColor: Colors.blue,
              title: Text(
                "Saved",
              ),
              icon: Icon(
                Icons.bookmark,
              )),
        ]);
  }
}
