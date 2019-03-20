import 'package:events_flutter/blocs/global_provider.dart';
import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:events_flutter/states/main_states.dart';
import 'package:events_flutter/ui/tabs/discover_tab.dart';
import 'package:events_flutter/ui/tabs/event_tab.dart';
import 'package:events_flutter/ui/tabs/bookmark_tab.dart';
import 'package:events_flutter/ui/tabs/subs_tab.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
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
        leading: Image.asset('assets/eventhub-logo2.png', scale: 8,),
        title: Text("EventHub"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              showAboutDialog(
                  context: context,
                  applicationVersion: "1.0",
                  applicationIcon: Card(
                      color: Colors.red[800],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/eventhub-logo2.png', scale: 8,),
                      )),
                  applicationName: 'EventHub',
                  children: [
                    Linkify(
                      text: '''
Designed and Developed by Prerak Mann https://github.com/mannprerak2
\n
Events Data and Scraping by Saurabh Mittal https://github.com/saurabhmittal16
''',
                      humanize: true,
                      onOpen: (link) async {
                        if (await canLaunch(link.url)) {
                          await launch(link.url);
                        }
                      },
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            IconButton(
                              iconSize: 40,
                              color: Colors.blue[800],
                              icon: Icon(Icons.share),
                              onPressed: () {},
                            ),
                            Text('Share App')
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            IconButton(
                              iconSize: 40,
                              color: Colors.yellow[800],
                              icon: Icon(Icons.star),
                              onPressed: () {},
                            ),
                            Text('Rate Us')
                          ],
                        )
                      ],
                    )
                  ]);
            },
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
