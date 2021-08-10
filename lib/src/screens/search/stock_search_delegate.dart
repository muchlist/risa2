import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../api/json_models/response/stock_list_resp.dart';
import '../../providers/stock.dart';

import '../../shared/stock_item_widget.dart';

class StockSearchDelegate extends SearchDelegate<String?> {
  Widget generateListView(List<StockMinResponse> stockList) {
    if (stockList.isEmpty) {
      return Center(
          child: SizedBox(
              height: 200,
              width: 200,
              child: Center(
                  child: Lottie.asset('assets/lottie/629-empty-box.json'))));
    }

    return ListView.builder(
      itemCount: stockList.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => close(context, stockList[index].id),
          child: StockListTile(
            data: stockList[index],
          ),
        );
      },
    );
  }

  @override
  List<Widget> buildActions(Object context) {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<StockMinResponse> stockList =
        context.read<StockProvider>().stockList;
    if (query == "") {
      return generateListView(stockList);
    } else {
      final List<StockMinResponse> stockListFiltered = stockList
          .where((StockMinResponse x) => x.name.contains(query.toUpperCase()))
          .toList();

      return generateListView(stockListFiltered);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<StockMinResponse> stockList =
        context.read<StockProvider>().stockList;
    if (query == "") {
      return generateListView(stockList);
    } else {
      final List<StockMinResponse> stockListFiltered = stockList
          .where((StockMinResponse x) => x.name.contains(query.toUpperCase()))
          .toList();

      return generateListView(stockListFiltered);
    }
  }
}
