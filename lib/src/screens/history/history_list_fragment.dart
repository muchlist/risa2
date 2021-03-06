import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/response/history_list_resp.dart';
import '../../providers/histories.dart';
import '../../shared/empty_box.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/func_history_dial.dart';
import '../../shared/history_item_widget.dart';
import '../../utils/enums.dart';

class HistoryRecyclerView extends StatefulWidget {
  const HistoryRecyclerView({
    Key? key,
    required this.provider,
    this.status = enumStatus.info,
  }) : super(key: key);
  final enumStatus status;
  final HistoryProvider provider;

  @override
  _HistoryRecyclerViewState createState() => _HistoryRecyclerViewState();
}

class _HistoryRecyclerViewState extends State<HistoryRecyclerView> {
  GlobalKey<RefreshIndicatorState> refreshKeyProgressHistory =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _loadHistories() {
    return Future<void>.delayed(Duration.zero, () {
      widget.provider.findHistory().onError((Object? error, _) =>
          showToastError(context: context, message: error.toString()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryProvider>(builder: (_, HistoryProvider data, __) {
      List<HistoryMinResponse> histories = <HistoryMinResponse>[];

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
        children: <Widget>[
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: (histories.isNotEmpty)
                  ? buildListView(histories)
                  : (data.state == ViewState.idle)
                      ? EmptyBox(loadTap: _loadHistories)
                      : const Center()),
          if (data.state == ViewState.busy)
            const Center(child: CircularProgressIndicator())
          else
            const Center(),
        ],
      );
    });
  }

  Widget buildListView(List<HistoryMinResponse> listData) {
    return RefreshIndicator(
      key: refreshKeyProgressHistory,
      onRefresh: _loadHistories,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 60),
        itemCount: listData.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () =>
                  HistoryHelper().showDetailIncident(context, listData[index]),
              onDoubleTap: () => HistoryHelper()
                  .showEditIncident(context, listData[index], false),
              onLongPress: () => HistoryHelper().showParent(
                  context: context,
                  category: listData[index].category,
                  parentID: listData[index].parentID),
              child: HistoryListTile(history: listData[index]));
        },
      ),
    );
  }
}
