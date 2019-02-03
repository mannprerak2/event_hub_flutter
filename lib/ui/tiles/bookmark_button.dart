import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:events_flutter/blocs/global_provider.dart';
import 'package:flutter/material.dart';

class BookmarkButton extends StatefulWidget {
  final String id;
  final GlobalBloc globalBloc;
  BookmarkButton(this.id, this.globalBloc);

  @override
  _BookmarkButtonState createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  bool marked;

  _BookmarkButtonState();

  @override
  void initState() {
    marked = false;
    () async {
      marked = await widget.globalBloc.sqlite.hasEvent(widget.id);
      print('marked:' + marked.toString());
      if (this.mounted) setState(() {});
    }();
    super.initState();
  }

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
          globalBloc.sqlite.removeEvent(globalBloc.eventList.firstWhere((e) {
            return (e.documentID == widget.id);
          }));
          setState(() {
            marked = false;
          });
        } else {
          // globalBloc.sharedPrefs.addSavedEvent(widget.id, globalBloc);
          globalBloc.sqlite.saveEvent(globalBloc.eventList.firstWhere((e) {
            return (e.documentID == widget.id);
          }));
          setState(() {
            marked = true;
          });
        }
      },
    );
  }
}
