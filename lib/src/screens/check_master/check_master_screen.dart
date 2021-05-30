import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/checks_master.dart';
import '../../router/routes.dart';
import '../../shared/empty_box.dart';
import '../../shared/func_flushbar.dart';
import '../../utils/enums.dart';

var refreshKeyCheckMasterSreen = GlobalKey<RefreshIndicatorState>();

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
        label: Text("Tambah"),
        icon: Icon(CupertinoIcons.add),
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
  Future<dynamic> _loadCheck() {
    return Future.delayed(Duration.zero, () {
      context.read<CheckMasterProvider>().findCheckMaster().onError((error, _) {
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
      builder: (_, data, __) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: (data.checkpList.length != 0)
                    ? buildListView(data)
                    : (data.state == ViewState.idle)
                        ? EmptyBox(loadTap: _loadCheck)
                        : Center()),
            (data.state == ViewState.busy)
                ? Center(child: CircularProgressIndicator())
                : Center(),
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
        padding: EdgeInsets.only(bottom: 60),
        itemCount: data.checkpList.length,
        itemBuilder: (context, index) {
          final checkp = data.checkpList[index];

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
                    children: [
                      Text(checkp.name),
                      Text(
                        "${checkp.type} - ${checkp.location}",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      )
                    ],
                  ),
                  trailing: checkp.shifts.length > 0
                      ? Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 2,
                          children: checkp.shifts
                              .map((e) => Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      e.toString(),
                                      style: TextStyle(color: Colors.white),
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
