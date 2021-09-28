import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../api/filter_models/general_filter.dart';
import '../../api/json_models/request/history_req.dart';
import '../../api/json_models/response/general_list_resp.dart';
import '../../config/constant.dart';
import '../../config/pallatte.dart';
import '../../providers/generals.dart';
import '../../providers/histories.dart';
import '../../shared/cached_image_square.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';
import '../search/general_search_delegate.dart';

class ItemChoice {
  final int id;
  final String label;

  ItemChoice(this.id, this.label);
}

class AddHistoryVDialog extends StatefulWidget {
  const AddHistoryVDialog({
    Key? key,
  }) : super(key: key);

  @override
  _AddHistoryVDialogState createState() => _AddHistoryVDialogState();
}

class _AddHistoryVDialogState extends State<AddHistoryVDialog> {
  // pilihan chip kategory
  final listChoices = <ItemChoice>[
    ItemChoice(1, 'CCTV'),
    ItemChoice(7, 'ALTAI'),
    ItemChoice(11, 'OTHER-V'),
  ];

  // Default value
  var _selectedCategoryID = 0;
  var _selectedUnitID = "";
  var _selectedUnitName = "Pilih Perangkat"; // untuk tampilan saja
  var _selectedSlider = 1.0;
  var _selectedLabel = "Progress";

  // image
  String _imagePath = "";
  File? _image;
  final picker = ImagePicker();

  // Text controller
  final problemController = TextEditingController();
  final resolveNoteController = TextEditingController();

  // Form key
  final _addHistoryFormkey = GlobalKey<FormState>();

  void _addHistory() {
    if (_selectedUnitID.isEmpty) {
      showToastWarning(
          context: context, message: "Harap memilih perangkat terlebih dahulu");

      return;
    }

    if (_addHistoryFormkey.currentState?.validate() ?? false) {
      final problemText = problemController.text;
      final resolveText = resolveNoteController.text;

      final payload = HistoryRequest(
        id: "",
        parentID: _selectedUnitID,
        problem: problemText,
        problemResolve: resolveText,
        status: "None",
        tag: [],
        completeStatus: _selectedSlider.toInt(),
        image: _imagePath,
      );

      Future.delayed(Duration.zero, () {
        // * CALL Provider -----------------------------------------------------
        context.read<HistoryProvider>().addHistory(payload).then((value) {
          if (value) {
            Navigator.of(context).pop();
            showToastSuccess(
                context: context, message: "Berhasil menambahkan log");
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

  Future _getImageAndUpload(
      {required BuildContext context, required ImageSource source}) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      return;
    }

    // compress and upload
    await context
        .read<HistoryProvider>()
        .uploadImageForpath(_image!)
        .then((value) {
      if (value.isNotEmpty) {
        setState(() {
          _imagePath = value;
        });
      }
    }).onError((error, _) {
      showToastError(context: context, message: error.toString());
      return Future.error(error.toString());
    });
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
                        "Menambahkan Pekerjaan",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      verticalSpaceSmall,
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
                                  onSelected: (_) {
                                    // mengeset filter berdasarkan pilihan chip
                                    context.read<GeneralProvider>().setFilter(
                                        FilterGeneral(category: e.label));
                                    // memanggil api untuk mendapatkan general yang terkait
                                    context
                                        .read<GeneralProvider>()
                                        .findGeneral("")
                                        .then((_) {
                                      setState(() {
                                        _selectedCategoryID = e.id;
                                      });
                                    }).onError((error, _) {
                                      if (error != null) {
                                        setState(() {
                                          _selectedCategoryID = 0;
                                        });

                                        showToastError(
                                            context: context,
                                            message:
                                                "Gagal mendapatkan data perangkat!");
                                      }
                                    });
                                  },
                                ))
                            .toList(),
                        spacing: 5,
                      ),

                      verticalSpaceSmall,

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
                        inactiveColor: Colors.blueGrey.shade200,
                        thumbColor: Pallete.green,
                        activeColor: Colors.green.shade400,
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
                      if (_imagePath.isNotEmpty)
                        Center(
                          child: CachedImageSquare(
                            urlPath: "${Constant.baseUrl}${_imagePath}",
                            width: 200,
                            height: 200,
                          ),
                        ),
                      verticalSpaceRegular,

                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                                onTap: () => _getImageAndUpload(
                                    context: context,
                                    source: ImageSource.camera),
                                onLongPress: () => _getImageAndUpload(
                                    context: context,
                                    source: ImageSource.gallery),
                                child: Icon(CupertinoIcons.camera)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Consumer<HistoryProvider>(
                              builder: (_, data, __) {
                                return (data.state == ViewState.busy)
                                    // * Button ---------------------------
                                    ? Center(
                                        child:
                                            const CircularProgressIndicator())
                                    : Center(
                                        child: HomeLikeButton(
                                          iconData: CupertinoIcons.add,
                                          text: "Tambah",
                                          tapTap: _addHistory,
                                        ),
                                      );
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: const SizedBox.shrink(),
                          )
                        ],
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
