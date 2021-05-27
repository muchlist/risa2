import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/request/history_edit_req.dart';
import '../../api/json_models/response/history_list_resp.dart';
import '../../config/constant.dart';
import '../../config/pallatte.dart';
import '../../providers/histories.dart';
import '../../shared/cached_image_square.dart';
import '../../shared/flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';
import '../../utils/utils.dart';

class EditHistoryDialog extends StatefulWidget {
  final HistoryMinResponse history;
  final bool forParent;

  const EditHistoryDialog(
      {Key? key, required this.history, required this.forParent})
      : super(key: key);

  @override
  _EditHistoryDialogState createState() => _EditHistoryDialogState();
}

class _EditHistoryDialogState extends State<EditHistoryDialog> {
  late double _selectedSlider;
  late String _selectedLabel;
  // Text controller
  final problemController = TextEditingController();
  final resolveNoteController = TextEditingController();

  String imageUrl = "";

  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    var history = widget.history;
    _selectedSlider = history.completeStatus.toDouble();
    _selectedLabel = enumStatus.values[history.completeStatus].toShortString();
    problemController.text = history.problem;
    resolveNoteController.text = history.problemResolve;
    imageUrl = history.image;
    super.initState();
  }

  Future _getImageAndUpload(
      {required BuildContext context,
      required ImageSource source,
      required String id}) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      return;
    }

    // compress and upload
    await context
        .read<HistoryProvider>()
        .uploadImage(id, _image!)
        .then((value) {
      if (value.isNotEmpty) {
        showToastSuccess(
            context: context,
            message: "Berhasil mengupload gambar",
            onTop: true);
        setState(() {
          imageUrl = value;
        });
      }
    }).onError((error, _) {
      showToastError(context: context, message: error.toString());
      return Future.error(error.toString());
    });
  }

  // Form key
  final _addHistoryFormkey = GlobalKey<FormState>();

  void _editHistory() {
    if (_addHistoryFormkey.currentState?.validate() ?? false) {
      final problemText = problemController.text;
      final resolveText = resolveNoteController.text;

      final payload = HistoryEditRequest(
          filterTimestamp: widget.history.updatedAt,
          problem: problemText,
          problemResolve: resolveText,
          status: "None",
          tag: [],
          completeStatus: _selectedSlider.toInt(),
          dateEnd: DateTime.now().toInt());

      Future.delayed(Duration.zero, () {
        // * CALL Provider -----------------------------------------------------

        if (widget.forParent) {
          context
              .read<HistoryProvider>()
              .editHistoryForParent(
                  id: widget.history.id,
                  payload: payload,
                  parentID: widget.history.parentID)
              .then((value) {
            if (value) {
              Navigator.of(context).pop();
              showToastSuccess(
                  context: context, message: "Berhasil memperbarui history");
            }
          }).onError((error, _) {
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
              .then((value) {
            if (value) {
              Navigator.of(context).pop();
              showToastSuccess(
                  context: context, message: "Berhasil memperbarui history");
            }
          }).onError((error, _) {
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
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        decoration:
                            BoxDecoration(color: Pallete.secondaryBackground),
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
                      if (imageUrl.isNotEmpty)
                        Center(
                          child: CachedImageSquare(
                            urlPath: "${Constant.baseUrl}${imageUrl}",
                            width: 200,
                            height: 200,
                          ),
                        ),
                      verticalSpaceRegular,
                      Row(
                        children: [
                          Expanded(
                            child: IconButton(
                                onPressed: () => _getImageAndUpload(
                                    context: context,
                                    source: ImageSource.camera,
                                    id: widget.history.id),
                                icon: Icon(CupertinoIcons.camera)),
                          ),
                          Expanded(
                            child: Consumer<HistoryProvider>(
                              builder: (_, data, __) {
                                return (data.state == ViewState.busy)
                                    // * Button ---------------------------
                                    ? Center(
                                        child:
                                            const CircularProgressIndicator())
                                    : HomeLikeButton(
                                        iconData: CupertinoIcons.pencil_circle,
                                        text: "Edit Log",
                                        tapTap: _editHistory);
                              },
                            ),
                          ),
                          Expanded(
                            child: SizedBox(),
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
