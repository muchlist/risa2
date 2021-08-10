import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/request/check_update_req.dart';
import '../../api/json_models/response/check_resp.dart';
import '../../config/pallatte.dart';
import '../../providers/checks.dart';
import '../../shared/button.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';

class ExpansionChild extends StatefulWidget {
  const ExpansionChild({required this.parentID, required this.checkItem});
  final String parentID;
  final CheckItem checkItem;

  @override
  _ExpansionChildState createState() => _ExpansionChildState();
}

class _ExpansionChildState extends State<ExpansionChild> {
  bool _haveProblem = false;
  final TextEditingController checkNoteController = TextEditingController();
  String? _selectedTag;

  void _updateChild({bool bypass = false}) {
    // validasi
    if (widget.checkItem.imagePath.isEmpty && !bypass) {
      showToastWarning(
          context: context, message: "Silakan upload foto terlebih dahulu!");
      return;
    }

    final CheckUpdateRequest payload = CheckUpdateRequest(
        parentID: widget.parentID,
        childID: widget.checkItem.id,
        checkedNote: checkNoteController.text,
        isChecked: true,
        haveProblem: _haveProblem,
        completeStatus: enumStatus.completed.index,
        tagSelected: _selectedTag ?? "",
        tagExtraSelected: "");

    context.read<CheckProvider>().updateChildCheck(payload).then((bool value) {
      if (value) {
        showToastSuccess(
          context: context,
          message: "Berhasil mengupdate check",
        );
      }
    }).onError((Object? error, _) {
      if (error != null) {
        showToastError(context: context, message: error.toString());
      }
    });
  }

  late File? _image;
  final ImagePicker picker = ImagePicker();

  Future<void> getImageAndUpload(
      BuildContext context, String id, String childID) async {
    final PickedFile? pickedFile =
        await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      return;
    }

    // compress and upload
    await context
        .read<CheckProvider>()
        .uploadChildCheck(id, childID, _image!)
        .then((bool value) {
      if (value) {
        if (widget.checkItem.checkedAt == 0) {
          _updateChild(bypass: true);
        }
      }
    }).onError((Object? error, _) {
      showToastError(context: context, message: error.toString());
      // ignore: prefer_void_to_null
      return Future<Null>.error(error.toString());
    });
  }

  @override
  void initState() {
    _haveProblem = widget.checkItem.haveProblem;
    checkNoteController.text = widget.checkItem.checkedNote;
    super.initState();
  }

  @override
  void dispose() {
    checkNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  // initialValue: widget.checkItem.checkedNote,
                  controller: checkNoteController,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Pallete.secondaryBackground,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                  maxLines: 2,
                  minLines: 1,
                ),

                verticalSpaceTiny,
                // dropdown item
                if (widget.checkItem.tag.isNotEmpty)
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
                        hint: const Text("Tag"),
                        value: _selectedTag,
                        items: widget.checkItem.tag.map((String tag) {
                          return DropdownMenuItem<String>(
                            value: tag,
                            child: Text(tag),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedTag = value;
                          });
                        },
                      ),
                    ),
                  )
                else
                  Container(),
                Row(children: <Widget>[
                  horizontalSpaceTiny,
                  const Text("Terdapat kendala / outstanding? "),
                  const Spacer(),
                  Switch(
                    value: _haveProblem,
                    onChanged: (bool value) {
                      setState(() {
                        _haveProblem = !_haveProblem;
                      });
                    },
                    activeTrackColor: Colors.red.shade50,
                    activeColor: Colors.redAccent,
                  ),
                ]),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: IconButton(
                        icon: const Icon(
                          CupertinoIcons.camera_fill,
                          color: Colors.grey,
                        ),
                        onPressed: () => getImageAndUpload(
                            context, widget.parentID, widget.checkItem.id),
                      ),
                    ),
                    const Spacer(),
                    Consumer<CheckProvider>(
                      builder: (_, CheckProvider data, __) {
                        return Flexible(
                          child: RisaButton(
                            title: "Update",
                            onPress: _updateChild,
                            disabled: data.childState == ViewState.busy,
                          ),
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
