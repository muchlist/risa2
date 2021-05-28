import 'package:flutter/material.dart';

import '../../shared/func_history_dialog.dart';
import '../../utils/enums.dart';
import 'history_list_fragment.dart';

class HistoriesScreen extends StatefulWidget {
  @override
  _HistoriesScreenState createState() => _HistoriesScreenState();
}

class _HistoriesScreenState extends State<HistoriesScreen> {
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
              HistoryHelper().showAddIncident(context);
            },
            label: const Text("Tambah Log")),
      ),
    );
  }
}
