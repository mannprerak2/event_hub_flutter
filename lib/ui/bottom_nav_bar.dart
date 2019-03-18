import 'package:events_flutter/states/main_states.dart';
import 'package:flutter/material.dart';

// using setstate here because this is a very trivial case
// and performance would be similar even with reactive programming
class BottomNavBar extends StatefulWidget {
  final Function animateTo;
  final Stream pageChangeStream; //data is int for page Index
  BottomNavBar(this.animateTo, this.pageChangeStream);
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentItem = 0;

  @override
  void initState() {
    widget.pageChangeStream.listen((snapshot) {
      if (snapshot != null) {
        setState(() {
          currentItem = (snapshot as TabState).tabIndex;
          if ((snapshot as TabState).animate) {
            widget.animateTo(currentItem,
                duration: Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn);
          }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentItem,
        onTap: (i) {
          setState(() {
            currentItem = i;
            widget.animateTo(i,
                duration: Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn);
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
                "Societies",
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
