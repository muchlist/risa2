import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/request/vendor_req.dart';
import '../../api/json_models/response/vendor_check_resp.dart';
import '../../config/pallatte.dart';
import '../../providers/vendor_check.dart';
import '../../shared/disable_glow.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/vendor_check_grid.dart';
import '../../utils/date_unix.dart';
import '../../utils/enums.dart';

var refreshKeyVendorCheckDetailScreen = GlobalKey<RefreshIndicatorState>();

class VendorCheckDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          title: const Text("Pengecekan cctv"),
        ),
        body: VendorCheckDetailBody());
  }
}

class VendorCheckDetailBody extends StatefulWidget {
  @override
  _VendorCheckDetailBodyState createState() => _VendorCheckDetailBodyState();
}

class _VendorCheckDetailBodyState extends State<VendorCheckDetailBody> {
  @override
  void initState() {
    context.read<VendorCheckProvider>().removeDetail();
    _loadDetail();
    super.initState();
  }

  Future<void> _loadDetail() {
    return Future.delayed(Duration.zero, () {
      context.read<VendorCheckProvider>().getDetail().onError((error, _) {
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
                  child: const Text("Tidak"),
                  onPressed: () => Navigator.of(context).pop(false)),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Ya"))
            ],
          );
        });
  }

  // Memunculkan dialog
  Future<void> _dialogUpdateItem(BuildContext context, String cctvname,
      VendorUpdateRequest itemStateValue) async {
    return await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          var itemState = itemStateValue;

          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text(cctvname),
              content: DisableOverScrollGlow(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CheckboxListTile(
                          title: const Text(
                            "Sudah dicek",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: const Text("tandai jika cctv sudah dicek"),
                          value: itemState.isChecked,
                          onChanged: (checked) {
                            setState(() {
                              itemState.isChecked = checked ?? false;
                            });
                          }),
                      const Divider(
                        thickness: 1,
                      ),
                      CheckboxListTile(
                          title: const Text(
                            "Cctv offline",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: const Text(
                              "perangkat mati atau tidak dapat di ping"),
                          value: itemState.isOffline,
                          onChanged: (checked) {
                            setState(() {
                              itemState.isOffline = checked ?? false;
                            });
                          }),
                      const Divider(
                        thickness: 1,
                      ),
                      CheckboxListTile(
                          title: const Text(
                            "Cctv blur",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: const Text(
                              "kamera mengalami gangguan dari segi tangkapan gambar"),
                          value: itemState.isBlur,
                          onChanged: (checked) {
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
                    child: const Text("Update"),
                    onPressed: () {
                      context
                          .read<VendorCheckProvider>()
                          .updateChildVendorCheck(itemState)
                          .then((value) {
                        Navigator.of(context).pop();
                      }).onError((error, stackTrace) {
                        showToastError(
                            context: context, message: error.toString());
                      });
                      // if success pop true
                    }),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    // Watch data ====================================================
    final data = context.watch<VendorCheckProvider>();

    return (data.detailState == ViewState.busy)
        ? const Center(child: CircularProgressIndicator())
        : Stack(
            children: [
              buildBody(data),
              (data.vendorCheckDetail.isFinish)
                  ? SizedBox.shrink()
                  : Positioned(
                      bottom: 15,
                      right: 20,
                      child: HomeLikeButton(
                        iconData: CupertinoIcons.check_mark_circled_solid,
                        text: "Tutup pengecekan",
                        tapTap: () async {
                          var isFinish = await _getConfirm(context);
                          if (isFinish != null && isFinish) {
                            await data.completeVendorCheck().then((value) {
                              if (value) {
                                showToastSuccess(
                                    context: context, message: "Cek selesai");
                              }
                            });
                          }
                        },
                        color: Pallete.green,
                      ))
            ],
          );
  }

  Widget buildBody(VendorCheckProvider data) {
    var detail = data.vendorCheckDetail;
    var locations = data.getLocationList();
    var cctvs = data.getCheckItemPerLocation(locations);

    var slivers = <Widget>[
      buildHeaderSliver(detail),
    ];

    for (final loc in locations) {
      slivers
        ..add(SliverToBoxAdapter(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 15, bottom: 8),
            child: Text(
              loc,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ))
        ..add(buildGridViewReady(cctvs[loc] ?? [], detail.id));
    }

    // end sliver
    slivers.add(SliverToBoxAdapter(
      child: const SizedBox(
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

  SliverToBoxAdapter buildHeaderSliver(VendorCheckDetailResponseData detail) {
    var cctvChecked = 0;
    var cctvOffline = 0;
    var cctvBlur = 0;
    var cctvTotal = 0;

    for (final cctv in detail.vendorCheckItems) {
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
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Pallete.secondaryBackground,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(3)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Dibuat / update"),
                const Text("Tipe cek"),
                const Text("Cabang"),
                const Text("Mulai cek"),
                const Text("Selesai cek"),
                const Text("Sudah dicek"),
                const Text("Cctv offline"),
                const Text("Cctv buram"),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("   :   "),
                const Text("   :   "),
                const Text("   :   "),
                const Text("   :   "),
                const Text("   :   "),
                const Text("   :   "),
                const Text("   :   "),
                const Text("   :   "),
              ],
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    (detail.updatedBy == detail.createdBy)
                        ? detail.createdBy
                        : "${detail.createdBy} / ${detail.updatedBy}",
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontWeight: FontWeight.bold),
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
          ],
        ),
      ),
    );
  }

  Widget buildGridViewReady(List<VendorCheckItem> checkItems, String parentID) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 120.0,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
        childAspectRatio: 4 / 3,
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
