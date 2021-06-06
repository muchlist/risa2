import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/response/computer_list_resp.dart';
import '../../providers/computers.dart';
import '../../shared/computer_item_widget.dart';

class ComputerSearchDelegate extends SearchDelegate<String?> {
  Widget generateListView(List<ComputerMinResponse> computerList) {
    if (computerList.length == 0) {
      return Center(
          child: SizedBox(
              height: 200,
              width: 200,
              child: Center(
                  child: Lottie.asset('assets/lottie/629-empty-box.json'))));
    }

    return ListView.builder(
      itemCount: computerList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => close(context, computerList[index].id),
          child: ComputerListTile(
            data: computerList[index],
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
    final computerList = context.read<ComputerProvider>().computerList;
    if (query == "") {
      return generateListView(computerList);
    } else {
      final computerListFiltered = computerList
          .where((x) =>
              x.name.contains(query.toUpperCase()) || x.ip.contains(query))
          .toList();

      return generateListView(computerListFiltered);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final computerList = context.read<ComputerProvider>().computerList;
    if (query == "") {
      return generateListView(computerList);
    } else {
      final computerListFiltered = computerList
          .where((x) =>
              x.name.contains(query.toUpperCase()) || x.ip.contains(query))
          .toList();

      return generateListView(computerListFiltered);
    }
  }
}
