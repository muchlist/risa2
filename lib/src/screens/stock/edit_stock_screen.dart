import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/api/json_models/response/stock_resp.dart';

import '../../api/json_models/request/stock_edit_req.dart';
import '../../config/pallatte.dart';
import '../../providers/stock.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';

class EditStockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Edit Stock"),
      ),
      body: EditStockBody(),
    );
  }
}

class EditStockBody extends StatefulWidget {
  @override
  _EditStockBodyState createState() => _EditStockBodyState();
}

class _EditStockBodyState extends State<EditStockBody> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  String? _selectedCategory;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController thresholdController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  void _editStock(int timestamp) {
    if (_key.currentState?.validate() ?? false) {
      // validasi tambahan
      String errorMessage = "";
      if (_selectedCategory == null) {
        errorMessage = errorMessage + "kategori tidak boleh kosong. ";
      }
      if (errorMessage.isNotEmpty) {
        showToastWarning(context: context, message: errorMessage);
        return;
      }

      int threshold = 0;
      if (thresholdController.text.isNotEmpty) {
        threshold = int.parse(thresholdController.text);
      }

      // Payload
      final StockEditRequest payload = StockEditRequest(
        filterTimestamp: timestamp,
        name: titleController.text,
        stockCategory: _selectedCategory ?? "",
        location: locationController.text.toUpperCase(),
        unit: unitController.text.toLowerCase(),
        threshold: threshold,
        note: noteController.text,
      );

      // Call Provider
      Future<void>.delayed(
          Duration.zero,
          () => context
                  .read<StockProvider>()
                  .editStock(payload)
                  .then((bool value) {
                if (value) {
                  Navigator.of(context).pop();
                  showToastSuccess(
                      context: context, message: "Berhasil mengedit stok");
                }
              }).onError((Object? error, _) {
                if (error != null) {
                  showToastError(context: context, message: error.toString());
                }
              }));
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    locationController.dispose();
    unitController.dispose();
    qtyController.dispose();
    thresholdController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    final StockDetailResponseData existData =
        context.read<StockProvider>().stockDetail;

    titleController.text = existData.name;
    noteController.text = existData.note;
    locationController.text = existData.location;
    unitController.text = existData.unit;
    qtyController.text = existData.qty.toString();
    thresholdController.text = existData.threshold.toString();

    // default length == 1 , if option got update length more than 1
    if (context.read<StockProvider>().stockOption.category.length == 1) {
      Future<void>.delayed(
              Duration.zero,
              () => context
                      .read<StockProvider>()
                      .findOptionStock()
                      .onError((Object? error, _) {
                    showToastError(context: context, message: error.toString());
                  }))
          .whenComplete(() => _selectedCategory = existData.stockCategory);
    } else {
      _selectedCategory = existData.stockCategory;
    }
    super.initState();
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
                "Nama Stok",
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
                    return 'Nama stok tidak boleh kosong';
                  }
                  return null;
                },
              ),

              verticalSpaceSmall,

              // * Category dropdown ------------------------
              const Text(
                "Kategori",
                style: TextStyle(fontSize: 16),
              ),
              Consumer<StockProvider>(
                builder: (_, StockProvider data, __) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    decoration:
                        const BoxDecoration(color: Pallete.secondaryBackground),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text("Kategori"),
                        value: (_selectedCategory != null)
                            ? _selectedCategory
                            : null,
                        items: data.stockOption.category.map((String cat) {
                          return DropdownMenuItem<String>(
                            value: cat,
                            child: Text(cat),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),

              verticalSpaceSmall,

              // * Qty text ------------------------
              const Text(
                "Jumlah stok awal",
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
                controller: qtyController,
                validator: (String? text) {
                  if (text == null || text.isEmpty) {
                    return null;
                  } else if (int.tryParse(text) != null &&
                      int.parse(text) >= 0) {
                    return null;
                  }
                  return "Qty harus berupa bilangan bulat";
                },
              ),

              verticalSpaceSmall,

              // * Satuan text ------------------------
              const Text(
                "Satuan",
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
                controller: unitController,
                validator: (String? text) {
                  if (text == null || text.isEmpty) {
                    return "Satuan tidak boleh kosong";
                  } else if (text.length > 5) {
                    return "Satuan tidak boleh melebihi 5 karakter";
                  }
                  return null;
                },
              ),

              verticalSpaceSmall,

              // * Ambang batas text ------------------------
              const Text(
                "Ambang batas",
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
                controller: thresholdController,
                validator: (String? text) {
                  if (text == null || text.isEmpty) {
                    return null;
                  } else if (int.tryParse(text) != null &&
                      int.parse(text) >= 0) {
                    return null;
                  }
                  return "Ambang batas harus berupa bilangan bulat";
                },
              ),

              verticalSpaceSmall,

              // * Note text ------------------------
              const Text(
                "Lokasi",
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
                controller: locationController,
                validator: (String? text) {
                  if (text == null || text.isEmpty) {
                    return "Lokasi tidak boleh kosong";
                  }
                  return null;
                },
              ),

              verticalSpaceSmall,

              // * Note text ------------------------
              const Text(
                "Catatan",
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
                controller: noteController,
              ),

              verticalSpaceMedium,
              Consumer<StockProvider>(builder: (_, StockProvider data, __) {
                return (data.state == ViewState.busy)
                    ? const Center(child: CircularProgressIndicator())
                    : Center(
                        child: HomeLikeButton(
                            iconData: CupertinoIcons.pencil_circle,
                            text: "Edit Stok",
                            tapTap: () =>
                                _editStock(data.stockDetail.updatedAt)),
                      );
              }),

              verticalSpaceMedium,
            ],
          ),
        ),
      ),
    );
  }
}
