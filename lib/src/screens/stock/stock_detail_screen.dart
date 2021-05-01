import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/stock.dart';
import '../../shared/flushbar.dart';
import 'stock_detail_fragment.dart';

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
            Icon(Icons.directions_transit),
          ],
        ),
      ),
    );
  }
}
