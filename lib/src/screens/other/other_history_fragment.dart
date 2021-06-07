import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/response/history_list_resp.dart';
import '../../providers/histories.dart';
import '../../providers/others.dart';
import '../../shared/empty_box.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/func_history_dialog.dart';
import '../../shared/history_item_widget.dart';
import '../../shared/home_like_button.dart';
import '../../utils/utils.dart';

var refreshKeyOtherHistory = GlobalKey<RefreshIndicatorState>();

class OtherHistoryRecyclerView extends StatefulWidget {
  @override
  _OtherHistoryRecyclerViewState createState() =>
      _OtherHistoryRecyclerViewState();
}

class _OtherHistoryRecyclerViewState extends State<OtherHistoryRecyclerView> {
  late final HistoryProvider historyProvider;
  late final OtherProvider otherProvider;

  Future<void> _loadHistory() {
    final parentID = otherProvider.getOtherId();
    return Future.delayed(Duration.zero, () {
      historyProvider.findParentHistory(parentID: parentID).onError(
          (error, _) =>
              showToastError(context: context, message: error.toString()));
    });
  }

  @override
  void initState() {
    historyProvider = context.read<HistoryProvider>();
    otherProvider = context.read<OtherProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryProvider>(builder: (_, data, __) {
      final histories = data.parentHistory;

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
                      ? EmptyBox(loadTap: _loadHistory)
                      : Center()),
          (data.state == ViewState.busy)
              ? Center(child: CircularProgressIndicator())
              : Center(),
          Positioned(
            bottom: 30,
            child: HomeLikeButton(
                iconData: Icons.add,
                text: "Tambah History",
                tapTap: () => HistoryHelper().showAddParentIncident(
                    context,
                    otherProvider.getOtherId(),
                    otherProvider.otherDetail.name)),
          )
        ],
      );
    });
  }

  Widget buildListView(List<HistoryMinResponse> listData) {
    return RefreshIndicator(
      key: refreshKeyOtherHistory,
      onRefresh: _loadHistory,
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 60),
        itemCount: listData.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () =>
                  HistoryHelper().showDetailIncident(context, listData[index]),
              onDoubleTap: () => HistoryHelper()
                  .showEditIncident(context, listData[index], true),
              child: HistoryListTile(history: listData[index]));
        },
      ),
    );
  }
}
