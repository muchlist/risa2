import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/ba_provider.dart';
import '../../router/routes.dart';
import '../../shared/ba_item_widget.dart';
import '../../shared/empty_box.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';

GlobalKey<RefreshIndicatorState> refreshKeyBaScreen =
    GlobalKey<RefreshIndicatorState>();

class BaScreen extends StatefulWidget {
  @override
  _BaScreenState createState() => _BaScreenState();
}

class _BaScreenState extends State<BaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Daftar Ba"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              CupertinoIcons.search,
              size: 28,
            ),
            onPressed: () async {
              // TODO search
              // final searchResult = await showSearch(
              //   context: context,
              //   delegate: BaSearchDelegate(),
              // );
              // if (searchResult != null) {
              //   context.read<BaProvider>().removeDetail();
              //   context.read<BaProvider>().setBaID(searchResult);
              //   await Navigator.pushNamed(context, RouteGenerator.baDetail);
              // }
            },
          ),
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
            // TODO route to add BA
            // Navigator.pushNamed(context, RouteGenerator.baAdd);
          },
          label: const Text("Tambah berita acara")),
      body: BaRecyclerView(),
    );
  }
}

class BaRecyclerView extends StatefulWidget {
  @override
  _BaRecyclerViewState createState() => _BaRecyclerViewState();
}

class _BaRecyclerViewState extends State<BaRecyclerView> {
  Future<void> _loadBa() {
    return Future<void>.delayed(Duration.zero, () {
      context.read<BaProvider>().findBa().onError((Object? error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  @override
  void initState() {
    _loadBa();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BaProvider>(builder: (_, BaProvider data, __) {
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: (data.baList.isNotEmpty)
                  ? buildListView(data)
                  : (data.state == ViewState.idle)
                      ? EmptyBox(loadTap: _loadBa)
                      : const Center()),
          if (data.state == ViewState.busy)
            const Center(child: CircularProgressIndicator())
          else
            const Center(),
        ],
      );
    });
  }

  Widget buildListView(BaProvider data) {
    return RefreshIndicator(
      key: refreshKeyBaScreen,
      onRefresh: _loadBa,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 60),
        itemCount: data.baList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                context.read<BaProvider>().removeDetail();
                context.read<BaProvider>().setBaID(data.baList[index].id);
                Navigator.pushNamed(context, RouteGenerator.baDetail);
              },
              child: BaListTile(data: data.baList[index]));
        },
      ),
    );
  }
}
