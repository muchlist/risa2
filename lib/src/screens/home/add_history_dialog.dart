import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/filter_models/general_filter.dart';
import '../../api/json_models/request/history_req.dart';
import '../../api/json_models/response/general_list_resp.dart';
import '../../config/pallatte.dart';
import '../../providers/generals.dart';
import '../../providers/histories.dart';
import '../../utils/enums.dart';
import '../search/general_search_delegate.dart';

class ItemChoice {
  final int id;
  final String label;

  ItemChoice(this.id, this.label);
}

class CompleteStatusHistory {
  final enumStatus id;
  final String title;

  CompleteStatusHistory(this.id, this.title);
}

class AddHistoryDialog extends StatefulWidget {
  const AddHistoryDialog({
    Key? key,
  }) : super(key: key);

  @override
  _AddHistoryDialogState createState() => _AddHistoryDialogState();
}

class _AddHistoryDialogState extends State<AddHistoryDialog> {
  // pilihan chip kategory
  final listChoices = <ItemChoice>[
    ItemChoice(1, 'CCTV'),
    ItemChoice(2, 'PC'),
  ];

  // pilihan dropdown button status
  final listCompleteStatus = <CompleteStatusHistory>[
    CompleteStatusHistory(enumStatus.progress, "Progress"),
    CompleteStatusHistory(enumStatus.pending, "Pending"),
    CompleteStatusHistory(enumStatus.complete, "Complete"),
  ];

  var _selectedCategoryID = 0;
  var _selectedUnitID = "";
  var _selectedUnitName = "Pilih Perangkat"; // untuk tampilan saja
  var _selectedStatus =
      CompleteStatusHistory(enumStatus.progress, "Pilih Progress");

  final problemController = TextEditingController();
  final resolveNoteController = TextEditingController();

  var _isLoading = false;

  final _addHistoryFormkey = GlobalKey<FormState>();

  @override
  void dispose() {
    problemController.dispose();
    resolveNoteController.dispose();
    super.dispose();
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  void _addHistory() {
    if (_selectedUnitID.isEmpty) {
      Flushbar(
        message: "Harap memilih perangkat terlebih dahulu",
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red.withOpacity(0.7),
      )..show(context);
      return;
    }

    if (_addHistoryFormkey.currentState?.validate() ?? false) {
      setLoading(true);
      final problemText = problemController.text;
      final resolveText = resolveNoteController.text;

      final payload = HistoryRequest(
          id: "",
          parentID: _selectedUnitID,
          problem: problemText,
          problemResolve: resolveText,
          status: "None",
          tag: [],
          completeStatus: _selectedStatus.id.index);

      // * CALL Provider -----------------------------------------------------
      context.read<HistoryProvider>().addHistory(payload).then((value) {
        setLoading(false);
        if (value) {
          Navigator.of(context).pop();
          Flushbar(
            message: "Berhasil menambahkan history",
            duration: Duration(seconds: 3),
            backgroundColor: Theme.of(context).accentColor.withOpacity(0.7),
          )..show(context);
        }
      }).onError((error, _) {
        setLoading(false);
        if (error != null) {
          Flushbar(
            message: error.toString(),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.red.withOpacity(0.7),
          )..show(context);
        }
      });
    } else {
      debugPrint("Error :(");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
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
            const SizedBox(
              height: 40,
            ),
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
                      const SizedBox(
                        height: 8,
                      ),
                      // * Pilih kategori text ------------------------
                      const Text(
                        "Kategori :",
                        style: TextStyle(fontSize: 16),
                      ),
                      // * Chip choice
                      Wrap(
                        children: listChoices
                            .map((e) => ChoiceChip(
                                  label: Text(
                                    e.label,
                                    style: (_selectedCategoryID == e.id)
                                        ? TextStyle(color: Colors.white)
                                        : TextStyle(),
                                  ),
                                  selected: _selectedCategoryID == e.id,
                                  selectedColor: Theme.of(context).accentColor,
                                  // * Setstate ------------------------------
                                  onSelected: (_) => setState(() {
                                    _selectedCategoryID = e.id;
                                    context.read<GeneralProvider>().setFilter(
                                        FilterGeneral(category: e.label));
                                    context
                                        .read<GeneralProvider>()
                                        .findGeneral("");
                                  }),
                                ))
                            .toList(),
                        spacing: 5,
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      // * Pilih perangkat text ------------------------
                      const Text(
                        "Perangkat / Software :",
                        style: TextStyle(fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (_selectedCategoryID == 0) {
                            setState(() {
                              _selectedUnitName =
                                  "Harap memilih kategori terlebih dahulu";
                            });
                            return;
                          }
                          final searchResult =
                              await showSearch<GeneralMinResponse?>(
                            context: context,
                            delegate: GeneralSearchDelegate(),
                          );
                          if (searchResult != null) {
                            setState(() {
                              _selectedUnitName = searchResult.name;
                              _selectedUnitID = searchResult.id;
                            });
                          }
                        },
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          decoration:
                              BoxDecoration(color: Pallete.secondaryBackground),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedUnitName,
                                ),
                                Icon(CupertinoIcons.search),
                              ]),
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

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

                      const SizedBox(
                        height: 8,
                      ),

                      // * Status pekerjaan text ------------------------
                      const Text(
                        "Status pekerjaan",
                        style: TextStyle(fontSize: 16),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        height: 50,
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        decoration:
                            BoxDecoration(color: Pallete.secondaryBackground),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<CompleteStatusHistory>(
                            isExpanded: true,
                            hint: Text(_selectedStatus.title),
                            items: listCompleteStatus.map((status) {
                              return DropdownMenuItem<CompleteStatusHistory>(
                                value: status,
                                child: Text(status.title),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedStatus = value!;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      // * ResolveNote text ------------------------

                      (_selectedStatus.id == enumStatus.complete)
                          ? const Text(
                              "Resolve Note",
                              style: TextStyle(fontSize: 16),
                            )
                          : const SizedBox.shrink(),

                      (_selectedStatus.id == enumStatus.complete)
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
                                    _selectedStatus.id == enumStatus.complete) {
                                  return 'resolve note tidak boleh kosong';
                                }
                                return null;
                              },
                              controller: resolveNoteController,
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(
                        height: 20,
                      ),

                      // * Button ---------------------------
                      (_isLoading)
                          ? Center(child: const CircularProgressIndicator())
                          : GestureDetector(
                              onTap: _addHistory,
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
                                        text: "Tambah Log",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500))
                                  ])),
                                ),
                              ),
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
