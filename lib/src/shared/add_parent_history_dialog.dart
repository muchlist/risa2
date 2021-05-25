import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/json_models/request/history_req.dart';
import '../config/pallatte.dart';
import '../providers/histories.dart';
import '../utils/enums.dart';
import 'flushbar.dart';
import 'ui_helpers.dart';

class AddParentHistoryDialog extends StatefulWidget {
  final String parentID;
  final String parentName;

  const AddParentHistoryDialog(
      {Key? key, required this.parentID, required this.parentName})
      : super(key: key);

  @override
  _AddParentHistoryDialogState createState() => _AddParentHistoryDialogState();
}

class _AddParentHistoryDialogState extends State<AddParentHistoryDialog> {
  // Default value
  // var _selectedUnitName = widget.history.parentName; // untuk tampilan saja
  var _selectedSlider = 1.0;
  var _selectedLabel = "Progress";

  // Text controller
  final problemController = TextEditingController();
  final resolveNoteController = TextEditingController();

  // Form key
  final _addHistoryFormkey = GlobalKey<FormState>();

  void _addHistory() {
    if (_addHistoryFormkey.currentState?.validate() ?? false) {
      final problemText = problemController.text;
      final resolveText = resolveNoteController.text;

      final payload = HistoryRequest(
          id: "",
          parentID: widget.parentID,
          problem: problemText,
          problemResolve: resolveText,
          status: "None",
          tag: [],
          completeStatus: _selectedSlider.toInt());

      Future.delayed(Duration.zero, () {
        // * CALL Provider -----------------------------------------------------
        context
            .read<HistoryProvider>()
            .addHistory(payload, parentID: widget.parentID)
            .then((value) {
          if (value) {
            Navigator.of(context).pop();
            showToastSuccess(
                context: context, message: "Berhasil menambahkan history");
          }
        }).onError((error, _) {
          if (error != null) {
            showToastError(context: context, message: error.toString());
          }
        });
      });
    } else {
      debugPrint("Error :(");
    }
  }

  @override
  void dispose() {
    problemController.dispose();
    resolveNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeightPercentage(context, percentage: 0.95),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              height: 40,
              thickness: 5,
              color: Pallete.secondaryBackground,
              indent: 50,
              endIndent: 50,
            ),
            verticalSpaceSmall,
            Expanded(
                child: NotificationListener(
              onNotification: (OverscrollIndicatorNotification overScroll) {
                overScroll.disallowGlow();
                return false;
              },
              child: SingleChildScrollView(
                child: Form(
                  key: _addHistoryFormkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Menambahkan Incident",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),

                      verticalSpaceSmall,

                      // * Pilih perangkat text ------------------------
                      const Text(
                        "Perangkat / Software :",
                        style: TextStyle(fontSize: 16),
                      ),
                      Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        decoration:
                            BoxDecoration(color: Pallete.secondaryBackground),
                        child: Text(
                          widget.parentName,
                        ),
                      ),

                      verticalSpaceSmall,

                      // * Problem text ------------------------
                      const Text(
                        "Problem",
                        style: TextStyle(fontSize: 16),
                      ),

                      TextFormField(
                        textInputAction: TextInputAction.newline,
                        maxLines: 3,
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Pallete.secondaryBackground,
                            enabledBorder: InputBorder.none,
                            border: InputBorder.none),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'problem tidak boleh kosong';
                          }
                          return null;
                        },
                        controller: problemController,
                      ),

                      verticalSpaceSmall,

                      // * Status pekerjaan text ------------------------
                      Text(
                        "Status pekerjaan ($_selectedLabel)",
                        style: TextStyle(fontSize: 16),
                      ),
                      Slider(
                        min: 1,
                        max: 4,
                        divisions: 3,
                        value: _selectedSlider,
                        label: _selectedLabel,
                        onChanged: (value) {
                          setState(() {
                            _selectedSlider = value;
                            _selectedLabel = context
                                .read<HistoryProvider>()
                                .getLabelStatus(_selectedSlider);
                          });
                        },
                      ),

                      verticalSpaceSmall,

                      // * ResolveNote text ------------------------

                      (_selectedSlider == 4.0)
                          ? const Text(
                              "Resolve Note",
                              style: TextStyle(fontSize: 16),
                            )
                          : const SizedBox.shrink(),

                      (_selectedSlider == 4.0)
                          ? TextFormField(
                              textInputAction: TextInputAction.newline,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Pallete.secondaryBackground,
                                  enabledBorder: InputBorder.none,
                                  border: InputBorder.none),
                              validator: (text) {
                                if ((text == null || text.isEmpty) &&
                                    _selectedSlider == 4.0) {
                                  return 'resolve note tidak boleh kosong';
                                }
                                return null;
                              },
                              controller: resolveNoteController,
                            )
                          : const SizedBox.shrink(),
                      verticalSpaceRegular,
                      Consumer<HistoryProvider>(
                        builder: (_, data, __) {
                          return (data.state == ViewState.busy)
                              // * Button ---------------------------
                              ? Center(child: const CircularProgressIndicator())
                              : GestureDetector(
                                  onTap: _addHistory,
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).accentColor,
                                          borderRadius:
                                              BorderRadius.circular(24)),
                                      child:
                                          const Text.rich(TextSpan(children: [
                                        WidgetSpan(
                                            child: Icon(
                                          CupertinoIcons.add,
                                          size: 15,
                                          color: Colors.white,
                                        )),
                                        TextSpan(
                                            text: "Tambah Log",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500))
                                      ])),
                                    ),
                                  ),
                                );
                        },
                      ),

                      SizedBox(
                        height:
                            screenHeightPercentage(context, percentage: 0.4),
                      )
                    ],
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
