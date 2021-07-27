import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  void _generateCheck(bool isVirtual) {
    // Call Provider
    Future.delayed(
        Duration.zero,
        () => context
                .read<VendorCheckProvider>()
                .addVendorCheck(isVirtual)
                .then((value) {
              if (value) {
                Navigator.of(context).pop();
                showToastSuccess(
                    context: context, message: "Berhasil membuat check");
              }
            }).onError((error, _) {
              if (error != null) {
                showToastError(context: context, message: error.toString());
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    final height = screenHeight(context);
    var isPortrait = screenIsPortrait(context);

    return Container(
      height: (isPortrait) ? height * 0.35 : height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  children: [
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
                      "Pilih jenis pengecekan :",
                      style: TextStyle(fontSize: 16),
                    ),
                    verticalSpaceMedium,
                    // * Chip choice
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onLongPress: () => _generateCheck(true),
                          onTap: () => showToastWarning(
                              context: context,
                              message:
                                  "tahan lama tombol untuk membuat daftar cek !"),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: Pallete.green,
                                child: Icon(
                                  CupertinoIcons.waveform_circle_fill,
                                  color: Colors.white,
                                ),
                                radius: 30,
                              ),
                              verticalSpaceTiny,
                              Text("VIRTUAL"),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onLongPress: () => _generateCheck(false),
                          onTap: () => showToastWarning(
                              context: context,
                              message:
                                  "Tahan lama tombol untuk membuat daftar cek !"),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                child: Icon(CupertinoIcons.ant_circle_fill,
                                    color: Colors.white),
                                radius: 30,
                              ),
                              verticalSpaceTiny,
                              Text("FISIK"),
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
