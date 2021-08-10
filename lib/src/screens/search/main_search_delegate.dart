import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/generals.dart';
import '../../shared/func_history_dialog.dart';
import '../../shared/general_item_widget.dart';
import '../../utils/enums.dart';

/// digunakan di home search
class MainSearchDelegate extends SearchDelegate<void> {
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
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Center(
            child: Text(
              "Pencarian harus lebih dari 3 karakter.",
            ),
          )
        ],
      );
    }

    Future<void>.delayed(Duration.zero, () {
      context
          .read<GeneralProvider>()
          .findGeneral(query)
          .onError((Object? error, _) {
        if (error != null) {
          final SnackBar snackBar = SnackBar(
            content: Text(error.toString()),
            duration: const Duration(seconds: 3),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    });

    return Consumer<GeneralProvider>(
      builder: (_, GeneralProvider data, __) {
        return (data.generalList.isEmpty)
            ? Center(
                child: Text(
                  "$query tidak ditemukan...",
                ),
              )
            : ListView.builder(
                itemCount: data.generalList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        HistoryHelper().showParent(
                            context: context,
                            category: data.generalList[index].category,
                            parentID: data.generalList[index].id);
                      },
                      child: GeneralListTile(data: data.generalList[index]));
                },
              );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer<GeneralProvider>(
      builder: (_, GeneralProvider data, __) {
        return (data.state == ViewState.busy)
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: data.generalList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      HistoryHelper().showParent(
                          context: context,
                          category: data.generalList[index].category,
                          parentID: data.generalList[index].id);
                    },
                    child: GeneralListTile(
                      data: data.generalList[index],
                    ),
                  );
                },
              );
      },
    );
  }
}
