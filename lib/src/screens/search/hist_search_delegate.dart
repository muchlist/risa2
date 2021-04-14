import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/generals.dart';
import '../../shared/general_item_widget.dart';

class HistorySearchDelegate extends SearchDelegate {
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
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: const Text(
              "Pencarian harus lebih dari 3 karakter.",
            ),
          )
        ],
      );
    }

    context.read<GeneralProvider>().findGeneral(query).onError((error, _) {
      if (error != null) {
        final snackBar = SnackBar(
          content: Text(error.toString()),
          duration: Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });

    return Consumer<GeneralProvider>(
      builder: (_, data, __) {
        return (data.generalList.length == 0)
            ? Center(
                child: Text(
                  "$query tidak ditemukan...",
                ),
              )
            : ListView.builder(
                itemCount: data.generalList.length,
                itemBuilder: (context, index) {
                  return GeneralListTile(data: data.generalList[index]);
                },
              );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer<GeneralProvider>(
      builder: (_, data, __) {
        return (data.isLoading)
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: data.generalList.length,
                itemBuilder: (context, index) {
                  return GeneralListTile(
                    data: data.generalList[index],
                  );
                },
              );
      },
    );
  }
}