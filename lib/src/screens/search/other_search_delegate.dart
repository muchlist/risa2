import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/response/other_list_resp.dart';
import '../../providers/others.dart';
import '../../shared/other_item_widget.dart';

class OtherSearchDelegate extends SearchDelegate<String?> {
  Widget generateListView(List<OtherMinResponse> otherList) {
    if (otherList.isEmpty) {
      return Center(
          child: SizedBox(
              height: 200,
              width: 200,
              child: Center(
                  child: Lottie.asset('assets/lottie/629-empty-box.json'))));
    }

    return ListView.builder(
      itemCount: otherList.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => close(context, otherList[index].id),
          child: OtherListTile(
            data: otherList[index],
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
    final List<OtherMinResponse> otherList =
        context.read<OtherProvider>().otherList;
    if (query == "") {
      return generateListView(otherList);
    } else {
      final List<OtherMinResponse> otherListFiltered = otherList
          .where((OtherMinResponse x) =>
              x.name.contains(query.toUpperCase()) || x.ip.contains(query))
          .toList();

      return generateListView(otherListFiltered);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<OtherMinResponse> otherList =
        context.read<OtherProvider>().otherList;
    if (query == "") {
      return generateListView(otherList);
    } else {
      final List<OtherMinResponse> otherListFiltered = otherList
          .where((OtherMinResponse x) =>
              x.name.contains(query.toUpperCase()) || x.ip.contains(query))
          .toList();

      return generateListView(otherListFiltered);
    }
  }
}
