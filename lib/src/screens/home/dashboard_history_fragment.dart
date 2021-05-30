import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../../providers/histories.dart';
import '../../shared/empty_box.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/func_history_dialog.dart';
import '../../shared/history_item_widget.dart';
import '../../utils/enums.dart';

class DashboardListView extends StatefulWidget {
  @override
  _DashboardListViewState createState() => _DashboardListViewState();
}

class _DashboardListViewState extends State<DashboardListView> {
  @override
  void initState() {
    _loadHistory();
    super.initState();
  }

  Future<dynamic> _loadHistory() {
    return Future.delayed(Duration.zero, () {
      context
          .read<HistoryProvider>()
          .findHistory()
          .then((_) {})
          .onError((error, _) {
        if (error != null) {
          showToastError(context: context, message: error.toString());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Provider
    final historyProvider = context.watch<HistoryProvider>();

    if (historyProvider.state == ViewState.busy) {
      return const CircularProgressIndicator();
    } else if (historyProvider.historyListDashboard.length == 0) {
      return SizedBox(
          height: 200,
          width: 200,
          child: EmptyBox(
            loadTap: _loadHistory,
          ));
    } else {
      return AnimationLimiter(
        child: ListView.builder(
          itemCount: historyProvider.historyListDashboard.length,
          itemBuilder: (BuildContext ctx, int index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 500),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: GestureDetector(
                    onDoubleTap: () => HistoryHelper().showEditIncident(context,
                        historyProvider.historyListDashboard[index], false),
                    onTap: () => HistoryHelper().showDetailIncident(
                        context, historyProvider.historyListDashboard[index]),
                    onLongPress: () => HistoryHelper().showParent(
                        context, historyProvider.historyListDashboard[index]),
                    child: HistoryListTile(
                      history: historyProvider.historyListDashboard[index],
                    ),
                  ),
                ),
              ),
            );
          },
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
        ),
      );
    }
  }
}
