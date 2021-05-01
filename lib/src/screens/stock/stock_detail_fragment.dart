import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/response/stock_resp.dart';
import '../../config/constant.dart';
import '../../config/pallatte.dart';
import '../../providers/stock.dart';
import '../../shared/cached_image_square.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/date_unix.dart';
import '../../utils/enums.dart';

class StockDetailFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stockProvider = context.watch<StockProvider>();
    final detail = stockProvider.stockDetail;

    return Stack(children: [
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upper table
              Text(
                detail.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: Table(
                  columnWidths: {
                    0: FlexColumnWidth(1.0),
                    1: FlexColumnWidth(0.5),
                    2: FlexColumnWidth(3.0)
                  },
                  children: [
                    TableRow(children: [
                      const Text("Kategori"),
                      const Text("   :   "),
                      Text(
                        detail.stockCategory,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                      ),
                    ]),
                    TableRow(children: [
                      const Text("Cabang"),
                      const Text("   :   "),
                      Text(
                        detail.branch,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                      ),
                    ]),
                    TableRow(children: [
                      const Text("Lokasi"),
                      const Text("   :   "),
                      Text(
                        detail.location,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                      ),
                    ]),
                    TableRow(children: [
                      const Text("Update"),
                      const Text("   :   "),
                      Text(
                        DateTransform().unixToDateString(detail.updatedAt),
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                      ),
                    ])
                  ],
                ),
              ),
              verticalSpaceMedium,

              // Bottom table
              Text(
                "Sisa ${detail.qty} ${detail.unit}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: Table(
                  columnWidths: {
                    0: FlexColumnWidth(1.0),
                    1: FlexColumnWidth(0.5),
                    2: FlexColumnWidth(3.0)
                  },
                  children: [
                    TableRow(children: [
                      const Text("Ditambah"),
                      const Text("   :   "),
                      Text(
                        "${stockProvider.getStockIncrementCount()} ${detail.unit}",
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ]),
                    TableRow(children: [
                      const Text("Terpakai"),
                      const Text("   :   "),
                      Text(
                        "${stockProvider.getStockDecrementCount()} ${detail.unit}",
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                      ),
                    ]),
                  ],
                ),
              ),
              verticalSpaceMedium,
              buttonContainer(detail),
            ],
          ),
        ),
      ),
      // Loading Screen
      if (stockProvider.detailState == ViewState.busy)
        Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        )
    ]);
  }

  Widget buttonContainer(StockDetailResponseData detail) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                (detail.image.isNotEmpty)
                    ? Flexible(
                        flex: 1,
                        child: CachedImageSquare(
                          urlPath: "${Constant.baseUrl}${detail.image}",
                        ))
                    : Container(
                        decoration: BoxDecoration(
                            color: Pallete.secondaryBackground,
                            borderRadius: BorderRadius.circular(10.0)),
                        width: 100,
                        height: 100,
                        child: Icon(CupertinoIcons.camera)),
                horizontalSpaceMedium,
                Expanded(
                    flex: 1,
                    child: Wrap(
                      children: [
                        TextButton.icon(
                            onPressed: () {},
                            icon: Icon(CupertinoIcons.pencil_circle),
                            label: const Text("Edit")),
                        TextButton.icon(
                            onPressed: () {},
                            style:
                                TextButton.styleFrom(primary: Colors.red[400]),
                            icon: Icon(CupertinoIcons.trash_circle),
                            label: const Text("Hapus")),
                      ],
                    ))
              ],
            ),
            verticalSpaceMedium,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(CupertinoIcons.plus_circle),
                    label: const Text("Tambah Stok")),
                ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(CupertinoIcons.minus_circle),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepOrange[300]),
                    label: const Text("Kurangi Stok")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
