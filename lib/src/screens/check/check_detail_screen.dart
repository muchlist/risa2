import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/response/check_resp.dart';
import '../../config/constant.dart';
import '../../config/pallatte.dart';
import '../../globals.dart';
import '../../providers/checks.dart';
import '../../shared/cached_image_square.dart';
import '../../shared/func_confirm.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/date_unix.dart';
import '../../utils/enums.dart';
import '../../utils/string_modifier.dart';
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
    Future<void>.delayed(Duration.zero, () {
      context.read<CheckProvider>().getDetail().onError((Object? error, _) {
        Navigator.pop(context);
        showToastError(context: context, message: error.toString());
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Watch data ====================================================
    final CheckProvider data = context.watch<CheckProvider>();
    final CheckDetailResponseData detail = data.checkDetail ??
        CheckDetailResponseData("", 0, 0, "Loading", "", "Loading", "", "", 0,
            false, "", <CheckItem>[]);

    return (data.detailState == ViewState.busy)
        ? const Center(child: CircularProgressIndicator())
        : Stack(
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: <Widget>[
                      // header
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Pallete.secondaryBackground,
                            borderRadius: BorderRadius.circular(3)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                Text("Nama"),
                                Text("Shift"),
                                Text("Dibuat"),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                Text("   :   "),
                                Text("   :   "),
                                Text("   :   "),
                              ],
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    detail.createdBy,
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Shift ${detail.shift}",
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.clip,
                                  ),
                                  Text(
                                    detail.createdAt.getDateString(),
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.clip,
                                  ),
                                ],
                              ),
                            ),
                            if (!detail.isFinish &&
                                detail.updatedBy == App.getName())
                              IconButton(
                                onPressed: () async {
                                  final bool? isDeleted = await getConfirm(
                                      context,
                                      "Konfirmasi",
                                      "Yakin ingin menghapus daftar cek ini?");
                                  if (isDeleted != null && isDeleted) {
                                    await data.deleteCheck().then((bool value) {
                                      if (value) {
                                        Navigator.pop(context);
                                        showToastSuccess(
                                            context: context,
                                            message:
                                                "Berhasil menghapus ceklist");
                                      }
                                    }).onError(
                                        (Object? error, StackTrace stackTrace) {
                                      showToastError(
                                          context: context,
                                          message: error.toString());
                                    });
                                  }
                                },
                                icon: const Icon(
                                  CupertinoIcons.trash_circle,
                                  color: Colors.redAccent,
                                ),
                              )
                          ],
                        ),
                      ),

                      // recycler view
                      Expanded(child: buildListView(detail))
                    ],
                  )),
              if (detail.isFinish)
                const SizedBox.shrink()
              else
                Positioned(
                    bottom: 15,
                    right: 20,
                    child: HomeLikeButton(
                      iconData: CupertinoIcons.check_mark_circled_solid,
                      text: "Selesai Shift",
                      tapTap: () async {
                        final bool? isFinish = await getConfirm(
                            context,
                            "Konfirmasi",
                            "Apakah kamu ingin mengakhiri pengecekan pada shift ini?\nDokumen tidak bisa dirubah lagi!");
                        if (isFinish != null && isFinish) {
                          await data.completeCheck().then((bool value) {
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
  final List<CheckItem> checkItemsGenerate = data.checkItems;
  // checkItems sort if data isFinish
  if (data.isFinish) {
    checkItemsGenerate.sort((CheckItem a, CheckItem b) {
      if (b.checkedAt == 0) {
        return -1;
      }
      return 1;
    });
    // checkItemsGenerate = checkItemsGenerate.reversed.toList();
  }

  return ListView.builder(
      padding: const EdgeInsets.only(bottom: 250),
      itemCount: checkItemsGenerate.length,
      itemBuilder: (BuildContext context, int index) {
        final CheckItem checkItem = checkItemsGenerate[index];

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
      contentPadding: const EdgeInsets.all(8),
      leading: checkItem.imagePath != ""
          ? CachedImageSquare(
              urlPath:
                  "${Constant.baseUrl}${checkItem.imagePath.thumbnailMod()}",
              height: 50,
              width: 50,
            )
          : null,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
              TextSpan(children: <InlineSpan>[
                WidgetSpan(
                    child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.green.shade100,
                  ),
                  child: Text(" ${checkItem.checkedAt.getDateString()} "),
                )),
                if (checkItem.tagSelected.isNotEmpty)
                  WidgetSpan(
                      child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.yellow.shade100,
                    ),
                    child: Text(" ${checkItem.tagSelected} "),
                  ))
                else
                  const TextSpan(),
                TextSpan(text: " ${checkItem.checkedNote}")
              ]),
            )
          : null,
      trailing: (checkItem.checkedAt != 0)
          ? Wrap(children: <Widget>[
              const Icon(CupertinoIcons.check_mark_circled,
                  color: Colors.green),
              if (checkItem.haveProblem)
                Icon(
                  CupertinoIcons.exclamationmark_square,
                  color: Colors.red.shade300,
                )
              else
                const SizedBox.shrink(),
            ])
          : Wrap(children: <Widget>[
              if (checkItem.haveProblem)
                Icon(
                  CupertinoIcons.exclamationmark_square,
                  color: Colors.red.shade300,
                )
              else
                const SizedBox.shrink(),
            ]),
      key: ValueKey<String>(checkItem.id),
    );
  }
}

// Tile yang dapat di expansion
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
      tilePadding: const EdgeInsets.all(8),
      leading: checkItem.imagePath != ""
          ? CachedImageSquare(
              urlPath: "${Constant.baseUrl}${checkItem.imagePath}",
              height: 50,
              width: 50,
            )
          : null,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
              TextSpan(children: <InlineSpan>[
                WidgetSpan(
                    child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.green.shade100,
                  ),
                  child: Text(" ${checkItem.checkedAt.getDateString()} "),
                )),
                if (checkItem.tagSelected.isNotEmpty)
                  WidgetSpan(
                      child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.yellow.shade100,
                    ),
                    child: Text(" ${checkItem.tagSelected} "),
                  ))
                else
                  const TextSpan(),
                TextSpan(text: " ${checkItem.checkedNote}")
              ]),
            )
          : null,
      trailing: (checkItem.checkedAt != 0)
          ? Wrap(children: <Widget>[
              const Icon(
                CupertinoIcons.check_mark_circled,
                color: Colors.green,
              ),
              if (checkItem.haveProblem)
                Icon(
                  CupertinoIcons.exclamationmark_square,
                  color: Colors.red.shade300,
                )
              else
                const SizedBox.shrink(),
            ])
          : Wrap(children: <Widget>[
              if (checkItem.haveProblem)
                Icon(
                  CupertinoIcons.exclamationmark_square,
                  color: Colors.red.shade300,
                )
              else
                const SizedBox.shrink(),
            ]),
      expandedAlignment: Alignment.topLeft,
      key: ValueKey<String>(checkItem.id),
      children: <Widget>[
        verticalSpaceSmall,
        ExpansionChild(
          parentID: parentID,
          checkItem: checkItem,
        )
      ],
    );
  }
}
