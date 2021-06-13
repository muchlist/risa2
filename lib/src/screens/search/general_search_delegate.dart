import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/response/general_list_resp.dart';
import '../../providers/generals.dart';
import '../../shared/general_item_widget.dart';

/// digunakan saat penambahan history halaman depan
class GeneralSearchDelegate extends SearchDelegate<GeneralMinResponse?> {
  Widget generateListView(List<GeneralMinResponse> generalList) {
    if (generalList.length == 0) {
      return Center(
          child: SizedBox(
              height: 200,
              width: 200,
              child: Center(
                  child: Lottie.asset('assets/lottie/629-empty-box.json'))));
    }

    return ListView.builder(
      itemCount: generalList.length,
      itemBuilder: (context, index) {
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
    final generalList = context.read<GeneralProvider>().generalList;
    if (query == "") {
      return generateListView(generalList);
    } else {
      final generalListFiltered = generalList
          .where((x) => x.name.contains(query.toUpperCase()))
          .toList();

      return generateListView(generalListFiltered);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final generalList = context.read<GeneralProvider>().generalList;
    if (query == "") {
      return generateListView(generalList);
    } else {
      final generalListFiltered = generalList
          .where((x) => x.name.contains(query.toUpperCase()))
          .toList();

      return generateListView(generalListFiltered);
    }
  }
}
