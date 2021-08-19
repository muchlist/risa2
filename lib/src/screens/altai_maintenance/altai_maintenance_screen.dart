import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/response/main_maintenance_list_resp.dart';
import '../../providers/altai_maintenance.dart';
import '../../router/routes.dart';
import '../../shared/cctv_maint_item_widget.dart';
import '../../shared/empty_box.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../utils/enums.dart';
import 'maintenance_dialog.dart';

class AltaiMaintScreen extends StatefulWidget {
  @override
  _AltaiMaintScreenState createState() => _AltaiMaintScreenState();
}

class _AltaiMaintScreenState extends State<AltaiMaintScreen> {
  late AltaiMaintProvider _altaiMaintProvider;

  Future<dynamic> _loadAltaiMaint() {
    return Future<void>.delayed(Duration.zero, () {
      _altaiMaintProvider.findAltaiCheck().onError((Object? error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  void _startAddAltaiMaint(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (BuildContext context) => const AddMaintenanceDialog(),
    );
  }

  @override
  void initState() {
    _altaiMaintProvider = context.read<AltaiMaintProvider>();
    _loadAltaiMaint();
    super.initState();
  }

  @override
  void dispose() {
    _altaiMaintProvider.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Cek Fisik Altai"),
          bottom: const TabBar(
            tabs: <Tab>[
              Tab(
                text: "Bulanan",
              ),
              Tab(
                text: "Triwulan",
              ),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: TabBarView(
                children: <Widget>[
                  AltaiMaintRecyclerView(
                    isQuarterCheck: false,
                    altaiMaintProviderR: _altaiMaintProvider,
                  ),
                  AltaiMaintRecyclerView(
                    isQuarterCheck: true,
                    altaiMaintProviderR: _altaiMaintProvider,
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Center(
                  child: HomeLikeButton(
                      iconData: CupertinoIcons.add,
                      text: "Buat Cek Fisik",
                      tapTap: () {
                        _startAddAltaiMaint(context);
                      }),
                )),
          ],
        ),
      ),
    );
  }
}

// AltaiMaintReceiclerView ------------------------------------
class AltaiMaintRecyclerView extends StatefulWidget {
  const AltaiMaintRecyclerView(
      {Key? key,
      required this.isQuarterCheck,
      required this.altaiMaintProviderR})
      : super(key: key);
  final bool isQuarterCheck;
  final AltaiMaintProvider altaiMaintProviderR;

  @override
  _AltaiMaintRecyclerViewState createState() => _AltaiMaintRecyclerViewState();
}

class _AltaiMaintRecyclerViewState extends State<AltaiMaintRecyclerView> {
  GlobalKey<RefreshIndicatorState> refreshKeyAltaiMaintScreen =
      GlobalKey<RefreshIndicatorState>();

  Future<dynamic> _loadAltaiMaint() {
    return Future<void>.delayed(Duration.zero, () {
      widget.altaiMaintProviderR.findAltaiCheck().onError((Object? error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AltaiMaintProvider>(
      builder: (_, AltaiMaintProvider data, __) {
        List<MainMaintMinResponse> checkList = <MainMaintMinResponse>[];
        if (widget.isQuarterCheck) {
          checkList = data.altaiCheckListQuarter;
        } else {
          checkList = data.altaiCheckListMonthly;
        }

        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: (checkList.isNotEmpty)
                    ? buildListView(checkList)
                    : (data.state == ViewState.idle)
                        ? EmptyBox(loadTap: _loadAltaiMaint)
                        : const Center()),
            if (data.state == ViewState.busy)
              const Center(child: CircularProgressIndicator())
            else
              const Center(),
          ],
        );
      },
    );
  }

  Widget buildListView(List<MainMaintMinResponse> checkList) {
    return RefreshIndicator(
      key: refreshKeyAltaiMaintScreen,
      onRefresh: _loadAltaiMaint,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 120),
        itemCount: checkList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              widget.altaiMaintProviderR.setIDSaved(checkList[index].id);
              Navigator.of(context)
                  .pushNamed(RouteGenerator.altaiMaintenanceDetail);
            },
            child: CctvMaintListTile(data: checkList[index]),
          );
        },
      ),
    );
  }
}
