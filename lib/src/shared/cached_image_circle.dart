import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImageCircle extends StatelessWidget {
  const CachedImageCircle({required this.urlPath});
  final String urlPath;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: urlPath,
      imageBuilder:
          (BuildContext context, ImageProvider<Object> imageProvider) =>
              CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: imageProvider,
        radius: 25,
      ),
      placeholder: (BuildContext context, String url) => const CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 25,
        child: CircularProgressIndicator(),
      ),
      errorWidget: (BuildContext context, String url, _) => const CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 25,
        child: Icon(Icons.error),
      ),
    );
  }
}
