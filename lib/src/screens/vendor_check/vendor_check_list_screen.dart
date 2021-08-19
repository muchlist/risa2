import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../api/json_models/response/vendor_check_list_resp.dart';
import '../../providers/vendor_check.dart';
import '../../router/routes.dart';
import '../../shared/empty_box.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/vendor_check_item_widget.dart';
import '../../utils/utils.dart';

class VendorCheckRecyclerView extends StatefulWidget {
  const VendorCheckRecyclerView({Key? key}) : super(key: key);

  @override
  _VendorCheckRecyclerViewState createState() =>
      _VendorCheckRecyclerViewState();
}

class _VendorCheckRecyclerViewState extends State<VendorCheckRecyclerView> {
  GlobalKey<RefreshIndicatorState> refreshKeyVendorCheckScreen =
      GlobalKey<RefreshIndicatorState>();

  late VendorCheckProvider vendorProvider;

  Future<dynamic> _loadVendorCheck() {
    return Future<void>.delayed(Duration.zero, () {
      vendorProvider.findVendorCheck().onError((Object? error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  @override
  void initState() {
    vendorProvider = context.read<VendorCheckProvider>();
    _loadVendorCheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VendorCheckProvider>(
      builder: (_, VendorCheckProvider data, __) {
        final List<VendorCheckMinResponse> checkList = data.vendorCheckList;
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
              vendorProvider.setVendorCheckID(checkList[index].id);
              Navigator.of(context).pushNamed(RouteGenerator.vendorCheckDetail);
            },
            child: VendorCheckListTile(data: checkList[index]),
          );
        },
      ),
    );
  }
}
