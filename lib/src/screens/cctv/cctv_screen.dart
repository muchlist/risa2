import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/providers/cctvs.dart';

import '../../shared/cctv_item_widget.dart';
import '../../shared/empty_box.dart';
import '../../shared/flushbar.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';

var refreshKeyCctvScreen = GlobalKey<RefreshIndicatorState>();

class CctvScreen extends StatefulWidget {
  @override
  _CctvScreenState createState() => _CctvScreenState();
}

class _CctvScreenState extends State<CctvScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Inventaris Cctv"),
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.search,
              size: 28,
            ),
            onPressed: () async {
              // todo create cctv search delegate
              // final searchResult = await showSearch(
              //   context: context,
              //   delegate: CctvSearchDelegate(),
              // );
              // if (searchResult != null) {
              //   context.read<CctvProvider>().removeDetail();
              //   context.read<CctvProvider>().setCctvID(searchResult);
              //   await Navigator.pushNamed(context, RouteGenerator.cctvDetail);
              // }
            },
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.decrease_indent,
              size: 28,
            ),
          ),
          horizontalSpaceSmall
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          onPressed: () {
            // todo create add cctv screen
            // Navigator.pushNamed(context, RouteGenerator.cctvAdd);
          },
          label: Text("Tambah data")),
      body: CctvRecyclerView(),
    );
  }
}

class CctvRecyclerView extends StatefulWidget {
  @override
  _CctvRecyclerViewState createState() => _CctvRecyclerViewState();
}

class _CctvRecyclerViewState extends State<CctvRecyclerView> {
  Future<void> _loadCctv() {
    return Future.delayed(Duration.zero, () {
      context.read<CctvProvider>().findCctv().onError((error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  @override
  void initState() {
    _loadCctv();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CctvProvider>(builder: (_, data, __) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: (data.cctvList.length != 0)
                  ? buildListView(data)
                  : (data.state == ViewState.idle)
                      ? EmptyBox(loadTap: _loadCctv)
                      : Center()),
          (data.state == ViewState.busy)
              ? Center(child: CircularProgressIndicator())
              : Center(),
        ],
      );
    });
  }

  Widget buildListView(CctvProvider data) {
    return RefreshIndicator(
      key: refreshKeyCctvScreen,
      onRefresh: _loadCctv,
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 60),
        itemCount: data.cctvList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                context.read<CctvProvider>().removeDetail();
                context.read<CctvProvider>().setCctvID(data.cctvList[index].id);
                // todo create cctv detail screen
                // Navigator.pushNamed(context, RouteGenerator.cctvDetail);
              },
              child: CctvListTile(data: data.cctvList[index]));
        },
      ),
    );
  }
}
