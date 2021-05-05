import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/stock.dart';
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

          return GestureDetector(
              onTap: () {},
              child: Card(
                child: ListTile(
                  title: (stockUseData.qty < 0)
                      ? TxtBox(
                          text: " Dikurangi ${-stockUseData.qty} ",
                          color: Colors.deepOrange.shade100,
                        )
                      : TxtBox(
                          text: " Ditambahkan ${stockUseData.qty} ",
                          color: Colors.green.shade100,
                        ),
                  subtitle: Text("${stockUseData.note}"),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(DateTransform().unixToDateString(stockUseData.time),
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(stockUseData.author.toLowerCase().split(" ")[0],
                          style: TextStyle(fontSize: 12, color: Colors.grey))
                    ],
                  ),
                ),
              ));
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
