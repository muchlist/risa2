import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/shared/home_like_button.dart';

import '../../api/json_models/response/check_resp.dart';
import '../../config/pallatte.dart';
import '../../providers/checks.dart';
import '../../shared/flushbar.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/date_unix.dart';
import '../../utils/enums.dart';
import 'check_detail_expanse.dart';

class CheckDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          title: const Text("Detail pengecekan shift"),
        ),
        body: CheckDetailBody());
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
        showToastError(context: context, message: error.toString());
      });
    });

    super.initState();
  }

  // Memunculkan dialog
  Future<bool?> _getConfirm(BuildContext context) {
    return showDialog<bool?>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Konfirmasi"),
            content: const Text(
                "Apakah kamu ingin mengakhiri pengecekan pada shift ini?\nDokumen tidak bisa dirubah lagi!"),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).accentColor),
                  child: const Text("Tidak"),
                  onPressed: () => Navigator.of(context).pop(false)),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Ya"))
            ],
          );
        });
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
        : Stack(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      // header
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Pallete.secondaryBackground,
                            borderRadius: BorderRadius.circular(3)),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                            ),
                          ],
                        ),
                      ),

                      // recycler view
                      Expanded(child: buildListView(detail))
                    ],
                  )),
              (detail.isFinish)
                  ? SizedBox.shrink()
                  : Positioned(
                      bottom: 15,
                      right: 20,
                      child: HomeLikeButton(
                        iconData: CupertinoIcons.checkmark_alt,
                        text: "Selesai Shift",
                        tapTap: () async {
                          var isFinish = await _getConfirm(context);
                          if (isFinish != null && isFinish) {
                            await data.completeCheck().then((value) {
                              if (value) {
                                showToastSuccess(
                                    context: context, message: "Cek selesai");
                              }
                            });
                          }
                        },
                        color: Colors.deepOrange.shade300,
                      ))
            ],
          );
  }
}

Widget buildListView(CheckDetailResponseData data) {
  var checkItemsGenerate = data.checkItems;
  // checkItems sort if data isFinish
  if (data.isFinish) {
    checkItemsGenerate.sort((a, b) {
      if (b.checkedAt == 0) {
        return -1;
      }
      return 1;
    });
    // checkItemsGenerate = checkItemsGenerate.reversed.toList();
  }

  return ListView.builder(
      padding: EdgeInsets.only(bottom: 250),
      itemCount: checkItemsGenerate.length,
      itemBuilder: (context, index) {
        var checkItem = checkItemsGenerate[index];

        return Card(
            child: !data.isFinish
                ? ExpansionTileCheck(
                    checkItem: checkItem,
                    parentID: data.id,
                  )
                : ListTileCheck(checkItem: checkItem));
      });
}

// tile yang sudah selesai shift
class ListTileCheck extends StatelessWidget {
  const ListTileCheck({
    Key? key,
    required this.checkItem,
  }) : super(key: key);

  final CheckItem checkItem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(8),
      leading: checkItem.imagePath != ""
          ? SizedBox(
              width: 60,
              height: 60,
              child: Image.network(
                "http://10.4.2.21:3500/${checkItem.imagePath}",
                fit: BoxFit.cover,
              ),
            )
          : null,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(checkItem.name),
          Text(
            "${checkItem.type} ${checkItem.location}",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          verticalSpaceTiny
        ],
      ),
      subtitle: (checkItem.checkedAt != 0)
          ? Text.rich(
              TextSpan(children: [
                WidgetSpan(
                    child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.green.shade100,
                  ),
                  child: Text(
                      " ${DateTransform().unixToDateString(checkItem.checkedAt)} "),
                )),
                (checkItem.tagSelected.isNotEmpty)
                    ? WidgetSpan(
                        child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.yellow.shade100,
                        ),
                        child: Text(" ${checkItem.tagSelected} "),
                      ))
                    : TextSpan(),
                TextSpan(text: " ${checkItem.checkedNote}")
              ]),
            )
          : null,
      trailing: (checkItem.checkedAt != 0)
          ? Wrap(children: [
              Icon(CupertinoIcons.check_mark_circled, color: Colors.green),
              (checkItem.haveProblem)
                  ? Icon(
                      CupertinoIcons.exclamationmark_square,
                      color: Colors.red.shade300,
                    )
                  : SizedBox.shrink(),
            ])
          : Wrap(children: [
              (checkItem.haveProblem)
                  ? Icon(
                      CupertinoIcons.exclamationmark_square,
                      color: Colors.red.shade300,
                    )
                  : SizedBox.shrink(),
            ]),
      key: ValueKey(checkItem.id),
    );
  }
}

// Tile yqang dapat di expansion
class ExpansionTileCheck extends StatelessWidget {
  const ExpansionTileCheck({
    Key? key,
    required this.checkItem,
    required this.parentID,
  }) : super(key: key);

  final CheckItem checkItem;
  final String parentID;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.all(8),
      leading: checkItem.imagePath != ""
          ? SizedBox(
              width: 60,
              height: 60,
              child: Image.network(
                "http://10.4.2.21:3500/${checkItem.imagePath}",
                fit: BoxFit.cover,
              ),
            )
          : null,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            checkItem.name,
          ),
          Text(
            "${checkItem.type} ${checkItem.location}",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          verticalSpaceTiny
        ],
      ),
      subtitle: (checkItem.checkedAt != 0)
          ? Text.rich(
              TextSpan(children: [
                WidgetSpan(
                    child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.green.shade100,
                  ),
                  child: Text(
                      " ${DateTransform().unixToDateString(checkItem.checkedAt)} "),
                )),
                (checkItem.tagSelected.isNotEmpty)
                    ? WidgetSpan(
                        child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.yellow.shade100,
                        ),
                        child: Text(" ${checkItem.tagSelected} "),
                      ))
                    : TextSpan(),
                TextSpan(text: " ${checkItem.checkedNote}")
              ]),
            )
          : null,
      trailing: (checkItem.checkedAt != 0)
          ? Wrap(children: [
              Icon(
                CupertinoIcons.check_mark_circled,
                color: Colors.green,
              ),
              (checkItem.haveProblem)
                  ? Icon(
                      CupertinoIcons.exclamationmark_square,
                      color: Colors.red.shade300,
                    )
                  : SizedBox.shrink(),
            ])
          : Wrap(children: [
              (checkItem.haveProblem)
                  ? Icon(
                      CupertinoIcons.exclamationmark_square,
                      color: Colors.red.shade300,
                    )
                  : SizedBox.shrink(),
            ]),
      expandedAlignment: Alignment.topLeft,
      key: ValueKey(checkItem.id),
      children: [
        verticalSpaceSmall,
        ExpansionChild(
          parentID: parentID,
          checkItem: checkItem,
        )
      ],
    );
  }
}
