import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/response/cctv_list_resp.dart';
import '../../providers/cctvs.dart';
import '../../shared/cctv_item_widget.dart';

class CctvSearchDelegate extends SearchDelegate<String?> {
  Widget generateListView(List<CctvMinResponse> cctvList) {
    if (cctvList.isEmpty) {
      return Center(
          child: SizedBox(
              height: 200,
              width: 200,
              child: Center(
                  child: Lottie.asset('assets/lottie/629-empty-box.json'))));
    }

    return ListView.builder(
      itemCount: cctvList.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => close(context, cctvList[index].id),
          child: CctvListTile(
            data: cctvList[index],
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
    final List<CctvMinResponse> cctvList =
        context.read<CctvProvider>().cctvList;
    if (query == "") {
      return generateListView(cctvList);
    } else {
      final List<CctvMinResponse> cctvListFiltered = cctvList
          .where((CctvMinResponse x) =>
              x.name.contains(query.toUpperCase()) || x.ip.contains(query))
          .toList();

      return generateListView(cctvListFiltered);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<CctvMinResponse> cctvList =
        context.read<CctvProvider>().cctvList;
    if (query == "") {
      return generateListView(cctvList);
    } else {
      final List<CctvMinResponse> cctvListFiltered = cctvList
          .where((CctvMinResponse x) =>
              x.name.contains(query.toUpperCase()) || x.ip.contains(query))
          .toList();

      return generateListView(cctvListFiltered);
    }
  }
}
