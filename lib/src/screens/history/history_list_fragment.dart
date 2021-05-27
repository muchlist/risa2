import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/response/history_list_resp.dart';
import '../../providers/histories.dart';
import '../../shared/empty_box.dart';
import '../../shared/flushbar.dart';
import '../../shared/history_item_widget.dart';
import '../../utils/enums.dart';

class HistoryRecyclerView extends StatefulWidget {
  final enumStatus status;

  const HistoryRecyclerView({Key? key, this.status = enumStatus.info})
      : super(key: key);

  @override
  _HistoryRecyclerViewState createState() => _HistoryRecyclerViewState();
}

class _HistoryRecyclerViewState extends State<HistoryRecyclerView> {
  late final HistoryProvider historyProvider;
  var refreshKeyProgressHistory = GlobalKey<RefreshIndicatorState>();

  Future<void> _loadHistories() {
    return Future.delayed(Duration.zero, () {
      historyProvider.findHistory().onError((error, _) =>
          showToastError(context: context, message: error.toString()));
    });
  }

  @override
  void initState() {
    historyProvider = context.read<HistoryProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryProvider>(builder: (_, data, __) {
      var histories = <HistoryMinResponse>[];

      switch (widget.status) {
        case enumStatus.progress:
          histories = data.historyProgressList;
          break;
        case enumStatus.pending:
          histories = data.historyPendingList;
          break;
        default:
          histories = data.historyList;
      }

      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: (histories.length != 0)
                  ? buildListView(histories)
                  : (data.state == ViewState.idle)
                      ? EmptyBox(loadTap: _loadHistories)
                      : Center()),
          (data.state == ViewState.busy)
              ? Center(child: CircularProgressIndicator())
              : Center(),
        ],
      );
    });
  }

  Widget buildListView(List<HistoryMinResponse> listData) {
    return RefreshIndicator(
      key: refreshKeyProgressHistory,
      onRefresh: _loadHistories,
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 60),
        itemCount: listData.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                // todo
              },
              child: HistoryListTile(history: listData[index]));
        },
      ),
    );
  }
}