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
          final TextEditingController searchController =
              TextEditingController();

          return StatefulBuilder(
              builder: (BuildContext context, Function setState) {
            return AlertDialog(
              title: const Text("Log Filter"),
              insetPadding: const EdgeInsets.symmetric(horizontal: 1),
              content: DisableOverScrollGlow(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text("Search"),
                      verticalSpaceSmall,
                      Container(
                        width: screenWidthPercentage(context, percentage: 0.8),
                        height: 50,
                        decoration: BoxDecoration(
                            color: Pallete.secondaryBackground,
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Center(
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    searchController.clear();
                                  },
                                ),
                                hintText: 'Search...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      verticalSpaceTiny,
                      const Text(
                        "Sebagian atau seluruh hasil pencarian\nmungkin akan berada di tab [All]",
                        style:
                            TextStyle(color: Colors.deepOrange, fontSize: 13),
                      ),
                      verticalSpaceSmall,
                      const Text("Kategori"),
                      verticalSpaceSmall,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        height: 50,
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
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
                                filter.category = value ?? HistCategory.all;
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
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).colorScheme.secondary),
                        onPressed: () {
                          historyProvider.setFilter(filter);
                          _loadHistories(search: searchController.text);
                          Navigator.pop(context);
                        },
                        child: const Text("Terapkan")),
                  ),
                ),
              ],
            );
          });
        });
  }

  Future<void> _loadHistories({String search = ""}) {
    return Future<void>.delayed(Duration.zero, () {
      historyProvider.findHistory(search: search).onError((Object? error, _) =>
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
            labelColor: Colors.black,
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
          title: const Text('LOG'),
          actions: <Widget>[
            if (!_isVendor)
              IconButton(
                onPressed: () async {
                  await _dialogChangeFilter(context);
                },
                icon: const Icon(
                  CupertinoIcons.search,
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
