import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:risa2/src/config/pallatte.dart';

class ImageViewer extends StatelessWidget {
  final String imgUrl;
  const ImageViewer({Key? key, required this.imgUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // APPBAR -----------------------------------------------------------
      appBar: AppBar(
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back)),
          automaticallyImplyLeading: false,
          elevation: 0,
          title: const Text("Image View")),
      body: PhotoView(
        imageProvider: NetworkImage(imgUrl),
        backgroundDecoration: const BoxDecoration(color: Pallete.background),
        initialScale: PhotoViewComputedScale.contained * 0.8,
        minScale: PhotoViewComputedScale.contained * 0.5,
        maxScale: PhotoViewComputedScale.contained * 1.5,
      ),
    );
  }
}
