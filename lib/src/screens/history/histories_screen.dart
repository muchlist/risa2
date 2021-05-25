import 'package:flutter/material.dart';
import 'package:risa2/src/screens/history/history_list_fragment.dart';
import 'package:risa2/src/shared/add_history_dialog.dart';
import 'package:risa2/src/utils/enums.dart';

class HistoriesScreen extends StatefulWidget {
  @override
  _HistoriesScreenState createState() => _HistoriesScreenState();
}

class _HistoriesScreenState extends State<HistoriesScreen> {
// * ADD INCIDENT (add_history_dialog)
  void _startAddIncident(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (context) => AddHistoryDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              const Tab(
                text: "All",
              ),
              const Tab(
                text: "Progress",
              ),
              const Tab(
                text: "Pending",
              ),
            ],
          ),
          title: const Text('History'),
        ),
        body: TabBarView(
          children: [
            HistoryRecyclerView(
              status: enumStatus.info,
            ),
            HistoryRecyclerView(
              status: enumStatus.progress,
            ),
            HistoryRecyclerView(
              status: enumStatus.pending,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
            icon: Icon(Icons.add),
            onPressed: () {
              _startAddIncident(context);
            },
            label: Text("Tambah Log")),
      ),
    );
  }
}
