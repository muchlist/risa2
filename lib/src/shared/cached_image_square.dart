import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:risa2/src/config/pallatte.dart';

class CachedImageSquare extends StatelessWidget {
  final String urlPath;
  final double width;
  final double height;

  const CachedImageSquare(
      {required this.urlPath, this.width = 125.0, this.height = 125.0});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: urlPath,
      imageBuilder: (context, imageProvider) => ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          width: width,
          height: height,
          child: Image(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (BuildContext context, String url) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: <Color>[Colors.white, Pallete.background],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: <double>[0.0, 1.0]),
            borderRadius: BorderRadius.circular(5.0)),
      ),
      errorWidget: (BuildContext context, String url, _) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(5.0)),
        child: const Center(child: Icon(Icons.error)),
      ),
    );
  }
}
