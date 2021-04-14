import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/request/check_req.dart';
import '../../config/pallatte.dart';
import '../../providers/checks.dart';
import '../../shared/flushbar.dart';
import '../../shared/ui_helpers.dart';

class ItemChoice {
  final int id;
  final String label;

  ItemChoice(this.id, this.label);
}

class AddCheckDialog extends StatefulWidget {
  const AddCheckDialog();

  @override
  _AddCheckDialogState createState() => _AddCheckDialogState();
}

class _AddCheckDialogState extends State<AddCheckDialog> {
  // pilihan chip kategory
  final listChoices = <ItemChoice>[
    ItemChoice(1, 'Shift 1'),
    ItemChoice(2, 'Shift 2'),
    ItemChoice(3, 'Shift 3'),
  ];

  var _shiftSelected = 0;

  var _isLoading = false;
  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  void _addCheck() {
    // validasi shift
    if (_shiftSelected == 0) {
      showToastWarning(
          context: context, message: "Harap memilih shift terlebih dahulu");
      return;
    }

    final payload = CheckRequest(shift: _shiftSelected);
    context.read<CheckProvider>().addCheck(payload).then((value) {
      setLoading(false);
      if (value) {
        Navigator.of(context).pop();
        showToastSuccess(context: context, message: "Berhasil membuat check");
      }
    }).onError((error, _) {
      setLoading(false);
      if (error != null) {
        showToastError(context: context, message: error.toString());
      }
    });
    // * CALL Provider -----------------------------------------------------
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
                    const SizedBox(
                      height: 8,
                    ),
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

                    const SizedBox(
                      height: 30,
                    ),
                    // * Button ---------------------------
                    (_isLoading)
                        ? Center(child: const CircularProgressIndicator())
                        : GestureDetector(
                            onTap: _addCheck,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).accentColor,
                                    borderRadius: BorderRadius.circular(24)),
                                child: const Text.rich(TextSpan(children: [
                                  WidgetSpan(
                                      child: Icon(
                                    CupertinoIcons.add,
                                    size: 15,
                                    color: Colors.white,
                                  )),
                                  TextSpan(
                                      text: "Generate Check",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500))
                                ])),
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 20,
                    )
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
