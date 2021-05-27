import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImageSquare extends StatelessWidget {
  final String urlPath;
  final double width;
  final double height;

  const CachedImageSquare(
      {required this.urlPath, this.width = 100.0, this.height = 100.0});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: urlPath,
      imageBuilder: (context, imageProvider) => ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          width: width,
          height: height,
          child: Image(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => SizedBox(
          width: width,
          height: height,
          child: Center(child: CircularProgressIndicator())),
      errorWidget: (context, url, error) => SizedBox(
          width: width,
          height: height,
          child: Center(child: Icon(Icons.error))),
    );
  }
}
