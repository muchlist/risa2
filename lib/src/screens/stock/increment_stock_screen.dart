import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../api/json_models/request/stock_change_req.dart';
import '../../config/pallatte.dart';
import '../../providers/stock.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';

class IncrementStockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Menambahkan Stock"),
      ),
      body: IncrementStockBody(),
    );
  }
}

class IncrementStockBody extends StatefulWidget {
  @override
  _IncrementStockBodyState createState() => _IncrementStockBodyState();
}

class _IncrementStockBodyState extends State<IncrementStockBody> {
  final _key = GlobalKey<FormState>();

  final qtyController = TextEditingController();
  final noteController = TextEditingController();

  void _incrementStock() {
    if (_key.currentState?.validate() ?? false) {
      final timeNow = DateTime.now().millisecondsSinceEpoch;
      // Payload
      final payload = StockChangeRequest(
          baNumber: timeNow.toString(),
          note: noteController.text,
          qty: int.parse(qtyController.text),
          time: 0);

      // Call Provider
      Future.delayed(
          Duration.zero,
          () =>
              context.read<StockProvider>().changeStock(payload).then((value) {
                if (value) {
                  Navigator.of(context).pop();
                  showToastSuccess(
                      context: context, message: "Berhasil menambahkan stok");
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
    noteController.dispose();
    qtyController.dispose();

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
              children: [
                // * Judul text ------------------------
                const Text(
                  "Nama Stok",
                  style: TextStyle(fontSize: 16),
                ),

                TextFormField(
                  enabled: false,
                  minLines: 1,
                  maxLines: 1,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Pallete.secondaryBackground,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                  initialValue: context.read<StockProvider>().stockDetail.name,
                ),

                verticalSpaceSmall,

                // * Qty text ------------------------
                const Text(
                  "Jumlah penambahan",
                  style: TextStyle(fontSize: 16),
                ),

                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: false, signed: false),
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
                      return "Qty tidak boleh kosong";
                    } else if (int.tryParse(text) != null &&
                        int.parse(text) >= 0) {
                      return null;
                    }
                    return "Qty harus berupa bilangan bulat positif";
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
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "Catatan tidak boleh kosong";
                    }
                    return null;
                  },
                ),

                verticalSpaceMedium,

                Consumer<StockProvider>(builder: (_, data, __) {
                  return (data.stockChangeState == ViewState.busy)
                      ? Center(child: const CircularProgressIndicator())
                      : Center(
                          child: HomeLikeButton(
                              iconData: CupertinoIcons.add,
                              text: "Tambahkan Stok",
                              tapTap: _incrementStock),
                        );
                }),

                verticalSpaceMedium,
              ],
            ),
          )),
    );
  }
}
