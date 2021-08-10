import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/api/json_models/request/vendor_req.dart';

import '../../api/json_models/request/history_req.dart';
import '../../config/constant.dart';
import '../../config/pallatte.dart';
import '../../providers/histories.dart';
import '../../shared/cached_image_square.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';

class AddMaintenanceHistoryDialog extends StatefulWidget {
  const AddMaintenanceHistoryDialog(
      {Key? key, required this.parentName, required this.mtState})
      : super(key: key);

  final String parentName;
  // child id in VendorUpdateRequest is parent ID item for maintenance
  final VendorUpdateRequest mtState;

  @override
  _AddMaintenanceHistoryDialogState createState() =>
      _AddMaintenanceHistoryDialogState();
}

class _AddMaintenanceHistoryDialogState
    extends State<AddMaintenanceHistoryDialog> {
  late double _selectedSlider;
  late String _selectedLabel;

  @override
  void initState() {
    _selectedSlider =
        (widget.mtState.isBlur || widget.mtState.isOffline) ? 1.0 : 4.0;
    _selectedLabel = (widget.mtState.isBlur || widget.mtState.isOffline)
        ? "Progress"
        : "Completed";
    problemController.text = _problemTextBuilder(widget.mtState);
    resolveNoteController.text =
        (widget.mtState.isBlur || widget.mtState.isOffline)
            ? ""
            : "Selesai dilakukan pemeliharaan";
    super.initState();
  }

  String _problemTextBuilder(VendorUpdateRequest state) {
    String problem = "#maintenance\n";
    if (state.isBlur) {
      problem += "#isBlur CCTV display bermasalah\n";
    }
    if (state.isOffline) {
      problem += "#isOffline CCTV dalam keadaan mati\n";
    }
    if (!state.isBlur && !state.isOffline) {
      problem += "Tidak ada kendala pada CCTV";
    }
    return problem;
  }

  // image
  String _imagePath = "";
  late File? _image;
  final ImagePicker picker = ImagePicker();

  // Text controller
  final TextEditingController problemController = TextEditingController();
  final TextEditingController resolveNoteController = TextEditingController();

  // Form key
  final GlobalKey<FormState> _addHistoryFormkey = GlobalKey<FormState>();

  void _addHistory() {
    if (_addHistoryFormkey.currentState?.validate() ?? false) {
      final String problemText = problemController.text;
      final String resolveText = resolveNoteController.text;

      final HistoryRequest payload = HistoryRequest(
        id: "",
        parentID: widget.mtState.childID,
        problem: problemText,
        problemResolve: resolveText,
        status: "Maintenance",
        tag: <String>["Maintenance"],
        completeStatus: _selectedSlider.toInt(),
        image: _imagePath,
      );

      Future<void>.delayed(Duration.zero, () {
        // * CALL Provider -----------------------------------------------------
        context
            .read<HistoryProvider>()
            .addHistory(payload, parentID: widget.mtState.childID)
            .then((bool value) {
          if (value) {
            Navigator.of(context).pop();
            showToastSuccess(
                context: context, message: "Berhasil menambahkan log");
          }
        }).onError((Object? error, _) {
          if (error != null) {
            showToastError(context: context, message: error.toString());
          }
        });
      });
    } else {
      debugPrint("Error :(");
    }
  }

  Future<void> _getImageAndUpload(
      {required BuildContext context, required ImageSource source}) async {
    final PickedFile? pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      return;
    }

    // compress and upload
    await context
        .read<HistoryProvider>()
        .uploadImageForpath(_image!)
        .then((String value) {
      if (value.isNotEmpty) {
        setState(() {
          _imagePath = value;
        });
      }
    }).onError((Object? error, _) {
      showToastError(context: context, message: error.toString());
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
    return SizedBox(
      height: screenHeightPercentage(context, percentage: 0.95),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Divider(
              height: 40,
              thickness: 5,
              color: Pallete.secondaryBackground,
              indent: 50,
              endIndent: 50,
            ),
            verticalSpaceSmall,
            Expanded(
                child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overScroll) {
                overScroll.disallowGlow();
                return false;
              },
              child: SingleChildScrollView(
                child: Form(
                  key: _addHistoryFormkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
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
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        decoration: const BoxDecoration(
                            color: Pallete.secondaryBackground),
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
                        validator: (String? text) {
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
                        style: const TextStyle(fontSize: 16),
                      ),
                      Slider(
                        min: 1,
                        max: 4,
                        divisions: 3,
                        value: _selectedSlider,
                        label: _selectedLabel,
                        onChanged: (double value) {
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

                      if (_selectedSlider == 4.0)
                        const Text(
                          "Resolve Note",
                          style: TextStyle(fontSize: 16),
                        )
                      else
                        const SizedBox.shrink(),

                      if (_selectedSlider == 4.0)
                        TextFormField(
                          textInputAction: TextInputAction.newline,
                          maxLines: 3,
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Pallete.secondaryBackground,
                              enabledBorder: InputBorder.none,
                              border: InputBorder.none),
                          validator: (String? text) {
                            if ((text == null || text.isEmpty) &&
                                _selectedSlider == 4.0) {
                              return 'resolve note tidak boleh kosong';
                            }
                            return null;
                          },
                          controller: resolveNoteController,
                        )
                      else
                        const SizedBox.shrink(),
                      verticalSpaceRegular,
                      if (_imagePath.isNotEmpty)
                        Center(
                          child: CachedImageSquare(
                            urlPath: "${Constant.baseUrl}$_imagePath",
                            width: 200,
                            height: 200,
                          ),
                        ),
                      verticalSpaceRegular,

                      Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                                onTap: () => _getImageAndUpload(
                                    context: context,
                                    source: ImageSource.camera),
                                onLongPress: () => _getImageAndUpload(
                                    context: context,
                                    source: ImageSource.gallery),
                                child: const Icon(CupertinoIcons.camera)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Consumer<HistoryProvider>(
                              builder: (_, HistoryProvider data, __) {
                                return (data.state == ViewState.busy)
                                    // * Button ---------------------------
                                    ? const Center(
                                        child: CircularProgressIndicator())
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
                          const Expanded(
                            child: SizedBox.shrink(),
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
