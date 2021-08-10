import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../api/json_models/response/vendor_check_list_resp.dart';

import '../../providers/vendor_check.dart';
import '../../router/routes.dart';
import '../../shared/empty_box.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/vendor_check_item_widget.dart';
import '../../utils/enums.dart';
import 'add_vendor_check_dialog.dart';

class VendorCheckScreen extends StatefulWidget {
  @override
  _VendorCheckScreenState createState() => _VendorCheckScreenState();
}

class _VendorCheckScreenState extends State<VendorCheckScreen> {
  late VendorCheckProvider _vendorCheckProvider;

  Future<dynamic> _loadVendorCheck() {
    return Future<void>.delayed(Duration.zero, () {
      _vendorCheckProvider.findVendorCheck().onError((Object? error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  void _startAddVendorCheck(BuildContext context) {
    showModalBottomSheet(
      // isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (BuildContext context) => const AddVendorCheckDialog(),
    );
  }

  @override
  void initState() {
    _vendorCheckProvider = context.read<VendorCheckProvider>();
    _loadVendorCheck();
    super.initState();
  }

  @override
  void dispose() {
    _vendorCheckProvider.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Checklist CCTV"),
          bottom: const TabBar(
            tabs: <Tab>[
              Tab(
                text: "Virtual",
              ),
              Tab(
                text: "Fisik",
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
                  VendorCheckRecyclerView(
                    virtualCheckScreen: true,
                    vendorProviderR: _vendorCheckProvider,
                  ),
                  VendorCheckRecyclerView(
                    virtualCheckScreen: false,
                    vendorProviderR: _vendorCheckProvider,
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
                      text: "Buat Checklist",
                      tapTap: () {
                        _startAddVendorCheck(context);
                      }),
                )),
          ],
        ),
      ),
    );
  }
}

// VendorCheckReceiclerView ------------------------------------
class VendorCheckRecyclerView extends StatefulWidget {
  const VendorCheckRecyclerView(
      {Key? key,
      required this.virtualCheckScreen,
      required this.vendorProviderR})
      : super(key: key);
  final bool virtualCheckScreen;
  final VendorCheckProvider vendorProviderR;

  @override
  _VendorCheckRecyclerViewState createState() =>
      _VendorCheckRecyclerViewState();
}

class _VendorCheckRecyclerViewState extends State<VendorCheckRecyclerView> {
  GlobalKey<RefreshIndicatorState> refreshKeyVendorCheckScreen =
      GlobalKey<RefreshIndicatorState>();

  Future<dynamic> _loadVendorCheck() {
    return Future<void>.delayed(Duration.zero, () {
      widget.vendorProviderR.findVendorCheck().onError((Object? error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VendorCheckProvider>(
      builder: (_, VendorCheckProvider data, __) {
        List<VendorCheckMinResponse> checkList = <VendorCheckMinResponse>[];
        if (widget.virtualCheckScreen) {
          checkList = data.vendorCheckListVirtual;
        } else {
          checkList = data.vendorCheckListPhyshic;
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
                        ? EmptyBox(loadTap: _loadVendorCheck)
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

  Widget buildListView(List<VendorCheckMinResponse> checkList) {
    return RefreshIndicator(
      key: refreshKeyVendorCheckScreen,
      onRefresh: _loadVendorCheck,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 120),
        itemCount: checkList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              widget.vendorProviderR.setVendorCheckID(checkList[index].id);
              Navigator.of(context).pushNamed(RouteGenerator.vendorCheckDetail);
            },
            child: VendorCheckListTile(data: checkList[index]),
          );
        },
      ),
    );
  }
}
