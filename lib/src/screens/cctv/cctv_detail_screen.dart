import 'package:flutter/material.dart';
import 'package:risa2/src/providers/cctvs.dart';
import 'package:risa2/src/screens/stock/stock_use_fragment.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/shared/flushbar.dart';

import 'cctv_detail_fragment.dart';

class CctvDetailScreen extends StatefulWidget {
  @override
  _CctvDetailScreenState createState() => _CctvDetailScreenState();
}

class _CctvDetailScreenState extends State<CctvDetailScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      context.read<CctvProvider>().getDetail().onError((error, _) =>
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
          title: const Text('Cctv Detail'),
        ),
        body: TabBarView(
          children: [
            CctvDetailFragment(),
            StockUseRecyclerView(),
          ],
        ),
      ),
    );
  }
}
