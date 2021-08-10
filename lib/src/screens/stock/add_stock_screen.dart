import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/request/stock_req.dart';
import '../../config/pallatte.dart';
import '../../providers/stock.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';

class AddStockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Tambah Stock"),
      ),
      body: AddStockBody(),
    );
  }
}

class AddStockBody extends StatefulWidget {
  @override
  _AddStockBodyState createState() => _AddStockBodyState();
}

class _AddStockBodyState extends State<AddStockBody> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  String? _selectedCategory;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController thresholdController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  void _addStock() {
    if (_key.currentState?.validate() ?? false) {
      // validasi tambahan
      var errorMessage = "";
      if (_selectedCategory == null) {
        errorMessage = errorMessage + "kategori tidak boleh kosong. ";
      }
      if (errorMessage.isNotEmpty) {
        showToastWarning(context: context, message: errorMessage);
        return;
      }

      var qty = 0;
      var threshold = 0;
      if (qtyController.text.isNotEmpty) {
        qty = int.parse(qtyController.text);
      }
      if (thresholdController.text.isNotEmpty) {
        threshold = int.parse(thresholdController.text);
      }

      // Payload
      final payload = StockRequest(
          name: titleController.text,
          stockCategory: _selectedCategory ?? "",
          location: locationController.text.toUpperCase(),
          unit: unitController.text.toLowerCase(),
          qty: qty,
          threshold: threshold,
          note: noteController.text,
          deactive: false);

      // Call Provider
      Future.delayed(
          Duration.zero,
          () => context.read<StockProvider>().addStock(payload).then((value) {
                if (value) {
                  Navigator.of(context).pop();
                  showToastSuccess(
                      context: context,
                      message: "Berhasil membuat stok ${payload.name}");
                }
              }).onError((error, _) {
                if (error != null) {
                  showToastError(
                      context: context, message: error.toString(), onTop: true);
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
    // default length == 1 , if option got update length more than 1
    if (context.read<StockProvider>().stockOption.category.length == 1) {
      Future.delayed(
          Duration.zero,
          () => context
                  .read<StockProvider>()
                  .findOptionStock()
                  .onError((error, _) {
                showToastError(context: context, message: error.toString());
              }));
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
              children: [
                // * Judul text ------------------------
                const Text(
                  "Nama Stok",
                  style: TextStyle(fontSize: 16),
                ),

                TextFormField(
                  textInputAction: TextInputAction.next,
                  minLines: 1,
                  maxLines: 1,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Pallete.secondaryBackground,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                  controller: titleController,
                  validator: (text) {
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
                Consumer<StockProvider>(builder: (_, data, __) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    decoration:
                        BoxDecoration(color: Pallete.secondaryBackground),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Text("Kategori"),
                        value: (_selectedCategory != null)
                            ? _selectedCategory
                            : null,
                        items: data.stockOption.category.map((cat) {
                          return DropdownMenuItem<String>(
                            value: cat,
                            child: Text(cat),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                            FocusScope.of(context).requestFocus(FocusNode());
                          });
                        },
                      ),
                    ),
                  );
                }),

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
                  maxLines: 1,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Pallete.secondaryBackground,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                  controller: qtyController,
                  validator: (text) {
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
                  maxLines: 1,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Pallete.secondaryBackground,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                  controller: unitController,
                  validator: (text) {
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
                  maxLines: 1,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Pallete.secondaryBackground,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                  controller: thresholdController,
                  validator: (text) {
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
                  validator: (text) {
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

                Consumer<StockProvider>(builder: (_, data, __) {
                  return (data.state == ViewState.busy)
                      ? Center(child: const CircularProgressIndicator())
                      : Center(
                          child: HomeLikeButton(
                              iconData: CupertinoIcons.add,
                              text: "Buat Stok",
                              tapTap: _addStock),
                        );
                }),

                verticalSpaceMedium,
              ],
            ),
          )),
    );
  }
}
