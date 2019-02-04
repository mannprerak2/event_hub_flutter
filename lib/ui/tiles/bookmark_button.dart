import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:flutter/material.dart';

class BookmarkButton extends StatefulWidget {
  final Map<String, dynamic> snapshot;
  final GlobalBloc globalBloc;
  BookmarkButton(this.snapshot, this.globalBloc);

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
      marked = await widget.globalBloc.sqlite.hasEvent(widget.snapshot['id']);
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
        if (marked) {
          widget.globalBloc.sqlite.removeEvent(widget.snapshot['id']);
          setState(() {
            marked = false;
          });
        } else {
          widget.globalBloc.sqlite.saveEvent(widget.snapshot);
          setState(() {
            marked = true;
          });
        }
      },
    );
  }
}
