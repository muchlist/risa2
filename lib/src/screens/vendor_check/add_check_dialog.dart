import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/request/check_req.dart';
import '../../config/pallatte.dart';
import '../../models/shift_chip_models.dart';
import '../../providers/checks.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';

class AddVendorCheckDialog extends StatefulWidget {
  const AddVendorCheckDialog();

  @override
  _AddVendorCheckDialogState createState() => _AddVendorCheckDialogState();
}

class _AddVendorCheckDialogState extends State<AddVendorCheckDialog> {
  // pilihan chip kategory
  final listChoices = getItemShiftChoice();

  var _shiftSelected = 0;

  void _addCheck() {
    // validasi shift
    if (_shiftSelected == 0) {
      showToastWarning(
          context: context, message: "Harap memilih shift terlebih dahulu");
      return;
    }

    final payload = CheckRequest(shift: _shiftSelected);
    // Call Provider
    Future.delayed(
        Duration.zero,
        () => context.read<CheckProvider>().addCheck(payload).then((value) {
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
        padding: EdgeInsets.symmetric(horizontal: 16),
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
                      "Pilih shift :",
                      style: TextStyle(fontSize: 16),
                    ),
                    verticalSpaceSmall,
                    // * Chip choice
                    Wrap(
                      children: listChoices
                          .map((e) => ChoiceChip(
                                label: Text(
                                  e.label,
                                  style: (_shiftSelected == e.id)
                                      ? TextStyle(
                                          color: Colors.white, fontSize: 20)
                                      : TextStyle(),
                                ),
                                selected: _shiftSelected == e.id,
                                selectedColor: Theme.of(context).accentColor,
                                // * Setstate ------------------------------
                                onSelected: (_) => setState(() {
                                  _shiftSelected = e.id;
                                }),
                              ))
                          .toList(),
                      spacing: 10,
                    ),

                    verticalSpaceMedium,
                    // * Button ---------------------------
                    Consumer<CheckProvider>(builder: (_, data, __) {
                      if (data.state == ViewState.busy) {
                        return Center(child: const CircularProgressIndicator());
                      }
                      return Center(
                        child: HomeLikeButton(
                            iconData: CupertinoIcons.add,
                            text: "Generate Check",
                            tapTap: () {} //_addCheck,
                            ),
                      );
                    }),
                    verticalSpaceMedium,
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
