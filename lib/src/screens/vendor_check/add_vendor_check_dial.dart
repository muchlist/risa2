import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/providers/altai_virtual.dart';

import '../../config/pallatte.dart';
import '../../providers/vendor_check.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/ui_helpers.dart';

class AddVendorCheckDialog extends StatefulWidget {
  const AddVendorCheckDialog();

  @override
  _AddVendorCheckDialogState createState() => _AddVendorCheckDialogState();
}

class _AddVendorCheckDialogState extends State<AddVendorCheckDialog> {
  void _generateCheckCctv() {
    // Call Provider
    Future<void>.delayed(
        Duration.zero,
        () => context
                .read<VendorCheckProvider>()
                .addVendorCheck(false)
                .then((bool value) {
              if (value) {
                Navigator.of(context).pop();
                showToastSuccess(
                    context: context, message: "Berhasil membuat check cctv");
              }
            }).onError((Object? error, _) {
              if (error != null) {
                showToastError(context: context, message: error.toString());
              }
            }));
  }

  void _generateCheckAltai() {
    // Call Provider
    Future<void>.delayed(
        Duration.zero,
        () => context
                .read<AltaiVirtualProvider>()
                .addAltaiVirtual()
                .then((bool value) {
              if (value) {
                Navigator.of(context).pop();
                showToastSuccess(
                    context: context, message: "Berhasil membuat check altai");
              }
            }).onError((Object? error, _) {
              if (error != null) {
                showToastError(context: context, message: error.toString());
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    final double height = screenHeight(context);
    final bool isPortrait = screenIsPortrait(context);

    return SizedBox(
      height: isPortrait ? height * 0.35 : height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Divider(
              indent: 70,
              endIndent: 70,
              height: 10,
              thickness: 5,
              color: Pallete.secondaryBackground,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      "Membuat data checklist",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    // * Pilih kategori text ------------------------
                    const Text(
                      "Tahan tombol untuk memilih jenis pengecekan :",
                      style: TextStyle(fontSize: 16),
                    ),
                    verticalSpaceMedium,
                    // * Chip choice
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          onLongPress: () => _generateCheckCctv(),
                          child: Column(
                            children: const <Widget>[
                              CircleAvatar(
                                backgroundColor: Pallete.green,
                                radius: 30,
                                child: Icon(
                                  CupertinoIcons.waveform_circle_fill,
                                  color: Colors.white,
                                ),
                              ),
                              verticalSpaceTiny,
                              Text("CCTV"),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onLongPress: () => _generateCheckAltai(),
                          child: Column(
                            children: const <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                radius: 30,
                                child: Icon(CupertinoIcons.ant_circle_fill,
                                    color: Colors.white),
                              ),
                              verticalSpaceTiny,
                              Text("ALTAI"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    verticalSpaceLarge,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
