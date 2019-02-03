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
      if (marked && this.mounted) setState(() {});
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
        //save this to sqlite here
        GlobalBloc globalBloc = GlobalProvider.of(context);
        if (marked) {
          globalBloc.sqlite.removeEvent(globalBloc.eventListCache.firstWhere((e) {
            return (e.documentID == widget.id);
          }));
          setState(() {
            marked = false;
          });
        } else {
          globalBloc.sqlite.saveEvent(globalBloc.eventListCache.firstWhere((e) {
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
