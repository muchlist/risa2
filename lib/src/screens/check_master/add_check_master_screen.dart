import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../api/json_models/request/checkp_req.dart';
import '../../config/pallatte.dart';
import '../../models/shift_chip_models.dart';
import '../../providers/checks_master.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';

class AddCheckMasterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Tambah Master"),
      ),
      body: AddCheckMasterBody(),
    );
  }
}

class AddCheckMasterBody extends StatefulWidget {
  @override
  _AddCheckMasterBodyState createState() => _AddCheckMasterBodyState();
}

class _AddCheckMasterBodyState extends State<AddCheckMasterBody> {
  // pilihan chip
  final listChoices = getItemShiftChoice();
  List<int> _multiShiftSelected = [];

  String? _selectedLocation;
  String? _selectedType;

  final titleController = TextEditingController();
  final noteController = TextEditingController();
  final tagController = TextEditingController();

  List<String> _getListTag() {
    if (tagController.text.isNotEmpty) {
      final tags = tagController.text.split(",");
      return tags.map((e) => e.trim()).toList();
    }
    return [];
  }

  void _addMasterCheck() {
    // validasi
    var errorMessage = "";
    final title = titleController.text;
    if (title.isEmpty) {
      errorMessage = errorMessage + "judul tidak boleh kosong. ";
    }
    if (_selectedLocation == null) {
      errorMessage = errorMessage + "lokasi tidak boleh kosong. ";
    }
    if (_selectedType == null) {
      errorMessage = errorMessage + "tipe tidak boleh kosong. ";
    }
    if (errorMessage.isNotEmpty) {
      showToastWarning(context: context, message: errorMessage);
      return;
    }

    // Payload
    final payload = CheckpRequest(
        name: title.toUpperCase(),
        location: _selectedLocation!,
        note: noteController.text,
        shifts: _multiShiftSelected,
        type: _selectedType!,
        tag: _getListTag(),
        tagExtra: []);

    // Call Provider
    Future.delayed(
        Duration.zero,
        () => context
                .read<CheckMasterProvider>()
                .addCheckMaster(payload)
                .then((value) {
              if (value) {
                Navigator.of(context).pop();
                showToastSuccess(
                    context: context, message: "Berhasil membuat master check");
              }
            }).onError((error, _) {
              if (error != null) {
                showToastError(context: context, message: error.toString());
              }
            }));
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    tagController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(
        Duration.zero,
        () => context
                .read<CheckMasterProvider>()
                .findOptionCheckMaster()
                .onError((error, _) {
              showToastError(context: context, message: error.toString());
            }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        // Consumer ------------------------------------------------------
        child: Consumer<CheckMasterProvider>(
          builder: (_, data, __) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // * Judul text ------------------------
                const Text(
                  "Judul",
                  style: TextStyle(fontSize: 16),
                ),

                TextFormField(
                  textInputAction: TextInputAction.next,
                  minLines: 1,
                  maxLines: 1,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Pallete.secondaryBackground,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                  controller: titleController,
                ),

                verticalSpaceTiny,

                // * Lokasi dropdown ------------------------
                const Text(
                  "Lokasi",
                  style: TextStyle(fontSize: 16),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(color: Pallete.secondaryBackground),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Text("Location"),
                      value: (_selectedLocation != null)
                          ? _selectedLocation
                          : null,
                      items: data.checkOption.location.map((loc) {
                        return DropdownMenuItem<String>(
                          value: loc,
                          child: Text(loc),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLocation = value;
                        });
                      },
                    ),
                  ),
                ),

                verticalSpaceTiny,

                // * Tipe dropdown ------------------------
                const Text(
                  "Tipe",
                  style: TextStyle(fontSize: 16),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(color: Pallete.secondaryBackground),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Text("Tipe"),
                      value: (_selectedType != null) ? _selectedType : null,
                      items: data.checkOption.type.map((tipe) {
                        return DropdownMenuItem<String>(
                          value: tipe,
                          child: Text(tipe),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value;
                        });
                      },
                    ),
                  ),
                ),

                verticalSpaceTiny,

                // * Tipe dropdown ------------------------
                const Text(
                  "Shift",
                  style: TextStyle(fontSize: 16),
                ),
                Wrap(
                  children: listChoices
                      .map((e) => ChoiceChip(
                            label: Text(
                              e.label,
                              style: (_multiShiftSelected.contains(e.id))
                                  ? TextStyle(color: Colors.white)
                                  : TextStyle(),
                            ),
                            selected: (_multiShiftSelected.contains(e.id)),
                            selectedColor: Theme.of(context).accentColor,
                            // * Setstate ------------------------------
                            onSelected: (_) => setState(() {
                              if (_multiShiftSelected.contains(e.id)) {
                                _multiShiftSelected
                                    .removeWhere((item) => item == e.id);
                              } else {
                                _multiShiftSelected.add(e.id);
                              }
                            }),
                          ))
                      .toList(),
                  spacing: 10,
                ),

                verticalSpaceTiny,
                // * Catatan text ------------------------
                const Text(
                  "Catatan",
                  style: TextStyle(fontSize: 16),
                ),

                TextFormField(
                  textInputAction: TextInputAction.newline,
                  minLines: 2,
                  maxLines: 2,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Pallete.secondaryBackground,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                  controller: noteController,
                ),

                verticalSpaceTiny,
                // * Tag text ------------------------
                const Text(
                  "Master Tag (pisahkan dengan koma)",
                  style: TextStyle(fontSize: 16),
                ),

                TextFormField(
                  textInputAction: TextInputAction.next,
                  minLines: 2,
                  maxLines: 2,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Pallete.secondaryBackground,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                  controller: tagController,
                ),

                verticalSpaceMedium,
                (data.detailState == ViewState.busy)
                    ? Center(child: const CircularProgressIndicator())
                    : Center(
                        child: HomeLikeButton(
                            iconData: CupertinoIcons.add,
                            text: "Tambah master check",
                            tapTap: _addMasterCheck),
                      ),

                verticalSpaceMedium,
              ],
            );
          },
        ),
      ),
    );
  }
}
