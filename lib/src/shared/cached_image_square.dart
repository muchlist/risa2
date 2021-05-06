import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImageSquare extends StatelessWidget {
  final String urlPath;

  const CachedImageSquare({required this.urlPath});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: urlPath,
      imageBuilder: (context, imageProvider) => ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          width: 100,
          height: 100,
          child: Image(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => SizedBox(
          width: 100,
          height: 100,
          child: Center(child: CircularProgressIndicator())),
      errorWidget: (context, url, error) => SizedBox(
          width: 100, height: 100, child: Center(child: Icon(Icons.error))),
    );
  }
}
