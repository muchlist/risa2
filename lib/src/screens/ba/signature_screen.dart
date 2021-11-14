import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/providers/ba_provider.dart';
import 'package:risa2/src/shared/func_flushbar.dart';
import 'package:risa2/src/shared/home_like_button.dart';
import 'package:risa2/src/shared/ui_helpers.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({Key? key}) : super(key: key);

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

  void _handleClearButtonPressed() {
    _signaturePadKey.currentState!.clear();
  }

  Future<void> _handleSaveButtonPressed(String id) async {
    final ui.Image data =
        await _signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
    final ByteData? bytes =
        await data.toByteData(format: ui.ImageByteFormat.png);
    final String tempPath = (await getTemporaryDirectory()).path;
    final File file = File('$tempPath/profile.png');
    await file.writeAsBytes(
        bytes!.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

    await context.read<BaProvider>().signWithImage(id, file).then((bool value) {
      if (value) {
        Navigator.of(context).pop();
        showToastSuccess(
            context: context, message: "Berhasil menandatangani dokumen");
      }
    }).onError((Object? error, _) {
      showToastError(context: context, message: error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final BaProvider baProvider = context.watch<BaProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        title: const Text("BERITA ACARA"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Silakan tanda tangan didalam kotak putih"),
            verticalSpaceSmall,
            Stack(
              children: <Widget>[
                SizedBox(
                  height: 200,
                  width: 300,
                  child: SfSignaturePad(
                    key: _signaturePadKey,
                    minimumStrokeWidth: 1,
                    maximumStrokeWidth: 3,
                    strokeColor: Colors.black,
                    backgroundColor: Colors.white,
                  ),
                ),
                Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      icon: const Icon(CupertinoIcons.clear_circled),
                      onPressed: _handleClearButtonPressed,
                    ))
              ],
            ),
            verticalSpaceSmall,
            Center(
              child: HomeLikeButton(
                  text: "Tandatangani",
                  iconData: CupertinoIcons.qrcode,
                  tapTap: () => () {
                        _handleSaveButtonPressed(baProvider.baDetail.id);
                      }),
            ),
          ],
        ),
      ),
    );
  }
}
