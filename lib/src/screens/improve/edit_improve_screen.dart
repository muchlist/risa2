import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/api/json_models/response/improve_resp.dart';
import '../../api/json_models/request/improve_edit_req.dart';

import '../../config/pallatte.dart';
import '../../providers/improves.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';

class EditImproveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Edit Improve"),
      ),
      body: EditImproveBody(),
    );
  }
}

class EditImproveBody extends StatefulWidget {
  @override
  _EditImproveBodyState createState() => _EditImproveBodyState();
}

class _EditImproveBodyState extends State<EditImproveBody> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController goalController = TextEditingController();

  void _editImprove() {
    if (_key.currentState?.validate() ?? false) {
      int goal = 0;
      if (goalController.text.isNotEmpty) {
        goal = int.parse(goalController.text);
      }

      // Payload
      final ImproveEditRequest payload = ImproveEditRequest(
        filterTimestamp:
            context.read<ImproveProvider>().improveDetail.updatedAt,
        title: titleController.text,
        description: descController.text,
        completeStatus: 0,
        goal: goal,
      );

      // Call Provider
      Future<void>.delayed(
          Duration.zero,
          () => context
                  .read<ImproveProvider>()
                  .editImprove(payload)
                  .then((bool value) {
                if (value) {
                  Navigator.of(context).pop();
                  showToastSuccess(
                      context: context,
                      message: "Berhasil membuat ${payload.title}");
                }
              }).onError((Object? error, _) {
                if (error != null) {
                  showToastError(context: context, message: error.toString());
                }
              }));
    }
  }

  @override
  void initState() {
    final ImproveDetailResponseData existData =
        context.read<ImproveProvider>().improveDetail;
    titleController.text = existData.title;
    descController.text = existData.description;
    goalController.text = existData.goal.toString();

    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          // Consumer ------------------------------------------------------
          child: Form(
            key: _key,
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
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Pallete.secondaryBackground,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                  controller: titleController,
                  validator: (String? text) {
                    if (text == null || text.isEmpty) {
                      return 'Judul tidak boleh kosong';
                    }
                    return null;
                  },
                ),

                verticalSpaceSmall,

                // * Detail text ------------------------
                const Text(
                  "Detail",
                  style: TextStyle(fontSize: 16),
                ),

                TextFormField(
                  textInputAction: TextInputAction.newline,
                  minLines: 2,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Pallete.secondaryBackground,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                  controller: descController,
                ),

                verticalSpaceSmall,

                // * Qty text ------------------------
                const Text(
                  "Goal (Optional)",
                  style: TextStyle(fontSize: 16),
                ),

                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  minLines: 1,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Pallete.secondaryBackground,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                  controller: goalController,
                  validator: (String? text) {
                    if (text == null || text.isEmpty) {
                      return null;
                    } else if (int.tryParse(text) != null &&
                        int.parse(text) >= 0) {
                      return null;
                    }
                    return "Goal harus berupa bilangan bulat positif";
                  },
                ),

                verticalSpaceSmall,

                Consumer<ImproveProvider>(
                    builder: (_, ImproveProvider data, __) {
                  return (data.state == ViewState.busy)
                      ? const Center(child: CircularProgressIndicator())
                      : Center(
                          child: HomeLikeButton(
                              iconData: CupertinoIcons.pencil_circle,
                              text: "Edit Improvement Item",
                              tapTap: _editImprove),
                        );
                }),

                verticalSpaceMedium,
              ],
            ),
          )),
    );
  }
}
