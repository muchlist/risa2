import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/response/history_list_resp.dart';
import '../../providers/cctvs.dart';
import '../../providers/histories.dart';
import '../../shared/add_parent_history_dialog.dart';
import '../../shared/empty_box.dart';
import '../../shared/flushbar.dart';
import '../../shared/history_item_widget.dart';
import '../../shared/home_like_button.dart';
import '../../utils/utils.dart';
import '../history/history_edit.dart';

var refreshKeyCctvHistory = GlobalKey<RefreshIndicatorState>();

class CctvHistoryRecyclerView extends StatefulWidget {
  @override
  _CctvHistoryRecyclerViewState createState() =>
      _CctvHistoryRecyclerViewState();
}

class _CctvHistoryRecyclerViewState extends State<CctvHistoryRecyclerView> {
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

  // * ADD INCIDENT (add_history_dialog)
  void _startAddIncident(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (context) => AddParentHistoryDialog(
        parentID: cctvProvider.getCctvId(),
        parentName: cctvProvider.cctvDetail.name,
      ),
    );
  }

  // * EDIT INCIDENT (edit_history_dialog)
  void _editIncident(BuildContext context, HistoryMinResponse history) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (context) => EditHistoryDialog(
        history: history,
        forParent: true,
      ),
    );
  }

  @override
  void initState() {
    historyProvider = context.read<HistoryProvider>();
    cctvProvider = context.read<CctvProvider>();
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
                tapTap: () => _startAddIncident(context)),
          )
        ],
      );
    });
  }

  Widget buildListView(List<HistoryMinResponse> listData) {
    return RefreshIndicator(
      key: refreshKeyCctvHistory,
      onRefresh: _loadHistory,
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 60),
        itemCount: listData.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () => _editIncident(context, listData[index]),
              child: HistoryListTile(history: listData[index]));
        },
      ),
    );
  }
}
