import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/screens/history/slider_history_helper.dart';

import '../../api/json_models/request/history_edit_req.dart';
import '../../api/json_models/response/history_list_resp.dart';
import '../../config/constant.dart';
import '../../config/pallatte.dart';
import '../../providers/histories.dart';
import '../../shared/cached_image_square.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';
import '../../utils/utils.dart';

class EditHistoryDialog extends StatefulWidget {
  const EditHistoryDialog(
      {Key? key, required this.history, required this.forParent})
      : super(key: key);
  final HistoryMinResponse history;
  final bool forParent;

  @override
  _EditHistoryDialogState createState() => _EditHistoryDialogState();
}

class _EditHistoryDialogState extends State<EditHistoryDialog> {
  late double _selectedSlider;
  late String _selectedLabel;
  // Text controller
  final TextEditingController problemController = TextEditingController();
  final TextEditingController resolveNoteController = TextEditingController();

  String imageUrl = "";

  late File? _image;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    final HistoryMinResponse history = widget.history;
    _selectedSlider = const SliderHelper().getSliderNum(history.completeStatus);
    _selectedLabel = const SliderHelper().getLabelStatus(_selectedSlider);
    problemController.text = history.problem;
    resolveNoteController.text = history.problemResolve;
    imageUrl = history.image;
    super.initState();
  }

  Future<void> _getImageAndUpload(
      {required BuildContext context,
      required ImageSource source,
      required String id}) async {
    final PickedFile? pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      return;
    }

    // compress and upload
    await context
        .read<HistoryProvider>()
        .uploadImage(id, _image!)
        .then((String value) {
      if (value.isNotEmpty) {
        showToastSuccess(
          context: context,
          message: "Berhasil mengupload gambar",
        );
        setState(() {
          imageUrl = value;
        });
      }
    }).onError((Object? error, _) {
      showToastError(context: context, message: error.toString());
    });
  }

  // Form key
  final GlobalKey<FormState> _addHistoryFormkey = GlobalKey<FormState>();

  void _editHistory() {
    if (_addHistoryFormkey.currentState?.validate() ?? false) {
      final String problemText = problemController.text;
      final String resolveText = resolveNoteController.text;

      final HistoryEditRequest payload = HistoryEditRequest(
          filterTimestamp: widget.history.updatedAt,
          problem: problemText,
          problemResolve: resolveText,
          status: "None",
          tag: <String>[],
          completeStatus: const SliderHelper().getStatus(_selectedSlider),
          dateEnd: DateTime.now().toInt());

      Future<void>.delayed(Duration.zero, () {
        // * CALL Provider -----------------------------------------------------

        if (widget.forParent) {
          context
              .read<HistoryProvider>()
              .editHistoryForParent(
                  id: widget.history.id,
                  payload: payload,
                  parentID: widget.history.parentID)
              .then((bool value) {
            if (value) {
              Navigator.of(context).pop();
              showToastSuccess(
                  context: context, message: "Berhasil memperbarui history");
            }
          }).onError((Object? error, _) {
            if (error != null) {
              showToastError(context: context, message: error.toString());
            }
          });
        } else {
          context
              .read<HistoryProvider>()
              .editHistory(
                id: widget.history.id,
                payload: payload,
              )
              .then((bool value) {
            if (value) {
              Navigator.of(context).pop();
              showToastSuccess(
                  context: context, message: "Berhasil memperbarui history");
            }
          }).onError((Object? error, _) {
            if (error != null) {
              showToastError(context: context, message: error.toString());
            }
          });
        }
      });
    } else {
      debugPrint("Error :(");
    }
  }

  Future<bool?> _getConfirm(BuildContext context) {
    return showDialog<bool?>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Konfirmasi hapus"),
            content: const Text("Apakah yakin ingin menghapus history ini!"),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.secondary),
                  child: const Text("Tidak"),
                  onPressed: () => Navigator.of(context).pop(false)),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Ya"))
            ],
          );
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
                        "Update Incident",
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
                          widget.history.parentName,
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
                        inactiveColor: Colors.blueGrey.shade200,
                        thumbColor: Pallete.green,
                        activeColor: Colors.green.shade400,
                        onChanged: (double value) {
                          setState(() {
                            _selectedSlider = value;
                            _selectedLabel = const SliderHelper()
                                .getLabelStatus(_selectedSlider);
                          });
                        },
                      ),

                      verticalSpaceSmall,

                      // * ResolveNote text ------------------------
                      if (_selectedSlider == 3.0 || _selectedSlider == 4.0)
                        const Text(
                          "Resolve Note",
                          style: TextStyle(fontSize: 16),
                        )
                      else
                        const SizedBox.shrink(),

                      if (_selectedSlider == 3.0 || _selectedSlider == 4.0)
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
                      if (imageUrl.isNotEmpty)
                        Center(
                          child: CachedImageSquare(
                            urlPath: "${Constant.baseUrl}$imageUrl",
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
                                    source: ImageSource.camera,
                                    id: widget.history.id),
                                onLongPress: () => _getImageAndUpload(
                                    context: context,
                                    source: ImageSource.gallery,
                                    id: widget.history.id),
                                child: const Icon(CupertinoIcons.camera)),
                          ),
                          Expanded(
                            child: Consumer<HistoryProvider>(
                              builder: (_, HistoryProvider data, __) {
                                return (data.state == ViewState.busy)
                                    // * Button ---------------------------
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : HomeLikeButton(
                                        iconData: CupertinoIcons.pencil_circle,
                                        text: "Update",
                                        tapTap: _editHistory);
                              },
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                                icon: Icon(
                                  CupertinoIcons.trash,
                                  color: Colors.red[200],
                                ),
                                onPressed: () async {
                                  final bool? confirmDelete =
                                      await _getConfirm(context);
                                  if (confirmDelete != null && confirmDelete) {
                                    await context
                                        .read<HistoryProvider>()
                                        .deleteHistory(widget.history.id)
                                        .then((bool value) {
                                      if (value) {
                                        Navigator.pop(context);
                                        showToastSuccess(
                                            context: context,
                                            message:
                                                "Berhasil menghapus check");
                                      }
                                    }).onError((Object? error, _) {
                                      showToastError(
                                          context: context,
                                          message: error.toString());
                                    });
                                  }
                                }),
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
