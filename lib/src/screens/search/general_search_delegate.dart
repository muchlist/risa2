import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/response/general_list_resp.dart';
import '../../providers/generals.dart';
import '../../shared/general_item_widget.dart';

/// digunakan saat penambahan history halaman depan
class GeneralSearchDelegate extends SearchDelegate<GeneralMinResponse?> {
  Widget generateListView(List<GeneralMinResponse> generalList) {
    if (generalList.isEmpty) {
      return Center(
          child: SizedBox(
              height: 200,
              width: 200,
              child: Center(
                  child: Lottie.asset('assets/lottie/629-empty-box.json'))));
    }

    return ListView.builder(
      itemCount: generalList.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => close(context, generalList[index]),
          child: GeneralListTile(
            data: generalList[index],
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
    final List<GeneralMinResponse> generalList =
        context.read<GeneralProvider>().generalList;
    if (query == "") {
      return generateListView(generalList);
    } else {
      final List<GeneralMinResponse> generalListFiltered = generalList
          .where((GeneralMinResponse x) =>
              x.name.contains(query.toUpperCase()) || x.ip.contains(query))
          .toList();

      return generateListView(generalListFiltered);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<GeneralMinResponse> generalList =
        context.read<GeneralProvider>().generalList;
    if (query == "") {
      return generateListView(generalList);
    } else {
      final List<GeneralMinResponse> generalListFiltered = generalList
          .where((GeneralMinResponse x) =>
              x.name.contains(query.toUpperCase()) || x.ip.contains(query))
          .toList();

      return generateListView(generalListFiltered);
    }
  }
}
