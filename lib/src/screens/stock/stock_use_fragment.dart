import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/response/stock_resp.dart';
import '../../providers/stock.dart';
import '../../shared/increment_decrement_icon.dart';
import '../../utils/date_unix.dart';

class StockUseRecyclerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StockProvider>(builder: (_, StockProvider data, __) {
      final List<StockChange> stockUse = data.sortedStockUse;

      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 60),
        itemCount: stockUse.length,
        itemBuilder: (BuildContext context, int index) {
          final StockChange stockUseData = stockUse[index];

          return ChangeStockTile(
            dataTile: stockUseData,
          );
        },
      );
    });
  }
}

class TxtBox extends StatelessWidget {
  const TxtBox({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: color,
          ),
          child: Text(text),
        ),
        const Spacer(),
      ],
    );
  }
}

class ChangeStockTile extends StatelessWidget {
  const ChangeStockTile({Key? key, required this.dataTile}) : super(key: key);
  final StockChange dataTile;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListTile(
          leading: IncDecIcon(value: dataTile.qty),
          title: Text(dataTile.author.toLowerCase()),
          subtitle: Text(dataTile.note),
          trailing: Text(
            dataTile.time.getDateString(),
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}
