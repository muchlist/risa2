import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/api/json_models/response/checkp_list_resp.dart';

import '../../providers/checks_master.dart';
import '../../router/routes.dart';
import '../../shared/empty_box.dart';
import '../../shared/func_flushbar.dart';
import '../../utils/enums.dart';

GlobalKey<RefreshIndicatorState> refreshKeyCheckMasterSreen =
    GlobalKey<RefreshIndicatorState>();

class CheckMasterScreen extends StatefulWidget {
  @override
  _CheckMasterScreenState createState() => _CheckMasterScreenState();
}

class _CheckMasterScreenState extends State<CheckMasterScreen> {
  late CheckMasterProvider _checkMasterProvider;

  @override
  void initState() {
    _checkMasterProvider = context.read<CheckMasterProvider>();
    super.initState();
  }

  @override
  void dispose() {
    _checkMasterProvider.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Master pengecekan"),
      ),
      body: CheckMasterRecyclerView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Tambah"),
        icon: const Icon(CupertinoIcons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(RouteGenerator.checkMasterAdd);
        },
      ),
    );
  }
}

// CheckMasterReceiclerView ------------------------------------
class CheckMasterRecyclerView extends StatefulWidget {
  @override
  _CheckMasterRecyclerViewState createState() =>
      _CheckMasterRecyclerViewState();
}

class _CheckMasterRecyclerViewState extends State<CheckMasterRecyclerView> {
  Future<void> _loadCheck() {
    return Future<void>.delayed(Duration.zero, () {
      context
          .read<CheckMasterProvider>()
          .findCheckMaster()
          .onError((Object? error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  @override
  void initState() {
    _loadCheck();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckMasterProvider>(
      builder: (_, CheckMasterProvider data, __) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: (data.checkpList.isNotEmpty)
                    ? buildListView(data)
                    : (data.state == ViewState.idle)
                        ? EmptyBox(loadTap: _loadCheck)
                        : const Center()),
            if (data.state == ViewState.busy)
              const Center(child: CircularProgressIndicator())
            else
              const Center(),
          ],
        );
      },
    );
  }

  Widget buildListView(CheckMasterProvider data) {
    return RefreshIndicator(
      key: refreshKeyCheckMasterSreen,
      onRefresh: _loadCheck,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 60),
        itemCount: data.checkpList.length,
        itemBuilder: (BuildContext context, int index) {
          final CheckpMinResponse checkp = data.checkpList[index];

          return GestureDetector(
              onTap: () {
                data
                  ..removeDetail()
                  ..setCheckID(checkp.id);
                Navigator.of(context).pushNamed(RouteGenerator.checkMasterEdit);
              },
              child: Card(
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(checkp.name),
                      Text(
                        "${checkp.type} - ${checkp.location}",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      )
                    ],
                  ),
                  trailing: checkp.shifts.isNotEmpty
                      ? Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 2,
                          children: checkp.shifts
                              .map((int e) => Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      e.toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  )))
                              .toList(),
                        )
                      : null,
                ),
              ));
        },
      ),
    );
  }
}
