import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import '../../providers/stock.dart';
import '../../shared/flushbar.dart';
import 'stock_detail_fragment.dart';
import 'stock_use_fragment.dart';

class StockDetailScreen extends StatefulWidget {
  @override
  _StockDetailScreenState createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      context.read<StockProvider>().getDetail().onError((error, _) =>
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
          bottom: TabBar(
            tabs: [
              const Tab(
                text: "Detail",
              ),
              const Tab(
                text: "Pemakaian",
              ),
            ],
          ),
          title: const Text('Stock Detail'),
        ),
        body: TabBarView(
          children: [
            StockDetailFragment(),
            StockUseRecyclerView(),
          ],
        ),
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          closeManually: false,
          renderOverlay: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.2,
          shape: CircleBorder(),
          children: [
            SpeedDialChild(
              child: Icon(CupertinoIcons.plus),
              backgroundColor: Colors.green.shade100,
              label: 'tambahkan stok',
              onTap: () {},
            ),
            SpeedDialChild(
              child: Icon(CupertinoIcons.minus),
              backgroundColor: Colors.red.shade100,
              label: 'kurangi stok',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
