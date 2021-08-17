import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/pallatte.dart';
import '../../models/maintenance_chip_models.dart';
import '../../providers/cctv_maintenance.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';

class AddMaintenanceDialog extends StatefulWidget {
  const AddMaintenanceDialog();

  @override
  _AddMaintenanceDialogState createState() => _AddMaintenanceDialogState();
}

class _AddMaintenanceDialogState extends State<AddMaintenanceDialog> {
  // pilihan chip kategory
  final List<ItemMaintnenanceChoice> listChoices = getItemMaintenanceChoice();
  int _choiceSelected = 0;

  // textController
  final TextEditingController _nameController = TextEditingController();

  void _addCheck() {
    // validasi shift
    if (_choiceSelected == 0 || _nameController.text.isEmpty) {
      showToastWarning(
          context: context, message: "Harap melengkapi data terlebih dahulu!");
      return;
    }

    // Call Provider
    Future<void>.delayed(
        Duration.zero,
        () => context
                .read<CctvMaintProvider>()
                .addCctvCheck(_choiceSelected == 2, _nameController.text)
                .then((bool value) {
              if (value) {
                Navigator.of(context).pop();
                showToastSuccess(
                    context: context, message: "Berhasil membuat check");
              }
            }).onError((Object? error, _) {
              if (error != null) {
                showToastError(context: context, message: error.toString());
              }
            }));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Divider(
              indent: 70,
              endIndent: 70,
              height: 10,
              thickness: 5,
              color: Pallete.secondaryBackground,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      "Membuat data checklist",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    // * Pilih kategori text ------------------------
                    const Text(
                      "Pilih tipe cek :",
                      style: TextStyle(fontSize: 16),
                    ),
                    verticalSpaceSmall,
                    // * Chip choice
                    Wrap(
                      spacing: 10,
                      children: listChoices
                          .map((ItemMaintnenanceChoice e) => ChoiceChip(
                                label: Text(
                                  e.label,
                                  style: (_choiceSelected == e.id)
                                      ? const TextStyle(
                                          color: Colors.white, fontSize: 20)
                                      : const TextStyle(),
                                ),
                                selected: _choiceSelected == e.id,
                                selectedColor: Theme.of(context).accentColor,
                                // * Setstate ------------------------------
                                onSelected: (_) => setState(() {
                                  _choiceSelected = e.id;
                                }),
                              ))
                          .toList(),
                    ),

                    verticalSpaceMedium,
                    // * Nama
                    const Text(
                      "Nama Cek",
                      style: TextStyle(fontSize: 16),
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Pallete.secondaryBackground,
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none),
                      controller: _nameController,
                    ),
                    verticalSpaceMedium,
                    // * Button ---------------------------
                    Consumer<CctvMaintProvider>(
                        builder: (_, CctvMaintProvider data, __) {
                      if (data.state == ViewState.busy) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return Center(
                        child: HomeLikeButton(
                            iconData: CupertinoIcons.add,
                            text: "Generate Check",
                            tapTap: _addCheck),
                      );
                    }),
                    verticalSpaceMedium,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
