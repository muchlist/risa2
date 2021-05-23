import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../api/json_models/response/history_list_resp.dart';
import '../../providers/cctvs.dart';
import '../../providers/histories.dart';
import '../../shared/empty_box.dart';
import '../../shared/flushbar.dart';
import '../../shared/history_item_widget.dart';
import '../../shared/home_like_button.dart';
import '../../utils/utils.dart';

var refreshKeyCctvHistory = GlobalKey<RefreshIndicatorState>();

class CctvHistoryRecyclerView extends StatefulWidget {
  @override
  _CctvHistoryRecyclerViewState createState() =>
      _CctvHistoryRecyclerViewState();
}

class _CctvHistoryRecyclerViewState extends State<CctvHistoryRecyclerView> {
  late final HistoryProvider historyProvider;

  Future<void> _loadHistory() {
    final parentID = context.read<CctvProvider>().getCctvId();
    return Future.delayed(Duration.zero, () {
      historyProvider.findParentHistory(parentID: parentID).onError(
          (error, _) =>
              showToastError(context: context, message: error.toString()));
    });
  }

  @override
  void initState() {
    historyProvider = context.read<HistoryProvider>();
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
                iconData: Icons.add, text: "Tambah History", tapTap: () {}),
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
              onTap: () {
                // todo
              },
              child: HistoryListTile(history: listData[index]));
        },
      ),
    );
  }
}
