import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/response/stock_resp.dart';
import '../../providers/stock.dart';
import '../../shared/increment_decrement_icon.dart';
import '../../utils/date_unix.dart';

class StockUseRecyclerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StockProvider>(builder: (_, data, __) {
      final stockUse = data.sortedStockUse;

      return ListView.builder(
        padding: EdgeInsets.only(bottom: 60),
        itemCount: stockUse.length,
        itemBuilder: (context, index) {
          final stockUseData = stockUse[index];

          return ChangeStockTile(
            dataTile: stockUseData,
          );
        },
      );
    });
  }
}

class TxtBox extends StatelessWidget {
  final String text;
  final Color color;

  const TxtBox({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: color,
          ),
          child: Text(text),
        ),
        Spacer(),
      ],
    );
  }
}

class ChangeStockTile extends StatelessWidget {
  final StockChange dataTile;

  const ChangeStockTile({Key? key, required this.dataTile}) : super(key: key);

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
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}
