import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_flutter/ui/tiles/event_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MySearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // use the query method here and build results from firebase.
    final stream = FirebaseFirestore.instance
        .collection('events')
        .where('keywords', arrayContains: query.toLowerCase())
        .limit(5)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.length == 0) {
            return Center(child: Text("No results"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, i) {
              return EventListTile(snapshot.data!.docs[i]);
            },
          );
        }

        return Padding(
            padding: const EdgeInsets.all(10.0),
            child: SpinKitFadingCube(
              color: Theme.of(context).primaryColor,
              size: 50.0,
            ));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> suggestions = ['hackathon', 'fest', 'iosd'];
    return Container(
      padding: EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: suggestions.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            return Text('Currently only one word searches work, e.g ');
          }
          return Text(suggestions[i - 1]);
        },
      ),
    );
  }
}
