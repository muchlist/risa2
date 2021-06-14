import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/pallatte.dart';
import '../../providers/others.dart';
import '../../router/routes.dart';
import '../../shared/empty_box.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/other_item_widget.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';
import '../search/other_search_delegate.dart';
import 'other_with_incident_dialog.dart';

var refreshKeyOtherScreen = GlobalKey<RefreshIndicatorState>();

class OtherScreen extends StatefulWidget {
  @override
  _OtherScreenState createState() => _OtherScreenState();
}

class _OtherScreenState extends State<OtherScreen> {
  late OtherProvider _otherProvider;

  @override
  void initState() {
    _otherProvider = context.read<OtherProvider>();
    super.initState();
  }

  @override
  void dispose() {
    _otherProvider.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Daftar ${_otherProvider.subCategory}"),
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.search,
              size: 28,
            ),
            onPressed: () async {
              final searchResult = await showSearch(
                context: context,
                delegate: OtherSearchDelegate(),
              );
              if (searchResult != null) {
                _otherProvider
                  ..removeDetail()
                  ..setOtherID(searchResult);
                await Navigator.pushNamed(context, RouteGenerator.otherDetail);
              }
            },
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.decrease_indent,
              size: 28,
            ),
          ),
          horizontalSpaceSmall
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, RouteGenerator.otherAdd);
          },
          label: Text("Tambah ${_otherProvider.subCategory}")),
      body: OtherRecyclerView(),
    );
  }
}

class OtherRecyclerView extends StatefulWidget {
  @override
  _OtherRecyclerViewState createState() => _OtherRecyclerViewState();
}

class _OtherRecyclerViewState extends State<OtherRecyclerView> {
  void _showOtherWithIncident(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (context) => OtherWithIncidentDialog(),
    );
  }

  Future<void> _loadOther() {
    return Future.delayed(Duration.zero, () {
      context.read<OtherProvider>().findOther().onError((error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  @override
  void initState() {
    _loadOther();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OtherProvider>(builder: (_, data, __) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: (data.otherList.length != 0)
                  ? buildListView(data)
                  : (data.state == ViewState.idle)
                      ? EmptyBox(loadTap: _loadOther)
                      : Center()),
          (data.state == ViewState.busy)
              ? Center(child: CircularProgressIndicator())
              : Center(),
        ],
      );
    });
  }

  Widget buildListView(OtherProvider data) {
    return RefreshIndicator(
      key: refreshKeyOtherScreen,
      onRefresh: _loadOther,
      child: CustomScrollView(
        slivers: <Widget>[
          if (data.otherExtraList.length != 0)
            SliverToBoxAdapter(
                child: OtherSliverHeading(
              totalIncident: data.otherExtraList.length,
              onTap: () => _showOtherWithIncident(context),
            )),
          // LIST CCTV INVENTORY
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return GestureDetector(
                  onTap: () {
                    context.read<OtherProvider>().removeDetail();
                    context
                        .read<OtherProvider>()
                        .setOtherID(data.otherList[index].id);
                    Navigator.pushNamed(context, RouteGenerator.otherDetail);
                  },
                  child: OtherListTile(data: data.otherList[index]));
            }, childCount: data.otherList.length),
          ),
          SliverToBoxAdapter(
              child: SizedBox(
            height: 100,
          )),
        ],
      ),
    );
  }
}

class OtherSliverHeading extends StatelessWidget {
  final int totalIncident;
  final GestureTapCallback onTap;
  const OtherSliverHeading({required this.totalIncident, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Pallete.secondaryBackground,
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Bermasalah: $totalIncident unit"),
                ],
              ),
              Spacer(),
              CircleAvatar(
                maxRadius: 16,
                backgroundColor: Colors.red.shade300,
                child: Icon(
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
