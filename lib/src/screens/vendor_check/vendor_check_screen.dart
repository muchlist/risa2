import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/providers/vendor_check.dart';
import 'package:risa2/src/screens/vendor_check/add_check_dialog.dart';
import 'package:risa2/src/shared/vendor_check_item_widget.dart';

import '../../router/routes.dart';
import '../../shared/empty_box.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';

var refreshKeyVendorCheckScreen = GlobalKey<RefreshIndicatorState>();

class VendorCheckScreen extends StatefulWidget {
  @override
  _VendorCheckScreenState createState() => _VendorCheckScreenState();
}

class _VendorCheckScreenState extends State<VendorCheckScreen> {
  late VendorCheckProvider _vendorCheckProvider;

  @override
  void initState() {
    _vendorCheckProvider = context.read<VendorCheckProvider>();
    super.initState();
  }

  @override
  void dispose() {
    _vendorCheckProvider.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Checklist CCTV"),
      ),
      body: VendorCheckRecyclerView(),
    );
  }
}

// VendorCheckReceiclerView ------------------------------------
class VendorCheckRecyclerView extends StatefulWidget {
  @override
  _VendorCheckRecyclerViewState createState() =>
      _VendorCheckRecyclerViewState();
}

class _VendorCheckRecyclerViewState extends State<VendorCheckRecyclerView> {
  void _startAddVendorCheck(BuildContext context) {
    showModalBottomSheet(
      // isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (context) => AddVendorCheckDialog(),
    );
  }

  Future<dynamic> _loadVendorCheck() {
    return Future.delayed(Duration.zero, () {
      context.read<VendorCheckProvider>().findVendorCheck().onError((error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  @override
  void initState() {
    _loadVendorCheck();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VendorCheckProvider>(
      builder: (_, data, __) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: (data.vendorCheckList.length != 0)
                    ? buildListView(data)
                    : (data.state == ViewState.idle)
                        ? EmptyBox(loadTap: _loadVendorCheck)
                        : Center()),
            (data.state == ViewState.busy)
                ? Center(child: CircularProgressIndicator())
                : Center(),
            Positioned(
                bottom: 50,
                child: HomeLikeButton(
                    iconData: CupertinoIcons.add,
                    text: "Buat Checklist",
                    tapTap: () {
                      _startAddVendorCheck(context);
                    })),
          ],
        );
      },
    );
  }

  Widget buildListView(VendorCheckProvider data) {
    return RefreshIndicator(
      key: refreshKeyVendorCheckScreen,
      onRefresh: _loadVendorCheck,
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 60),
        itemCount: data.vendorCheckList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                data.setVendorCheckID(data.vendorCheckList[index].id);
                Navigator.of(context)
                    .pushNamed(RouteGenerator.vendorCheckDetail);
              },
              child: VendorCheckListTile(data: data.vendorCheckList[index]));
        },
      ),
    );
  }
}
