import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImageCircle extends StatelessWidget {
  final String urlPath;

  const CachedImageCircle({required this.urlPath});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: urlPath,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: imageProvider,
        radius: 25,
      ),
      placeholder: (context, url) => CircleAvatar(
        backgroundColor: Colors.transparent,
        child: CircularProgressIndicator(),
        radius: 25,
      ),
      errorWidget: (context, url, error) => CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(Icons.error),
        radius: 25,
      ),
    );
  }
}
