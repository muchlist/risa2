import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/response/main_maintenance_list_resp.dart';
import '../../providers/cctv_maintenance.dart';
import '../../router/routes.dart';
import '../../shared/cctv_maint_item_widget.dart';
import '../../shared/empty_box.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../utils/enums.dart';
import 'maintenance_dialog.dart';

class CctvMaintScreen extends StatefulWidget {
  @override
  _CctvMaintScreenState createState() => _CctvMaintScreenState();
}

class _CctvMaintScreenState extends State<CctvMaintScreen> {
  late CctvMaintProvider _cctvMaintProvider;

  Future<dynamic> _loadCctvMaint() {
    return Future<void>.delayed(Duration.zero, () {
      _cctvMaintProvider.findCctvCheck().onError((Object? error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  void _startAddCctvMaint(BuildContext context) {
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
    _cctvMaintProvider = context.read<CctvMaintProvider>();
    _loadCctvMaint();
    super.initState();
  }

  @override
  void dispose() {
    _cctvMaintProvider.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Cek Fisik CCTV"),
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
                  CctvMaintRecyclerView(
                    isQuarterCheck: false,
                    cctvMaintProviderR: _cctvMaintProvider,
                  ),
                  CctvMaintRecyclerView(
                    isQuarterCheck: true,
                    cctvMaintProviderR: _cctvMaintProvider,
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
                        _startAddCctvMaint(context);
                      }),
                )),
          ],
        ),
      ),
    );
  }
}

// CctvMaintReceiclerView ------------------------------------
class CctvMaintRecyclerView extends StatefulWidget {
  const CctvMaintRecyclerView(
      {Key? key,
      required this.isQuarterCheck,
      required this.cctvMaintProviderR})
      : super(key: key);
  final bool isQuarterCheck;
  final CctvMaintProvider cctvMaintProviderR;

  @override
  _CctvMaintRecyclerViewState createState() => _CctvMaintRecyclerViewState();
}

class _CctvMaintRecyclerViewState extends State<CctvMaintRecyclerView> {
  GlobalKey<RefreshIndicatorState> refreshKeyCctvMaintScreen =
      GlobalKey<RefreshIndicatorState>();

  Future<dynamic> _loadCctvMaint() {
    return Future<void>.delayed(Duration.zero, () {
      widget.cctvMaintProviderR.findCctvCheck().onError((Object? error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CctvMaintProvider>(
      builder: (_, CctvMaintProvider data, __) {
        List<MainMaintMinResponse> checkList = <MainMaintMinResponse>[];
        if (widget.isQuarterCheck) {
          checkList = data.cctvCheckListQuarter;
        } else {
          checkList = data.cctvCheckListMonthly;
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
                        ? EmptyBox(loadTap: _loadCctvMaint)
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
      key: refreshKeyCctvMaintScreen,
      onRefresh: _loadCctvMaint,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 120),
        itemCount: checkList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              widget.cctvMaintProviderR.setIDSaved(checkList[index].id);
              Navigator.of(context)
                  .pushNamed(RouteGenerator.cctvMaintenanceDetail);
            },
            child: CctvMaintListTile(data: checkList[index]),
          );
        },
      ),
    );
  }
}
