import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/improves.dart';
import '../../router/routes.dart';
import '../../shared/empty_box.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/improve_item_widget.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';

class ImproveScreen extends StatefulWidget {
  @override
  _ImproveScreenState createState() => _ImproveScreenState();
}

class _ImproveScreenState extends State<ImproveScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Daftar Improve"),
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
          onPressed: () {
            Navigator.pushNamed(context, RouteGenerator.improveAdd);
          },
          label: const Text("Tambah data")),
      body: ImproveRecyclerView(),
    );
  }
}

class ImproveRecyclerView extends StatefulWidget {
  @override
  _ImproveRecyclerViewState createState() => _ImproveRecyclerViewState();
}

class _ImproveRecyclerViewState extends State<ImproveRecyclerView> {
  final GlobalKey<RefreshIndicatorState> refreshKeyImproveScreen =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _loadImprove() {
    return Future<void>.delayed(Duration.zero, () {
      context.read<ImproveProvider>().findImprove().onError((Object? error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  @override
  void initState() {
    _loadImprove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImproveProvider>(builder: (_, ImproveProvider data, __) {
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: (data.improveList.isNotEmpty)
                  ? buildListView(data)
                  : (data.state == ViewState.idle)
                      ? EmptyBox(loadTap: _loadImprove)
                      : const Center()),
          if (data.state == ViewState.busy)
            const Center(child: CircularProgressIndicator())
          else
            const Center(),
        ],
      );
    });
  }

  Widget buildListView(ImproveProvider data) {
    return RefreshIndicator(
      key: refreshKeyImproveScreen,
      onRefresh: _loadImprove,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 60),
        itemCount: data.improveList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                context.read<ImproveProvider>().removeDetail();
                context
                    .read<ImproveProvider>()
                    .setDetailID(data.improveList[index].id);
                Navigator.pushNamed(context, RouteGenerator.improveDetail);
              },
              child: ImproveListTile(data: data.improveList[index]));
        },
      ),
    );
  }
}
