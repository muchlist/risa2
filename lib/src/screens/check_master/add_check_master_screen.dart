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
  final List<ItemShiftChoice> listChoices = getItemShiftChoice();
  final List<int> _multiShiftSelected = <int>[];

  String? _selectedLocation;
  String? _selectedType;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController tagController = TextEditingController();

  List<String> _getListTag() {
    if (tagController.text.isNotEmpty) {
      final List<String> tags = tagController.text.split(",");
      return tags.map((String e) => e.trim()).toList();
    }
    return <String>[];
  }

  void _addMasterCheck() {
    // validasi
    String errorMessage = "";
    final String title = titleController.text;
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
    final CheckpRequest payload = CheckpRequest(
        name: title.toUpperCase(),
        location: _selectedLocation!,
        note: noteController.text,
        shifts: _multiShiftSelected,
        type: _selectedType!,
        tag: _getListTag(),
        tagExtra: <String>[]);

    // Call Provider
    Future<void>.delayed(
        Duration.zero,
        () => context
                .read<CheckMasterProvider>()
                .addCheckMaster(payload)
                .then((bool value) {
              if (value) {
                Navigator.of(context).pop();
                showToastSuccess(
                    context: context, message: "Berhasil membuat master check");
              }
            }).onError((Object? error, _) {
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
    Future<void>.delayed(
        Duration.zero,
        () => context
                .read<CheckMasterProvider>()
                .findOptionCheckMaster()
                .onError((Object? error, _) {
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
          builder: (_, CheckMasterProvider data, __) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // * Judul text ------------------------
                const Text(
                  "Judul",
                  style: TextStyle(fontSize: 16),
                ),

                TextFormField(
                  textInputAction: TextInputAction.next,
                  minLines: 1,
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
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  decoration:
                      const BoxDecoration(color: Pallete.secondaryBackground),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text("Location"),
                      value: (_selectedLocation != null)
                          ? _selectedLocation
                          : null,
                      items: data.checkOption.location.map((String loc) {
                        return DropdownMenuItem<String>(
                          value: loc,
                          child: Text(loc),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedLocation = value;
                          FocusScope.of(context).requestFocus(FocusNode());
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
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  decoration:
                      const BoxDecoration(color: Pallete.secondaryBackground),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text("Tipe"),
                      value: (_selectedType != null) ? _selectedType : null,
                      items: data.checkOption.type.map((String tipe) {
                        return DropdownMenuItem<String>(
                          value: tipe,
                          child: Text(tipe),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedType = value;
                          FocusScope.of(context).requestFocus(FocusNode());
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
                  spacing: 10,
                  children: listChoices
                      .map((ItemShiftChoice e) => ChoiceChip(
                            label: Text(
                              e.label,
                              style: (_multiShiftSelected.contains(e.id))
                                  ? const TextStyle(color: Colors.white)
                                  : const TextStyle(),
                            ),
                            selected: _multiShiftSelected.contains(e.id),
                            selectedColor: Theme.of(context).accentColor,
                            // * Setstate ------------------------------
                            onSelected: (_) => setState(() {
                              if (_multiShiftSelected.contains(e.id)) {
                                _multiShiftSelected
                                    .removeWhere((int item) => item == e.id);
                              } else {
                                _multiShiftSelected.add(e.id);
                              }
                            }),
                          ))
                      .toList(),
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
                if (data.detailState == ViewState.busy)
                  const Center(child: CircularProgressIndicator())
                else
                  Center(
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
