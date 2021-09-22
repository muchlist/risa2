import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/api/json_models/response/checkp_resp.dart';
import '../../api/json_models/request/checkp_edit_req.dart';
import '../../config/pallatte.dart';
import '../../models/shift_chip_models.dart';
import '../../providers/checks_master.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';

/// Dropdown button tidak boleh null . harus di inisiasi value awalnya

class EditCheckMasterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Edit Master"),
      ),
      body: EditCheckMasterBody(),
    );
  }
}

class EditCheckMasterBody extends StatefulWidget {
  @override
  _EditCheckMasterBodyState createState() => _EditCheckMasterBodyState();
}

class _EditCheckMasterBodyState extends State<EditCheckMasterBody> {
  // chip shift
  final List<ItemShiftChoice> listChoices = getItemShiftChoice();
  List<int> _multiShiftSelected = <int>[];
  String _selectedLocation = "None";
  String _selectedType = "None";

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

  Future<bool?> _getConfirm(BuildContext context) {
    return showDialog<bool?>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Konfirmasi hapus"),
            content: const Text("Apakah yakin ingin menghapus check ini!"),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.secondary),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Tidak")),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Ya"))
            ],
          );
        });
  }

  void _editMasterCheck() {
    // validasi
    String errorMessage = "";
    final String title = titleController.text;
    if (title.isEmpty) {
      errorMessage = errorMessage + "judul tidak boleh kosong. ";
    }
    if (_selectedLocation.isEmpty) {
      errorMessage = errorMessage + "lokasi tidak boleh kosong. ";
    }
    if (_selectedType.isEmpty) {
      errorMessage = errorMessage + "tipe tidak boleh kosong. ";
    }
    if (errorMessage.isNotEmpty) {
      showToastWarning(context: context, message: errorMessage);
      return;
    }

    final CheckpDetailResponseData dataExisting =
        context.read<CheckMasterProvider>().checkDetail!;
    final CheckpEditRequest payload = CheckpEditRequest(
        filterTimestamp: dataExisting.updatedAt,
        name: title.toUpperCase(),
        location: _selectedLocation,
        note: noteController.text,
        shifts: _multiShiftSelected,
        type: _selectedType,
        tag: _getListTag(),
        tagExtra: <String>[]);

    // Call Provider
    Future<void>.delayed(
        Duration.zero,
        () => context
                .read<CheckMasterProvider>()
                .editCheckMaster(payload)
                .then((bool value) {
              if (value) {
                Navigator.of(context).pop();
                showToastSuccess(
                    context: context,
                    message: "Berhasil mengedit master check");
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
    // get option
    Future<void>.delayed(Duration.zero, () {
      context
          .read<CheckMasterProvider>()
          .findOptionCheckMaster()
          .onError((Object? error, _) {
        showToastError(context: context, message: error.toString());
        return;
      }).whenComplete(() {
        // get detail when option complete
        Future<void>.delayed(Duration.zero, () {
          context
              .read<CheckMasterProvider>()
              .getDetail()
              .then((CheckpDetailResponseData value) {
            // init value
            setState(() {
              _multiShiftSelected = value.shifts;

              _selectedLocation = value.location;
              _selectedType = value.type;

              titleController.text = value.name;
              noteController.text = value.note;
              tagController.text = value.tag.join(",");
            });
          }).onError((Object? error, _) {
            showToastError(context: context, message: error.toString());
          });
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Consumer ------------------------------------------------------
    return Consumer<CheckMasterProvider>(
        builder: (_, CheckMasterProvider data, __) {
      if (data.checkDetail == null) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
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
                    maxLines: 2,
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
                        value: (_selectedLocation.isNotEmpty)
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
                            _selectedLocation = value ?? "";
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
                        value:
                            (_selectedType.isNotEmpty) ? _selectedType : null,
                        items: data.checkOption.type.map((String tipe) {
                          return DropdownMenuItem<String>(
                            value: tipe,
                            child: Text(tipe),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedType = value ?? "";
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
                              selectedColor:
                                  Theme.of(context).colorScheme.secondary,
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
                    Stack(
                      children: <Widget>[
                        Center(
                          child: HomeLikeButton(
                              iconData: CupertinoIcons.add,
                              text: "Edit master check",
                              tapTap: _editMasterCheck),
                        ),
                        IconButton(
                            icon: const Icon(CupertinoIcons.trash),
                            onPressed: () async {
                              final bool? confirmDelete =
                                  await _getConfirm(context);
                              if (confirmDelete != null && confirmDelete) {
                                await context
                                    .read<CheckMasterProvider>()
                                    .removeCheckMaster()
                                    .then((bool value) {
                                  if (value) {
                                    Navigator.pop(context);
                                    showToastSuccess(
                                        context: context,
                                        message: "Berhasil menghapus check");
                                  }
                                }).onError((Object? error, _) {
                                  showToastError(
                                      context: context,
                                      message: error.toString());
                                });
                              }
                            }),
                      ],
                    ),

                  verticalSpaceMedium,
                ],
              )),
        );
      }
    });
  }
}
