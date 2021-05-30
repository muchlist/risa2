import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/providers/histories.dart';

import '../../providers/cctvs.dart';
import '../../shared/flushbar.dart';
import 'cctv_detail_fragment.dart';
import 'cctv_history_fragment.dart';

class CctvDetailScreen extends StatefulWidget {
  @override
  _CctvDetailScreenState createState() => _CctvDetailScreenState();
}

class _CctvDetailScreenState extends State<CctvDetailScreen> {
  late final HistoryProvider historyProvider;
  late final CctvProvider cctvProvider;

  Future<void> _loadHistory() {
    final parentID = cctvProvider.getCctvId();
    return Future.delayed(Duration.zero, () {
      historyProvider.findParentHistory(parentID: parentID).onError(
          (error, _) =>
              showToastError(context: context, message: error.toString()));
    });
  }

  Future<void> _loadDetail() {
    return Future.delayed(Duration.zero, () {
      context.read<CctvProvider>().getDetail().onError((error, _) =>
          showToastError(context: context, message: error.toString()));
    });
  }

  @override
  void initState() {
    historyProvider = context.read<HistoryProvider>();
    cctvProvider = context.read<CctvProvider>();
    _loadDetail();
    _loadHistory();
    super.initState();
  }

  @override
  void dispose() {
    historyProvider.clearParentHistory();
    super.dispose();
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
                text: "Riwayat",
              ),
            ],
          ),
          title: const Text('Cctv Detail'),
        ),
        body: TabBarView(
          children: [
            CctvDetailFragment(),
            CctvHistoryRecyclerView(),
          ],
        ),
      ),
    );
  }
}
