import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/globals.dart';

import '../../config/histo_category.dart';
import '../../config/pallatte.dart';
import '../../providers/histories.dart';
import '../../shared/disable_glow.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/func_history_dialog.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';
import 'history_list_fragment.dart';

class HistoriesScreen extends StatefulWidget {
  @override
  _HistoriesScreenState createState() => _HistoriesScreenState();
}

class _HistoriesScreenState extends State<HistoriesScreen> {
  late final HistoryProvider historyProvider;

  // Memunculkan dialog
  Future<void> _dialogChangeFilter(BuildContext context) async {
    return await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          var filter = historyProvider.filter;

          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Setting Filter"),
              content: DisableOverScrollGlow(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Kategori"),
                      verticalSpaceSmall,
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        height: 50,
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        decoration:
                            BoxDecoration(color: Pallete.secondaryBackground),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: Text("Kategori"),
                            value: (filter.category != null)
                                ? filter.category
                                : null,
                            items: HistCategory().categoryList.map((cat) {
                              return DropdownMenuItem<String>(
                                value: cat,
                                child: Text(cat),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                filter.category = value;
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).accentColor),
                    child: const Text("Terapkan"),
                    onPressed: () {
                      historyProvider.setFilter(filter);
                      _loadHistories();
                      Navigator.pop(context);
                    }),
              ],
            );
          });
        });
  }

  Future<void> _loadHistories() {
    return Future.delayed(Duration.zero, () {
      historyProvider.findHistory().onError((error, _) =>
          showToastError(context: context, message: error.toString()));
    });
  }

  @override
  void initState() {
    historyProvider = context.read<HistoryProvider>();
    // load history initialitate in home screen
    super.initState();
  }

  @override
  void dispose() {
    if (!App.getRoles().contains("VENDOR")) {
      historyProvider.resetFilter();
    }
    super.dispose();
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
          actions: [
            if (!App.getRoles().contains("VENDOR"))
              IconButton(
                onPressed: () async {
                  await _dialogChangeFilter(context);
                },
                icon: Icon(
                  CupertinoIcons.decrease_indent,
                  size: 28,
                ),
              ),
            horizontalSpaceSmall
          ],
        ),
        body: TabBarView(
          children: [
            HistoryRecyclerView(
              status: enumStatus.info,
              provider: historyProvider,
            ),
            HistoryRecyclerView(
              status: enumStatus.progress,
              provider: historyProvider,
            ),
            HistoryRecyclerView(
              status: enumStatus.pending,
              provider: historyProvider,
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
