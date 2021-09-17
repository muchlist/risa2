import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/config_check.dart';
import '../../shared/config_check_widget.dart';
import '../../shared/empty_box.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';
import '../../utils/utils.dart';
import 'add_configcheck_dial.dart';

class ConfigCheckScreen extends StatefulWidget {
  @override
  _ConfigCheckScreenState createState() => _ConfigCheckScreenState();
}

class _ConfigCheckScreenState extends State<ConfigCheckScreen> {
  void _startAddConfigCheck(BuildContext context) {
    showModalBottomSheet(
      // isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (BuildContext context) => const AddConfigCheckDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Config tersimpan"),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.decrease_indent,
              size: 28,
            ),
          ),
          horizontalSpaceSmall
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          onPressed: () => _startAddConfigCheck(context),
          label: const Text("Tambah data")),
      body: ConfigCheckRecyclerView(),
    );
  }
}

class ConfigCheckRecyclerView extends StatefulWidget {
  @override
  _ConfigCheckRecyclerViewState createState() =>
      _ConfigCheckRecyclerViewState();
}

class _ConfigCheckRecyclerViewState extends State<ConfigCheckRecyclerView> {
  final GlobalKey<RefreshIndicatorState> refreshKeyConfigCheckScreen =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _loadConfigCheck() {
    return Future<void>.delayed(Duration.zero, () {
      context
          .read<ConfigCheckProvider>()
          .findConfigCheck()
          .onError((Object? error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  @override
  void initState() {
    _loadConfigCheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConfigCheckProvider>(
        builder: (_, ConfigCheckProvider data, __) {
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: (data.configList.isNotEmpty)
                  ? buildListView(data)
                  : (data.state == ViewState.idle)
                      ? EmptyBox(loadTap: _loadConfigCheck)
                      : const Center()),
          if (data.state == ViewState.busy)
            const Center(child: CircularProgressIndicator())
          else
            const Center(),
        ],
      );
    });
  }

  Widget buildListView(ConfigCheckProvider data) {
    return RefreshIndicator(
      key: refreshKeyConfigCheckScreen,
      onRefresh: _loadConfigCheck,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 60),
        itemCount: data.configList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                showToastWarning(
                    context: context,
                    message: "tahan lama untuk menghapus item");
              },
              child: ConfigCheckListTile(data: data.configList[index]));
        },
      ),
    );
  }
}
