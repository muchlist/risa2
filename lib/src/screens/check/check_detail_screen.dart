import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/api/json_models/response/check_resp.dart';
import 'package:risa2/src/config/pallatte.dart';
import 'package:risa2/src/providers/checks.dart';
import 'package:risa2/src/shared/ui_helpers.dart';
import 'package:risa2/src/utils/date_unix.dart';
import 'package:risa2/src/utils/enums.dart';

import 'check_detail_expanse.dart';

class CheckDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Detail pengecekan shift"),
      ),
      body: CheckDetailBody(),
    );
  }
}

class CheckDetailBody extends StatefulWidget {
  @override
  _CheckDetailBodyState createState() => _CheckDetailBodyState();
}

class _CheckDetailBodyState extends State<CheckDetailBody> {
  @override
  void initState() {
    context.read<CheckProvider>().removeDetail();
    Future.delayed(Duration.zero, () {
      context.read<CheckProvider>().getDetail().onError((error, _) {
        Navigator.pop(context);
        Flushbar(
          message: error.toString(),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red.withOpacity(0.7),
        )..show(context);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Watch data ====================================================
    final data = context.watch<CheckProvider>();
    var detail = data.checkDetail ??
        CheckDetailResponseData(
            "", 0, 0, "Loading", "", "Loading", "", "", 0, false, "", []);

    return (data.detailState == ViewState.busy)
        ? Center(child: CircularProgressIndicator())
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                // header
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Pallete.secondaryBackground,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Nama"),
                          Text("Shift"),
                          Text("Dibuat"),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("   :   "),
                          Text("   :   "),
                          Text("   :   "),
                        ],
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              detail.createdBy,
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Shift ${detail.shift}",
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                            ),
                            Text(
                              "${DateTransform().unixToDateString(detail.createdAt)}",
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                // recycler view
                Expanded(child: buildListView(detail))
              ],
            ));
  }
}

Widget buildListView(CheckDetailResponseData data) {
  return ListView.builder(
      padding: EdgeInsets.only(bottom: 60),
      itemCount: data.checkItems.length,
      itemBuilder: (context, index) {
        var checkItem = data.checkItems[index];

        return Card(
          child: ExpansionTile(
            // leading: checkItem.imagePath != ""
            //     ? Image.network(checkItem.imagePath)
            //     : null,
            title: Text(checkItem.name),
            subtitle: (checkItem.checkedAt != 0)
                ? Text(
                    "(${DateTransform().unixToDateString(checkItem.checkedAt)}) - ${checkItem.checkedNote}",
                  )
                : null,
            trailing: (checkItem.completeStatus == 4)
                ? Icon(CupertinoIcons.check_mark_circled)
                : Icon(CupertinoIcons.square),
            expandedAlignment: Alignment.topLeft,
            key: ValueKey(checkItem.id),
            children: [
              verticalSpaceSmall,
              ExpansionChild(
                parentID: data.id,
                checkItem: checkItem,
              )
            ],
          ),
        );
      });
}
