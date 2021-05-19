import 'package:flutter/material.dart';
import 'package:risa2/src/screens/stock/stock_detail_fragment.dart';
import 'package:risa2/src/screens/stock/stock_use_fragment.dart';

class CctvDetailScreen extends StatefulWidget {
  @override
  _CctvDetailScreenState createState() => _CctvDetailScreenState();
}

class _CctvDetailScreenState extends State<CctvDetailScreen> {
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
      ),
    );
  }
}
