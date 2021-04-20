import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

Future<File> compressFile(File file) async {
  final tempDir = await getTemporaryDirectory();
  final tempPath = tempDir.path;

  final tempTargetPath = tempPath + file.path.split('/').last;
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    tempTargetPath,
    quality: 70,
    // rotate: 180,
  );
  if (result == null) {
    // gagal di kompress
    return file;
  }
  return result;
}
