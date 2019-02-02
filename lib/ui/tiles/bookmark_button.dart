import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:events_flutter/blocs/global_provider.dart';
import 'package:flutter/material.dart';

class BookmarkButton extends StatefulWidget {
  final String id;
  final bool marked;
  BookmarkButton(this.id, this.marked);

  @override
  _BookmarkButtonState createState() => _BookmarkButtonState(marked);
}

class _BookmarkButtonState extends State<BookmarkButton> {
  bool marked;

  _BookmarkButtonState(this.marked);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        marked ? Icons.bookmark : Icons.bookmark_border,
        color: Colors.yellow[800],
      ),
      onPressed: () {
        //save this to sharedpref and sqlite here
        GlobalBloc globalBloc = GlobalProvider.of(context);
        if (marked) {
          // globalBloc.sharedPrefs.removeSavedEvent(widget.id, globalBloc);
          if (globalBloc.savedEvents.contains(widget.id)) {
            globalBloc.savedEvents.remove(widget.id);
            globalBloc.sqlite.removeEvent(globalBloc.eventList.firstWhere((e) {
              return (e.documentID == widget.id);
            }));
            setState(() {
              marked = false;
            });
          }
        } else {
          // globalBloc.sharedPrefs.addSavedEvent(widget.id, globalBloc);
          if (!globalBloc.savedEvents.contains(widget.id)) {
            globalBloc.savedEvents.add(widget.id);
            globalBloc.sqlite.saveEvent(globalBloc.eventList.firstWhere((e) {
              return (e.documentID == widget.id);
            }));
            setState(() {
              marked = true;
            });
          }
        }
      },
    );
  }
}
