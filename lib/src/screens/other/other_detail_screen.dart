import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/histories.dart';

import '../../providers/others.dart';
import '../../shared/func_flushbar.dart';
import 'other_detail_fragment.dart';
import 'other_history_fragment.dart';

class OtherDetailScreen extends StatefulWidget {
  @override
  _OtherDetailScreenState createState() => _OtherDetailScreenState();
}

class _OtherDetailScreenState extends State<OtherDetailScreen> {
  late final HistoryProvider historyProvider;
  late final OtherProvider otherProvider;

  Future<void> _loadHistory() {
    final String parentID = otherProvider.getOtherId();
    return Future<void>.delayed(Duration.zero, () {
      historyProvider.findParentHistory(parentID: parentID).onError(
          (Object? error, _) =>
              showToastError(context: context, message: error.toString()));
    });
  }

  Future<void> _loadDetail() {
    return Future<void>.delayed(Duration.zero, () {
      context.read<OtherProvider>().getDetail().onError((Object? error, _) =>
          showToastError(context: context, message: error.toString()));
    });
  }

  @override
  void initState() {
    historyProvider = context.read<HistoryProvider>();
    otherProvider = context.read<OtherProvider>();
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
            tabs: <Tab>[
              Tab(
                text: "Detail",
              ),
              Tab(
                text: "Riwayat",
              ),
            ],
          ),
          title: Text('${otherProvider.subCategory} Detail'),
        ),
        body: TabBarView(
          children: <Widget>[
            OtherDetailFragment(),
            OtherHistoryRecyclerView(),
          ],
        ),
      ),
    );
  }
}
