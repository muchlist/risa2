import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/stock.dart';
import '../../router/routes.dart';
import '../../shared/empty_box.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/stock_item_widget.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';
import '../search/stock_search_delegate.dart';

var refreshKeyStockScreen = GlobalKey<RefreshIndicatorState>();

class StockScreen extends StatefulWidget {
  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Inventaris Stock"),
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.search,
              size: 28,
            ),
            onPressed: () async {
              final searchResult = await showSearch(
                context: context,
                delegate: StockSearchDelegate(),
              );
              if (searchResult != null) {
                context.read<StockProvider>().removeDetail();
                context.read<StockProvider>().setStockID(searchResult);
                await Navigator.pushNamed(context, RouteGenerator.stockDetail);
              }
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
            Navigator.pushNamed(context, RouteGenerator.stockAdd);
          },
          label: Text("Tambah data")),
      body: StockRecyclerView(),
    );
  }
}

class StockRecyclerView extends StatefulWidget {
  @override
  _StockRecyclerViewState createState() => _StockRecyclerViewState();
}

class _StockRecyclerViewState extends State<StockRecyclerView> {
  Future<void> _loadStock() {
    return Future.delayed(Duration.zero, () {
      context.read<StockProvider>().findStock().onError((error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  @override
  void initState() {
    _loadStock();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StockProvider>(builder: (_, data, __) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: (data.stockList.length != 0)
                  ? buildListView(data)
                  : (data.state == ViewState.idle)
                      ? EmptyBox(loadTap: _loadStock)
                      : Center()),
          (data.state == ViewState.busy)
              ? Center(child: CircularProgressIndicator())
              : Center(),
        ],
      );
    });
  }

  Widget buildListView(StockProvider data) {
    return RefreshIndicator(
      key: refreshKeyStockScreen,
      onRefresh: _loadStock,
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 60),
        itemCount: data.stockList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                context.read<StockProvider>().removeDetail();
                context
                    .read<StockProvider>()
                    .setStockID(data.stockList[index].id);
                Navigator.pushNamed(context, RouteGenerator.stockDetail);
              },
              child: StockListTile(data: data.stockList[index]));
        },
      ),
    );
  }
}
