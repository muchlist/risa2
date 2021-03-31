import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/providers/histories.dart';
import 'package:risa2/src/widgets/history_item_alt.dart';

class DashboardListView extends StatefulWidget {
  @override
  _DashboardListViewState createState() => _DashboardListViewState();
}

class _DashboardListViewState extends State<DashboardListView> {
  @override
  void initState() {
    context.read<HistoryProvider>().findHistory().onError((error, _) {
      if (error != null) {
        final snackBar = SnackBar(
          content: Text(error.toString()),
          duration: Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final historyProvider = context.watch<HistoryProvider>();

    return ListView.builder(
      itemCount: historyProvider.historyList.length,
      itemBuilder: (BuildContext ctx, int index) {
        return HistoryListTile(
          history: historyProvider.historyList[index],
        );
      },
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }
}
