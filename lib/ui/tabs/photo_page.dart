import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PhotoPage extends StatelessWidget {
  final String url;

  PhotoPage(this.url);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('a'),
      direction: DismissDirection.down,
      resizeDuration: null,
      background: Container(
        padding: EdgeInsets.only(top: 30.0),
        alignment: Alignment.topCenter,
        color: Colors.black,
        child: Text(
          'Drag down to dismiss',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              decoration: TextDecoration.none),
        ),
      ),
      onDismissed: (dir) {
        Navigator.of(context).pop();
      },
      child: Container(
        child: PhotoView(
          heroTag: url,
          imageProvider: CachedNetworkImageProvider(url),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered,
        ),
      ),
    );
  }
}
