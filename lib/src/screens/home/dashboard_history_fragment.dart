import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/providers/histories.dart';
import 'package:risa2/src/widgets/history_item_widget.dart';

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

    if (historyProvider.historyList.length == 0) {
      return const CircularProgressIndicator();
    } else {
      return AnimationLimiter(
        child: ListView.builder(
          itemCount: historyProvider.historyList.length,
          itemBuilder: (BuildContext ctx, int index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 500),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: HistoryListTile(
                    history: historyProvider.historyList[index],
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
