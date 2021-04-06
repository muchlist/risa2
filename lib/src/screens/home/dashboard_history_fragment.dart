import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/providers/histories.dart';
import 'package:risa2/src/utils/enums.dart';
import 'package:risa2/src/shared/history_item_widget.dart';

class DashboardListView extends StatefulWidget {
  @override
  _DashboardListViewState createState() => _DashboardListViewState();
}

class _DashboardListViewState extends State<DashboardListView> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      context
          .read<HistoryProvider>()
          .findHistory()
          .then((_) {})
          .onError((error, _) {
        if (error != null) {
          Flushbar(
            message: error.toString(),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.red.withOpacity(0.7),
          )..show(context);
        }
      });
    });
    super.initState();
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
          child:
              Center(child: Lottie.asset('assets/lottie/629-empty-box.json')));
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
                  child: HistoryListTile(
                    history: historyProvider.historyListDashboard[index],
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
