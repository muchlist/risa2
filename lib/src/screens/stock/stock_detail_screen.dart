import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import '../../providers/stock.dart';
import '../../router/routes.dart';
import '../../shared/func_flushbar.dart';
import 'stock_detail_fragment.dart';
import 'stock_use_fragment.dart';

class StockDetailScreen extends StatefulWidget {
  @override
  _StockDetailScreenState createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  Future<bool?> _incrementConfirm(BuildContext context) {
    return showDialog<bool?>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Konfirmasi penambahan stok"),
            content: const Text(
                "Apakah anda yakin ingin menambahkan stok? peringatan ini muncul karena user sering tertukar ketika hendak mengurangi atau menambahkan stok!"),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.secondary),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Tidak")),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Ya"))
            ],
          );
        });
  }

  @override
  void initState() {
    Future<void>.delayed(Duration.zero, () {
      context.read<StockProvider>().getDetail().onError((Object? error, _) =>
          showToastError(context: context, message: error.toString()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text: "Detail",
              ),
              Tab(
                text: "Pemakaian",
              ),
            ],
          ),
          title: const Text('Stock Detail'),
        ),
        body: TabBarView(
          children: <Widget>[
            StockDetailFragment(),
            StockUseRecyclerView(),
          ],
        ),
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.2,
          children: <SpeedDialChild>[
            SpeedDialChild(
              child: const Icon(CupertinoIcons.plus),
              backgroundColor: Colors.green.shade100,
              label: 'tambahkan stok',
              onTap: () async {
                final bool? incremented = await _incrementConfirm(context);
                if (incremented != null && incremented) {
                  await Navigator.pushNamed(
                      context, RouteGenerator.stockIncrement);
                }
              },
            ),
            SpeedDialChild(
              child: const Icon(CupertinoIcons.minus),
              backgroundColor: Colors.red.shade100,
              label: 'kurangi stok',
              onTap: () {
                Navigator.pushNamed(context, RouteGenerator.stockDecrement);
              },
            ),
          ],
        ),
      ),
    );
  }
}
