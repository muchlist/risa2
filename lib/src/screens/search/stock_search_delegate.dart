import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../api/json_models/response/stock_list_resp.dart';
import '../../providers/stock.dart';

import '../../shared/stock_item_widget.dart';

class StockSearchDelegate extends SearchDelegate<String?> {
  Widget generateListView(List<StockMinResponse> stockList) {
    if (stockList.length == 0) {
      return Center(
          child: SizedBox(
              height: 200,
              width: 200,
              child: Center(
                  child: Lottie.asset('assets/lottie/629-empty-box.json'))));
    }

    return ListView.builder(
      itemCount: stockList.length,
      itemBuilder: (context, index) {
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
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final stockList = context.read<StockProvider>().stockList;
    if (query == "") {
      return generateListView(stockList);
    } else {
      final stockListFiltered =
          stockList.where((x) => x.name.contains(query.toUpperCase())).toList();

      return generateListView(stockListFiltered);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final stockList = context.read<StockProvider>().stockList;
    if (query == "") {
      return generateListView(stockList);
    } else {
      final stockListFiltered =
          stockList.where((x) => x.name.contains(query.toUpperCase())).toList();

      return generateListView(stockListFiltered);
    }
  }
}
