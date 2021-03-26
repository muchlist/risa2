import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/providers/histories.dart';
import 'package:risa2/src/widgets/history_item_alt.dart';

class DashboardListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final historyData = Provider.of<HistoryProvider>(context);
    final histories = historyData.historyList;

    return ListView.builder(
      itemCount: histories.length,
      itemBuilder: (BuildContext ctx, int index) {
        return HistoryListTile(
          history: histories[index],
        );
      },
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }
}
