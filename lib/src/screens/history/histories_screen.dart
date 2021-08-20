import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/api/filter_models/history_filter.dart';

import '../../config/histo_category.dart';
import '../../config/pallatte.dart';
import '../../globals.dart';
import '../../providers/histories.dart';
import '../../shared/disable_glow.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/func_history_dial.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';
import 'history_list_fragment.dart';

class HistoriesScreen extends StatefulWidget {
  @override
  _HistoriesScreenState createState() => _HistoriesScreenState();
}

class _HistoriesScreenState extends State<HistoriesScreen> {
  late final HistoryProvider historyProvider;
  late final bool _progressIsZero = historyProvider.historyProgressList.isEmpty;
  late final bool _isVendor = App.getRoles().contains("VENDOR");

  // Memunculkan dialog
  Future<void> _dialogChangeFilter(BuildContext context) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          final FilterHistory filter = historyProvider.filter;

          return StatefulBuilder(
              builder: (BuildContext context, Function setState) {
            return AlertDialog(
              title: const Text("Setting Filter"),
              content: DisableOverScrollGlow(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text("Kategori"),
                      verticalSpaceSmall,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        height: 50,
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        decoration: const BoxDecoration(
                            color: Pallete.secondaryBackground),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: const Text("Kategori"),
                            value: (filter.category != null)
                                ? filter.category
                                : null,
                            items:
                                HistCategory().categoryList.map((String cat) {
                              return DropdownMenuItem<String>(
                                value: cat,
                                child: Text(cat),
                              );
                            }).toList(),
                            onChanged: (String? value) {
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
                    onPressed: () {
                      historyProvider.setFilter(filter);
                      _loadHistories();
                      Navigator.pop(context);
                    },
                    child: const Text("Terapkan")),
              ],
            );
          });
        });
  }

  Future<void> _loadHistories() {
    return Future<void>.delayed(Duration.zero, () {
      historyProvider.findHistory().onError((Object? error, _) =>
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
    if (!_isVendor) {
      historyProvider.resetFilter();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: _isVendor
          ? 0
          : _progressIsZero
              ? 0
              : 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: <Tab>[
              Tab(
                text: "All",
              ),
              Tab(
                text: "Progress",
              ),
              Tab(
                text: "Pending",
              ),
            ],
          ),
          title: const Text('History'),
          actions: <Widget>[
            if (!_isVendor)
              IconButton(
                onPressed: () async {
                  await _dialogChangeFilter(context);
                },
                icon: const Icon(
                  CupertinoIcons.decrease_indent,
                  size: 28,
                ),
              ),
            horizontalSpaceSmall
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            HistoryRecyclerView(
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
            icon: const Icon(Icons.add),
            onPressed: () {
              if (_isVendor) {
                HistoryHelper().showAddIncidentV(context);
              } else {
                HistoryHelper().showAddIncident(context);
              }
            },
            label: const Text("Tambah Log")),
      ),
    );
  }
}
