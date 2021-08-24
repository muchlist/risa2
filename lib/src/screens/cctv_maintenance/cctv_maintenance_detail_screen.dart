import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/screens/cctv_maintenance/searchbar.dart';
import 'package:risa2/src/shared/func_history_dial.dart';

import '../../api/json_models/request/cctv_maintenance_req.dart';
import '../../api/json_models/response/cctv_maintenance_resp.dart';
import '../../config/pallatte.dart';
import '../../globals.dart';
import '../../providers/cctv_maintenance.dart';
import '../../providers/histories.dart';
import '../../shared/cctv_maint_item_grid.dart';
import '../../shared/disable_glow.dart';
import '../../shared/func_confirm.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/text_with_icon.dart';
import '../../utils/date_unix.dart';
import '../../utils/enums.dart';

GlobalKey<RefreshIndicatorState> refreshKeyCctvMaintDetailScreen =
    GlobalKey<RefreshIndicatorState>();

class CctvMaintDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          title: const Text("Pengecekan Fisik Cctv"),
        ),
        body: CctvMaintDetailBody());
  }
}

class CctvMaintDetailBody extends StatefulWidget {
  @override
  _CctvMaintDetailBodyState createState() => _CctvMaintDetailBodyState();
}

class _CctvMaintDetailBodyState extends State<CctvMaintDetailBody> {
  late CctvMaintProvider _cctvMaintProviderR;

  @override
  void initState() {
    _cctvMaintProviderR = context.read<CctvMaintProvider>();
    _cctvMaintProviderR.removeDetail();
    _loadDetail();
    super.initState();
  }

  Future<void> _loadDetail() {
    return Future<void>.delayed(Duration.zero, () {
      _cctvMaintProviderR.getDetail().onError((Object? error, _) {
        Navigator.pop(context);
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
                "Apakah kamu ingin mengakhiri pengecekan pada sesi ini?\nPerubahan bersifat permanen!"),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).accentColor),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Tidak")),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Ya"))
            ],
          );
        });
  }

  // Memunculkan return
  Future<void> _dialogUpdateItem(BuildContext context, String cctvname,
      CCTVMaintUpdateRequest itemStateValue) async {
    final bool _isCheckedBefore = itemStateValue.isChecked;
    final bool _isMaintainedBefore = itemStateValue.isMaintained;
    final CCTVMaintUpdateRequest? _itemStateUpdated =
        await showDialog<CCTVMaintUpdateRequest?>(
            context: context,
            builder: (BuildContext context) {
              final CCTVMaintUpdateRequest itemState = itemStateValue;
              return StatefulBuilder(
                  builder: (BuildContext context, Function setState) {
                return AlertDialog(
                  title: Text(cctvname),
                  content: DisableOverScrollGlow(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CheckboxListTile(
                              title: const TextIcon(
                                icon: CupertinoIcons.check_mark_circled,
                                text: "Sudah dicek",
                              ),
                              subtitle:
                                  const Text("tandai jika cctv sudah dicek"),
                              value: itemState.isChecked,
                              onChanged: (bool? checked) {
                                setState(() {
                                  itemState.isChecked = checked ?? false;
                                });
                              }),
                          const Divider(
                            thickness: 1,
                          ),
                          CheckboxListTile(
                              title: const TextIcon(
                                icon: CupertinoIcons.paintbrush,
                                text: "Sudah dibersihkan",
                              ),
                              subtitle: const Text(
                                  "tandai jika sudah dilakukan pembersihan pada CCTV"),
                              value: itemState.isMaintained,
                              onChanged: (bool? maintained) {
                                setState(() {
                                  itemState.isMaintained = maintained ?? false;
                                });
                              }),
                          const Divider(
                            thickness: 1,
                          ),
                          CheckboxListTile(
                              title: const TextIcon(
                                icon: CupertinoIcons.multiply_circle,
                                text: "Cctv offline",
                              ),
                              subtitle: const Text(
                                  "perangkat mati atau tidak dapat di ping"),
                              value: itemState.isOffline,
                              onChanged: (bool? checked) {
                                setState(() {
                                  itemState.isOffline = checked ?? false;
                                });
                              }),
                          const Divider(
                            thickness: 1,
                          ),
                          CheckboxListTile(
                              title: const TextIcon(
                                icon: CupertinoIcons.circle_lefthalf_fill,
                                text: "Cctv blur",
                              ),
                              subtitle: const Text(
                                  "kamera mengalami gangguan dari segi tangkapan gambar"),
                              value: itemState.isBlur,
                              onChanged: (bool? checked) {
                                setState(() {
                                  itemState.isBlur = checked ?? false;
                                });
                              })
                        ],
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).accentColor),
                        onPressed: () {
                          _cctvMaintProviderR
                              .updateChildCctvCheck(itemState)
                              .then((bool value) {
                            if (value && itemState.isChecked) {
                              Navigator.of(context).pop(itemState);
                            } else {
                              Navigator.of(context).pop(itemState);
                            }
                          }).onError((Object? error, StackTrace stackTrace) {
                            showToastError(
                                context: context, message: error.toString());
                          });
                          // if success pop true
                        },
                        child: const Text("Update")),
                  ],
                );
              });
            });

    // Menambahkan incident

    if ((_itemStateUpdated != null && _itemStateUpdated.isChecked) ||
        (_itemStateUpdated != null && _itemStateUpdated.isMaintained)) {
      final bool _isCreateNewCheck =
          _itemStateUpdated.isChecked != _isCheckedBefore;
      final bool _isCreateNewMaintain =
          _itemStateUpdated.isMaintained != _isMaintainedBefore;
      if (_isCreateNewCheck || _isCreateNewMaintain) {
        HistoryHelper()
            .showAddMaintenanceIncident(context, cctvname, _itemStateUpdated);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch data ====================================================
    final CctvMaintProvider data = context.watch<CctvMaintProvider>();

    /// perhitungan hari agar cek fisik hanya bisa ditutup 5 hari sebelum akhir bulan
    /// atau 2 hari setelah awal bulan
    final DateTime now = DateTime.now();
    final int lastDayEpoch = DateTime(now.year, now.month + 1, 0).toInt();
    final int firstDayEpoch = DateTime(now.year, now.month).toInt();
    final int nowEpoch = now.toInt();
    final bool isNBeforeLastMonth = lastDayEpoch - nowEpoch < 60 * 60 * 24 * 5;
    final bool isNAfterNewMonth = nowEpoch - firstDayEpoch < 60 * 60 * 24 * 2;

    return (data.detailState == ViewState.busy)
        ? const Center(child: CircularProgressIndicator())
        : Stack(
            children: <Widget>[
              buildBody(data),
              if (data.cctvCheckDetailWithSearch.isFinish)
                const SizedBox.shrink()
              else if (isNBeforeLastMonth || isNAfterNewMonth)
                Positioned(
                    bottom: 15,
                    right: 20,
                    child: HomeLikeButton(
                      iconData: CupertinoIcons.check_mark_circled_solid,
                      text: "Tutup pengecekan",
                      tapTap: () async {
                        final bool? isFinish = await _getConfirm(context);
                        if (isFinish != null && isFinish) {
                          await data.completeCctvCheck().then((bool value) {
                            if (value) {
                              showToastSuccess(
                                  context: context, message: "Cek selesai");
                              // reload history
                              context
                                  .read<HistoryProvider>()
                                  .findHistory(loading: false);
                            }
                          });
                        }
                      },
                    ))
            ],
          );
  }

  Widget buildBody(CctvMaintProvider data) {
    final CCTVMaintDetailResponseData detail = data.cctvCheckDetailWithSearch;
    final List<String> locations = data.getLocationList();
    final Map<String, List<CCTVMaintCheckItem>> cctvs =
        data.getCheckItemPerLocation(locations);

    final List<Widget> slivers = <Widget>[
      buildHeaderSliver(data),
      buildSearchBar()
    ];

    for (final String loc in locations) {
      slivers
        ..add(SliverToBoxAdapter(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 15, bottom: 8),
            child: Text(
              loc,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ))
        ..add(buildGridViewReady(
            cctvs[loc] ?? <CCTVMaintCheckItem>[], detail.id));
    }

    // end sliver
    slivers.add(const SliverToBoxAdapter(
      child: SizedBox(
        height: 100,
      ),
    ));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: RefreshIndicator(
        key: refreshKeyCctvMaintDetailScreen,
        onRefresh: _loadDetail,
        child: DisableOverScrollGlow(
          child: CustomScrollView(slivers: slivers),
        ),
      ),
    );
  }

  SliverToBoxAdapter buildHeaderSliver(CctvMaintProvider data) {
    final CCTVMaintDetailResponseData detail = data.getFullCctvCheckDetail;

    int cctvChecked = 0;
    int cctvMaintained = 0;
    int cctvOffline = 0;
    int cctvBlur = 0;
    int cctvTotal = 0;

    for (final CCTVMaintCheckItem cctv in detail.cctvMaintCheckItems) {
      if (cctv.isChecked) {
        cctvChecked++;
      }
      if (cctv.isMaintained) {
        cctvMaintained++;
      }
      if (cctv.isBlur) {
        cctvBlur++;
      }
      if (cctv.isOffline) {
        cctvOffline++;
      }
      cctvTotal++;
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
                Text("Judul"),
                Text("Dibuat / update"),
                Text("Tipe cek"),
                Text("Cabang"),
                Text("Mulai cek"),
                Text("Selesai cek"),
                Text("Sudah dicek"),
                Text("Sudah dimaint"),
                Text("Cctv offline"),
                Text("Cctv buram"),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text("   :   "),
                Text("   :   "),
                Text("   :   "),
                Text("   :   "),
                Text("   :   "),
                Text("   :   "),
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
                    detail.name,
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    (detail.updatedBy == detail.createdBy)
                        ? detail.createdBy
                        : "${detail.createdBy} / ${detail.updatedBy}",
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  Text(
                    (detail.quarterlyMode) ? "Triwulan" : "Bulanan",
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
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
                    (detail.timeEnded != 0)
                        ? detail.timeEnded.getDateString()
                        : "",
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  Text(
                    "$cctvChecked dari $cctvTotal unit",
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  Text(
                    "$cctvMaintained dari $cctvTotal unit",
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  Text(
                    "$cctvOffline unit",
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  Text(
                    "$cctvBlur unit",
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
                    await data.deleteCctvCheck().then((bool value) {
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

  SliverToBoxAdapter buildSearchBar() {
    return const SliverToBoxAdapter(
      child: SearchBar(),
    );
  }

  Widget buildGridViewReady(
      List<CCTVMaintCheckItem> checkItems, String parentID) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 130.0,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {},
            child: GestureDetector(
              onTap: () async {
                await _dialogUpdateItem(
                    context,
                    checkItems[index].name,
                    CCTVMaintUpdateRequest(
                        parentID: parentID,
                        childID: checkItems[index].id,
                        isChecked: checkItems[index].isChecked,
                        isMaintained: checkItems[index].isMaintained,
                        isBlur: checkItems[index].isBlur,
                        isOffline: checkItems[index].isOffline));
              },
              child: CctvGridItemTile(
                  key: Key(checkItems[index].id), data: checkItems[index]),
            ),
          );
        },
        childCount: checkItems.length,
      ),
    );
  }
}
