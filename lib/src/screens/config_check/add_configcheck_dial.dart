import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/shared/home_like_button.dart';

import '../../config/pallatte.dart';
import '../../providers/config_check.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/ui_helpers.dart';

class AddConfigCheckDialog extends StatefulWidget {
  const AddConfigCheckDialog();

  @override
  _AddConfigCheckDialogState createState() => _AddConfigCheckDialogState();
}

class _AddConfigCheckDialogState extends State<AddConfigCheckDialog> {
  void _generateConfigCheck() {
    // Call Provider
    Future<void>.delayed(
        Duration.zero,
        () => context
                .read<ConfigCheckProvider>()
                .addConfigCheck()
                .then((bool value) {
              if (value) {
                Navigator.of(context).pop();
                showToastSuccess(
                    context: context, message: "check config ditambahkan");
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
                      "Menambahkan cek backup config",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    // * Pilih kategori text ------------------------
                    const Text(
                      "Config perangkat network dibackup otomatis kedalam google drive menjelang akhir bulan, namun vendor harus memastikan file backup sudah tergenerate melalui form check ini.",
                      style: TextStyle(fontSize: 14),
                    ),
                    verticalSpaceMedium,
                    Center(
                      child: HomeLikeButton(
                          iconData: Icons.fiber_new_sharp,
                          text: "Buat daftar pengecekan",
                          tapTap: _generateConfigCheck),
                    ),
                    // * Chip choice
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
