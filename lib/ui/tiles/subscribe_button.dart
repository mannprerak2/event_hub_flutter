import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:flutter/material.dart';

class SubscribeButton extends StatefulWidget {
  final Map<String, dynamic> snapshot;
  final GlobalBloc globalBloc;
  SubscribeButton(this.snapshot, this.globalBloc);

  @override
  _SubscribeButtonState createState() => _SubscribeButtonState();
}

class _SubscribeButtonState extends State<SubscribeButton> {
  bool marked;

  _SubscribeButtonState();

  @override
  void initState() {
    marked = false;
    () async {
      marked = await widget.globalBloc.sqlite.hasSub(widget.snapshot['id']);
      if (marked && this.mounted) setState(() {});
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        marked ? Icons.notifications : Icons.notifications_none,
        color: Colors.red[800],
      ),
      onPressed: () {
        //save this to sqlite here
        if (marked) {
          widget.globalBloc.sqlite
              .removeSub(widget.snapshot, widget.globalBloc);
          setState(() {
            marked = false;
            // invalidate the subscription eventlist here
            widget.globalBloc.lastFetch = 0;
            widget.globalBloc.subsEventListCache.clear();
          });
        } else {
          widget.globalBloc.sqlite.saveSub(widget.snapshot, widget.globalBloc);
          setState(() {
            marked = true;
          });
        }
      },
    );
  }
}
