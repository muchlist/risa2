import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../api/json_models/request/stock_change_req.dart';
import '../../config/pallatte.dart';
import '../../providers/stock.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/utils.dart';

class DecrementStockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Mengurangi Stock"),
      ),
      body: DecrementStockBody(),
    );
  }
}

class DecrementStockBody extends StatefulWidget {
  @override
  _DecrementStockBodyState createState() => _DecrementStockBodyState();
}

class _DecrementStockBodyState extends State<DecrementStockBody> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final TextEditingController qtyController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  void _decrementStock() {
    if (_key.currentState?.validate() ?? false) {
      final int timeNow = DateTime.now().toInt();
      // Payload
      final StockChangeRequest payload = StockChangeRequest(
          baNumber: timeNow.toString(),
          note: noteController.text,
          qty: -int.parse(qtyController.text),
          time: 0);

      // Call Provider
      Future<void>.delayed(
          Duration.zero,
          () => context
                  .read<StockProvider>()
                  .changeStock(payload)
                  .then((bool value) {
                if (value) {
                  Navigator.of(context).pop();
                  showToastSuccess(
                      context: context, message: "Berhasil mengurangi stok");
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
              children: <Widget>[
                // * Judul text ------------------------
                const Text(
                  "Nama Stok",
                  style: TextStyle(fontSize: 16),
                ),

                TextFormField(
                  enabled: false,
                  minLines: 1,
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
                  "Jumlah pengurangan",
                  style: TextStyle(fontSize: 16),
                ),

                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: const TextInputType.numberWithOptions(),
                  minLines: 1,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Pallete.secondaryBackground,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                  controller: qtyController,
                  validator: (String? text) {
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
                  validator: (String? text) {
                    if (text == null || text.isEmpty) {
                      return "Catatan tidak boleh kosong";
                    }
                    return null;
                  },
                ),

                verticalSpaceMedium,

                Consumer<StockProvider>(builder: (_, StockProvider data, __) {
                  return (data.stockChangeState == ViewState.busy)
                      ? const Center(child: CircularProgressIndicator())
                      : Center(
                          child: HomeLikeButton(
                              iconData: CupertinoIcons.add,
                              text: "Kurangkan Stok",
                              tapTap: _decrementStock),
                        );
                }),

                verticalSpaceMedium,
              ],
            ),
          )),
    );
  }
}
