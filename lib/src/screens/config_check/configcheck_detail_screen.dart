import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/response/config_check_resp.dart';
import '../../config/pallatte.dart';
import '../../globals.dart';
import '../../providers/config_check.dart';
import '../../shared/disable_glow.dart';
import '../../shared/func_confirm.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/utils.dart';

GlobalKey<RefreshIndicatorState> refreshKeyConfigCheckDetailScreen =
    GlobalKey<RefreshIndicatorState>();

class ConfigCheckDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        title: const Text("Checklist Config"),
      ),
      body: ConfigCheckDetailBody(),
    );
  }
}

class ConfigCheckDetailBody extends StatefulWidget {
  @override
  _ConfigCheckDetailBodyState createState() => _ConfigCheckDetailBodyState();
}

class _ConfigCheckDetailBodyState extends State<ConfigCheckDetailBody> {
  late ConfigCheckProvider _configCheckProviderR;

  @override
  void initState() {
    super.initState();
    _configCheckProviderR = context.read<ConfigCheckProvider>();
    _configCheckProviderR.removeDetail();
    _loadDetail();
  }

  Future<void> _loadDetail() {
    return Future<void>.delayed(Duration.zero, () {
      _configCheckProviderR.getDetail().onError((Object? error, _) {
        Navigator.pop(context);
        showToastError(context: context, message: error.toString());
      });
    });
  }

  Future<void> _saveConfig() {
    return Future<void>.delayed(Duration.zero, () {
      _configCheckProviderR.updateManyChildConfigCheck().then((bool value) {
        if (value) {
          showToastSuccess(
              context: context, message: "Berhasil memperbarui data");
        }
      }).onError((Object? error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
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
                "Apakah kamu ingin menutup pengecekan ?\nPerubahan bersifat permanen!"),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.secondary),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Tidak")),
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
    final ConfigCheckProvider data = context.watch<ConfigCheckProvider>();

    return (data.detailState == ViewState.busy)
        ? const Center(child: CircularProgressIndicator())
        : Stack(
            children: <Widget>[
              buildBody(data), // BODY ----------------------------------------
              if (data.configItemDetail.isFinish)
                const SizedBox.shrink()
              else
                Positioned(
                    bottom: 15,
                    right: 20,
                    child: Row(
                      children: <Widget>[
                        if (data.childState == ViewState.busy)
                          const SizedBox(
                            height: 20,
                            width: 20,
                            child: Center(
                                child: CircularProgressIndicator(
                              color: Pallete.green,
                            )),
                          ),
                        horizontalSpaceSmall,
                        HomeLikeButton(
                          iconData: CupertinoIcons.lock_circle,
                          text: "Lock",
                          tapTap: (data.needPercentage(80.0))
                              ? () async {
                                  final bool? isFinish =
                                      await _getConfirm(context);
                                  if (isFinish != null && isFinish) {
                                    _configCheckProviderR
                                        .updateManyChildConfigCheck()
                                        .then((bool value) {
                                      if (value) {
                                        _configCheckProviderR
                                            .completeConfigCheck()
                                            .then((bool success) {
                                          if (success) {
                                            showToastSuccess(
                                                context: context,
                                                message:
                                                    "Berhasil mengunci data");
                                          } else {
                                            showToastError(
                                                context: context,
                                                message: "Gagal mengunci data");
                                          }
                                        });
                                      }
                                    }).onError((Object? error, _) {
                                      showToastError(
                                          context: context,
                                          message: error.toString());
                                    });
                                  }
                                }
                              : () {
                                  showToastError(
                                      context: context,
                                      message:
                                          "Memerlukan setidaknya 80 persen cek item terisi");
                                },
                          color: Colors.deepOrange.shade200,
                        ),
                        horizontalSpaceSmall,
                        HomeLikeButton(
                          iconData: CupertinoIcons.check_mark_circled_solid,
                          text: "Update",
                          tapTap: _saveConfig,
                        ),
                      ],
                    ))
            ],
          );
  }

  Widget buildBody(ConfigCheckProvider data) {
    final ConfigCheckDetailResponseData detail = data.configItemDetail;
    final Map<String, List<ConfigCheckItem>> networkItemsMap =
        data.getCheckItemSeparatedByLetter();

    final List<Widget> slivers = <Widget>[
      buildHeaderSliver(data),
    ];

    networkItemsMap.forEach((String key, List<ConfigCheckItem> networkItems) {
      slivers
        ..add(SliverToBoxAdapter(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 15, bottom: 8),
            child: Text(
              key,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
          ),
        ))
        ..add(buildListView(networkItems, detail.id));
    });

    // end sliver
    slivers.add(const SliverToBoxAdapter(
      child: SizedBox(
        height: 100,
      ),
    ));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: RefreshIndicator(
        key: refreshKeyConfigCheckDetailScreen,
        onRefresh: _loadDetail,
        child: DisableOverScrollGlow(
          child: CustomScrollView(slivers: slivers),
        ),
      ),
    );
  }

  SliverToBoxAdapter buildHeaderSliver(ConfigCheckProvider data) {
    final ConfigCheckDetailResponseData detail = data.configItemDetail;

    int itemsUpdated = 0;
    final int itemsTotal = detail.configCheckItems.length;

    for (final ConfigCheckItem item in detail.configCheckItems) {
      if (item.isUpdated) {
        itemsUpdated++;
      }
    }

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Pallete.secondaryBackground,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(3)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text("Dibuat / update"),
                Text("Cabang"),
                Text("Tgl cek"),
                Text("Terupdate"),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text("   :   "),
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
                    (detail.updatedBy == detail.createdBy)
                        ? detail.createdBy
                        : "${detail.createdBy} / ${detail.updatedBy}",
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    detail.branch,
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  Text(
                    (detail.timeStarted != 0)
                        ? detail.timeStarted.getDateString()
                        : "",
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  Text(
                    "$itemsUpdated dari $itemsTotal",
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                ],
              ),
            ),
            if (!detail.isFinish && detail.createdBy == App.getName())
              IconButton(
                onPressed: () async {
                  final bool? isDeleted = await getConfirm(context,
                      "Konfirmasi", "Yakin ingin menghapus daftar cek ini?");
                  if (isDeleted != null && isDeleted) {
                    await data.deleteConfigCheck().then((bool value) {
                      if (value) {
                        Navigator.pop(context);
                        showToastSuccess(
                            context: context,
                            message: "Berhasil menghapus ceklist");
                      }
                    }).onError((Object? error, StackTrace stackTrace) {
                      showToastError(
                          context: context, message: error.toString());
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
    );
  }

  SliverList buildListView(List<ConfigCheckItem> checkItems, String parentID) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        child: CheckboxListTile(
          value: checkItems[index].isUpdated,
          onChanged: (_) {
            context
                .read<ConfigCheckProvider>()
                .toggleUpdatedByID(checkItems[index].id);
          },
          title:
              Text(checkItems[index].name.toLowerCase().capitalizeFirstofEach),
          subtitle: Text(
            checkItems[index].location,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      );
    }, childCount: checkItems.length));
  }
}
