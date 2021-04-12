import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:risa2/src/api/json_models/request/check_update_req.dart';
import 'package:risa2/src/api/json_models/response/check_resp.dart';
import 'package:risa2/src/config/pallatte.dart';
import 'package:risa2/src/providers/checks.dart';
import 'package:risa2/src/shared/button.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/shared/ui_helpers.dart';
import 'package:risa2/src/utils/enums.dart';

class ExpansionChild extends StatefulWidget {
  final String parentID;
  final CheckItem checkItem;

  const ExpansionChild({required this.parentID, required this.checkItem});

  @override
  _ExpansionChildState createState() => _ExpansionChildState();
}

class _ExpansionChildState extends State<ExpansionChild> {
  bool _haveProblem = false;
  final checkNoteController = TextEditingController();

  void _updateChild() {
    var payload = CheckUpdateRequest(
        parentID: widget.parentID,
        childID: widget.checkItem.id,
        checkedNote: checkNoteController.text,
        isChecked: true,
        haveProblem: _haveProblem,
        completeStatus: enumStatus.complete.index,
        tagSelected: "",
        tagExtraSelected: "");

    context.read<CheckProvider>().updateChildCheck(payload)
      ..then((value) {
        if (value) {
          Flushbar(
            message: "Berhasil mengupdate check",
            duration: Duration(seconds: 3),
            backgroundColor: Theme.of(context).accentColor,
            flushbarPosition: FlushbarPosition.TOP,
          )..show(context);
        }
      }).onError((error, _) {
        if (error != null) {
          Flushbar(
            message: error.toString(),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.red,
            flushbarPosition: FlushbarPosition.TOP,
          )..show(context);
        }
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
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  horizontalSpaceTiny,
                  const Text("Ada kerusakan ?"),
                  Spacer(),
                  Switch(
                    value: _haveProblem,
                    onChanged: (value) {
                      setState(() {
                        _haveProblem = !_haveProblem;
                      });
                    },
                    activeTrackColor: Pallete.secondaryBackground,
                    activeColor: Theme.of(context).accentColor,
                  ),
                ]),
                Row(
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: IconButton(
                        icon: Icon(CupertinoIcons.camera_fill),
                        onPressed: null,
                      ),
                    ),
                    Consumer<CheckProvider>(
                      builder: (_, data, __) {
                        return Expanded(
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
