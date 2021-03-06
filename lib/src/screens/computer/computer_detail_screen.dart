import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/providers/histories.dart';

import '../../providers/computers.dart';
import '../../shared/func_flushbar.dart';
import 'computer_detail_fragment.dart';
import 'computer_history_fragment.dart';

class ComputerDetailScreen extends StatefulWidget {
  @override
  _ComputerDetailScreenState createState() => _ComputerDetailScreenState();
}

class _ComputerDetailScreenState extends State<ComputerDetailScreen> {
  late final HistoryProvider historyProvider;
  late final ComputerProvider computerProvider;

  Future<void> _loadHistory() {
    final String parentID = computerProvider.getComputerId();
    return Future<void>.delayed(Duration.zero, () {
      historyProvider.findParentHistory(parentID: parentID).onError(
          (Object? error, _) =>
              showToastError(context: context, message: error.toString()));
    });
  }

  Future<void> _loadDetail() {
    return Future<void>.delayed(Duration.zero, () {
      context.read<ComputerProvider>().getDetail().onError((Object? error, _) =>
          showToastError(context: context, message: error.toString()));
    });
  }

  @override
  void initState() {
    historyProvider = context.read<HistoryProvider>();
    computerProvider = context.read<ComputerProvider>();
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
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text: "Detail",
              ),
              Tab(
                text: "Riwayat",
              ),
            ],
          ),
          title: const Text('Komputer Detail'),
        ),
        body: TabBarView(
          children: <Widget>[
            ComputerDetailFragment(),
            ComputerHistoryRecyclerView(),
          ],
        ),
      ),
    );
  }
}
