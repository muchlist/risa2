import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/pallatte.dart';
import '../../models/cctv_extra_sum.dart';
import '../../providers/cctvs.dart';
import '../../router/routes.dart';
import '../../shared/cctv_item_widget.dart';
import '../../shared/empty_box.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';
import '../search/cctv_search_delegate.dart';
import 'cctv_with_incident_dialog.dart';

GlobalKey<RefreshIndicatorState> refreshKeyCctvScreen =
    GlobalKey<RefreshIndicatorState>();

class CctvScreen extends StatefulWidget {
  @override
  _CctvScreenState createState() => _CctvScreenState();
}

class _CctvScreenState extends State<CctvScreen> {
  late CctvProvider _cctvProvider;

  @override
  void initState() {
    _cctvProvider = context.read<CctvProvider>();
    super.initState();
  }

  @override
  void dispose() {
    _cctvProvider.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Daftar Cctv"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteGenerator.vendorCheck);
            },
            icon: const Icon(
              CupertinoIcons.checkmark_alt_circle,
              size: 28,
            ),
          ),
          IconButton(
            icon: const Icon(
              CupertinoIcons.search,
              size: 28,
            ),
            onPressed: () async {
              // ignore: always_specify_types
              final searchResult = await showSearch(
                context: context,
                delegate: CctvSearchDelegate(),
              );
              if (searchResult != null) {
                _cctvProvider
                  ..removeDetail()
                  ..setCctvID(searchResult);
                await Navigator.pushNamed(context, RouteGenerator.cctvDetail);
              }
            },
          ),
          horizontalSpaceSmall
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, RouteGenerator.cctvAdd);
          },
          label: const Text("Tambah data")),
      body: CctvRecyclerView(),
    );
  }
}

class CctvRecyclerView extends StatefulWidget {
  @override
  _CctvRecyclerViewState createState() => _CctvRecyclerViewState();
}

class _CctvRecyclerViewState extends State<CctvRecyclerView> {
  void _showCctvWithIncident(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (BuildContext context) => CctvWithIncidentDialog(),
    );
  }

  Future<void> _loadCctv() {
    return Future<void>.delayed(Duration.zero, () {
      context.read<CctvProvider>().findCctv().onError((Object? error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  @override
  void initState() {
    _loadCctv();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CctvProvider>(builder: (_, CctvProvider data, __) {
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: (data.cctvList.isNotEmpty)
                  ? buildListView(data)
                  : (data.state == ViewState.idle)
                      ? EmptyBox(loadTap: _loadCctv)
                      : const Center()),
          if (data.state == ViewState.busy)
            const Center(child: CircularProgressIndicator())
          else
            const Center(),
        ],
      );
    });
  }

  Widget buildListView(CctvProvider data) {
    return RefreshIndicator(
      key: refreshKeyCctvScreen,
      onRefresh: _loadCctv,
      child: CustomScrollView(
        slivers: <Widget>[
          if (data.cctvExtraSum.needCheck != 0 ||
              data.cctvExtraSum.needToBeDone != 0)
            SliverToBoxAdapter(
                child: CctvSliverHeading(
              data: data.cctvExtraSum,
              onTap: () => _showCctvWithIncident(context),
            )),
          // LIST CCTV INVENTORY
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    context.read<CctvProvider>().removeDetail();
                    context
                        .read<CctvProvider>()
                        .setCctvID(data.cctvList[index].id);
                    Navigator.pushNamed(context, RouteGenerator.cctvDetail);
                  },
                  child: CctvListTile(data: data.cctvList[index]));
            }, childCount: data.cctvList.length),
          ),
          const SliverToBoxAdapter(
              child: SizedBox(
            height: 100,
          )),
        ],
      ),
    );
  }
}

class CctvSliverHeading extends StatelessWidget {
  const CctvSliverHeading({required this.data, required this.onTap});
  final CctvExtraSum data;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Pallete.secondaryBackground,
          ),
          child: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Perlu pengecekan : ${data.needCheck} unit"),
                  Text("Bermasalah: ${data.needToBeDone} unit"),
                ],
              ),
              const Spacer(),
              CircleAvatar(
                maxRadius: 16,
                backgroundColor:
                    (data.needCheck != 0) ? Colors.red.shade300 : Colors.grey,
                child: const Icon(
                  CupertinoIcons.eyeglasses,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
