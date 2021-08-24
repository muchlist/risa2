import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/screens/vendor_check/searchbar.dart';

import '../../api/json_models/request/vendor_req.dart';
import '../../api/json_models/response/vendor_check_resp.dart';
import '../../config/pallatte.dart';
import '../../globals.dart';
import '../../providers/histories.dart';
import '../../providers/vendor_check.dart';
import '../../shared/disable_glow.dart';
import '../../shared/func_confirm.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/text_with_icon.dart';
import '../../shared/vendor_check_grid.dart';
import '../../utils/date_unix.dart';
import '../../utils/enums.dart';

GlobalKey<RefreshIndicatorState> refreshKeyVendorCheckDetailScreen =
    GlobalKey<RefreshIndicatorState>();

class VendorCheckDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          title: const Text("Pengecekan Cctv Virtual"),
        ),
        body: VendorCheckDetailBody());
  }
}

class VendorCheckDetailBody extends StatefulWidget {
  @override
  _VendorCheckDetailBodyState createState() => _VendorCheckDetailBodyState();
}

class _VendorCheckDetailBodyState extends State<VendorCheckDetailBody> {
  late VendorCheckProvider _vendorCheckProviderR;

  @override
  void initState() {
    _vendorCheckProviderR = context.read<VendorCheckProvider>();
    _vendorCheckProviderR.removeDetail();
    _loadDetail();
    super.initState();
  }

  Future<void> _loadDetail() {
    return Future<void>.delayed(Duration.zero, () {
      _vendorCheckProviderR.getDetail().onError((Object? error, _) {
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
      VendorUpdateRequest itemStateValue) async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          final VendorUpdateRequest itemState = itemStateValue;
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
                          subtitle: const Text("tandai jika cctv sudah dicek"),
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
                      _vendorCheckProviderR
                          .updateChildVendorCheck(itemState)
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
  }

  @override
  Widget build(BuildContext context) {
    // Watch data ====================================================
    final VendorCheckProvider data = context.watch<VendorCheckProvider>();

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
              if (data.geFullVendorCheckDetail.isFinish)
                const SizedBox.shrink()
              else if (isNBeforeLastMonth ||
                  isNAfterNewMonth ||
                  data.geFullVendorCheckDetail.isVirtualCheck)
                Positioned(
                    bottom: 15,
                    right: 20,
                    child: HomeLikeButton(
                      iconData: CupertinoIcons.check_mark_circled_solid,
                      text: "Tutup pengecekan",
                      tapTap: () async {
                        final bool? isFinish = await _getConfirm(context);
                        if (isFinish != null && isFinish) {
                          await data.completeVendorCheck().then((bool value) {
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

  Widget buildBody(VendorCheckProvider data) {
    final VendorCheckDetailResponseData detail =
        data.getVendorCheckDetailWithSearch;
    final List<String> locations = data.getLocationList();
    final Map<String, List<VendorCheckItem>> cctvs =
        data.getCheckItemPerLocation(locations);

    final List<Widget> slivers = <Widget>[
      buildHeaderSliver(data),
      buildSearchBar(),
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
        ..add(buildGridViewReady(cctvs[loc] ?? <VendorCheckItem>[], detail.id));
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
        key: refreshKeyVendorCheckDetailScreen,
        onRefresh: _loadDetail,
        child: DisableOverScrollGlow(
          child: CustomScrollView(slivers: slivers),
        ),
      ),
    );
  }

  SliverToBoxAdapter buildHeaderSliver(VendorCheckProvider data) {
    final VendorCheckDetailResponseData detail = data.geFullVendorCheckDetail;

    int cctvChecked = 0;
    int cctvOffline = 0;
    int cctvBlur = 0;
    int cctvTotal = 0;

    for (final VendorCheckItem cctv in detail.vendorCheckItems) {
      if (cctv.isChecked) {
        cctvChecked++;
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
                Text("Dibuat / update"),
                Text("Tipe cek"),
                Text("Cabang"),
                Text("Mulai cek"),
                Text("Selesai cek"),
                Text("Sudah dicek"),
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
                    (detail.isVirtualCheck) ? "Virtual" : "Fisik",
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                  ),
                  Text(
                    detail.branch,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                  ),
                  Text(
                    (detail.timeStarted != 0)
                        ? detail.timeStarted.getDateString()
                        : "",
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                  ),
                  Text(
                    (detail.timeEnded != 0)
                        ? detail.timeEnded.getDateString()
                        : "",
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                  ),
                  Text(
                    "$cctvChecked dari $cctvTotal unit",
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                  ),
                  Text(
                    "$cctvOffline unit",
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                  ),
                  Text(
                    "$cctvBlur unit",
                    softWrap: true,
                    maxLines: 2,
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
                    await data.deleteVendorCheck().then((bool value) {
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

  Widget buildGridViewReady(List<VendorCheckItem> checkItems, String parentID) {
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
                    VendorUpdateRequest(
                        parentID: parentID,
                        childID: checkItems[index].id,
                        isChecked: checkItems[index].isChecked,
                        isBlur: checkItems[index].isBlur,
                        isOffline: checkItems[index].isOffline));
              },
              child: VendorGridItemTile(
                  key: Key(checkItems[index].id), data: checkItems[index]),
            ),
          );
        },
        childCount: checkItems.length,
      ),
    );
  }
}
