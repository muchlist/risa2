import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/response/altai_virtual_list_resp.dart';
import '../../providers/altai_virtual.dart';
import '../../router/routes.dart';
import '../../shared/altai_virtual_list_tile.dart';
import '../../shared/empty_box.dart';
import '../../shared/func_flushbar.dart';
import '../../utils/utils.dart';

class AltaiVirtualRecyclerView extends StatefulWidget {
  const AltaiVirtualRecyclerView({Key? key}) : super(key: key);

  @override
  _AltaiVirtualRecyclerViewState createState() =>
      _AltaiVirtualRecyclerViewState();
}

class _AltaiVirtualRecyclerViewState extends State<AltaiVirtualRecyclerView> {
  GlobalKey<RefreshIndicatorState> refreshKeyAltaiVirtualScreen =
      GlobalKey<RefreshIndicatorState>();

  late AltaiVirtualProvider vendorProvider;

  Future<dynamic> _loadAltaiVirtual() {
    return Future<void>.delayed(Duration.zero, () {
      vendorProvider.findAltaiVirtual().onError((Object? error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  @override
  void initState() {
    vendorProvider = context.read<AltaiVirtualProvider>();
    _loadAltaiVirtual();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AltaiVirtualProvider>(
      builder: (_, AltaiVirtualProvider data, __) {
        final List<AltaiVirtualMinResponse> checkList = data.altaiVirtualList;
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
                        ? EmptyBox(loadTap: _loadAltaiVirtual)
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

  Widget buildListView(List<AltaiVirtualMinResponse> checkList) {
    return RefreshIndicator(
      key: refreshKeyAltaiVirtualScreen,
      onRefresh: _loadAltaiVirtual,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 120),
        itemCount: checkList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              vendorProvider.setAltaiVirtualID(checkList[index].id);
              Navigator.of(context)
                  .pushNamed(RouteGenerator.altaiVirtualDetail);
            },
            child: AltaiVirtualListTile(data: checkList[index]),
          );
        },
      ),
    );
  }
}
