import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/router/routes.dart';
import 'package:risa2/src/screens/search/cctv_search_delegate.dart';
import '../../config/pallatte.dart';
import '../../models/cctv_extra_sum.dart';
import '../../providers/cctvs.dart';
import '../../shared/cctv_item_action_widget.dart';

import '../../shared/cctv_item_widget.dart';
import '../../shared/empty_box.dart';
import '../../shared/flushbar.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';

var refreshKeyCctvScreen = GlobalKey<RefreshIndicatorState>();

class CctvScreen extends StatefulWidget {
  @override
  _CctvScreenState createState() => _CctvScreenState();
}

class _CctvScreenState extends State<CctvScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Inventaris Cctv"),
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.search,
              size: 28,
            ),
            onPressed: () async {
              final searchResult = await showSearch(
                context: context,
                delegate: CctvSearchDelegate(),
              );
              if (searchResult != null) {
                context.read<CctvProvider>().removeDetail();
                context.read<CctvProvider>().setCctvID(searchResult);
                await Navigator.pushNamed(context, RouteGenerator.cctvDetail);
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
            // todo create add cctv screen
            // Navigator.pushNamed(context, RouteGenerator.cctvAdd);
          },
          label: Text("Tambah data")),
      body: CctvRecyclerView(),
    );
  }
}

class CctvRecyclerView extends StatefulWidget {
  @override
  _CctvRecyclerViewState createState() => _CctvRecyclerViewState();
}

class _CctvRecyclerViewState extends State<CctvRecyclerView> {
  var extraInfoIsShow = false;

  Future<void> _loadCctv() {
    return Future.delayed(Duration.zero, () {
      context.read<CctvProvider>().findCctv().onError((error, _) {
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
    return Consumer<CctvProvider>(builder: (_, data, __) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: (data.cctvList.length != 0)
                  ? buildListView(data)
                  : (data.state == ViewState.idle)
                      ? EmptyBox(loadTap: _loadCctv)
                      : Center()),
          (data.state == ViewState.busy)
              ? Center(child: CircularProgressIndicator())
              : Center(),
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
              onTap: () {
                setState(() {
                  extraInfoIsShow = !extraInfoIsShow;
                });
              },
            )),
          if (extraInfoIsShow)
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return GestureDetector(
                    onTap: () {
                      context.read<CctvProvider>().removeDetail();
                      context
                          .read<CctvProvider>()
                          .setCctvID(data.cctvList[index].id);
                      Navigator.pushNamed(context, RouteGenerator.cctvDetail);
                    },
                    child: CctvActionTile(data: data.cctvExtraList[index]));
              }, childCount: data.cctvExtraList.length),
            ),
          if (extraInfoIsShow)
            SliverToBoxAdapter(
                child: Divider(
              height: 20,
              color: Colors.brown[300],
              indent: 40,
              endIndent: 40,
              thickness: 2,
            )),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
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
          SliverToBoxAdapter(
              child: SizedBox(
            height: 100,
          )),
        ],
      ),
    );
  }
}

class CctvSliverHeading extends StatelessWidget {
  final CctvExtraSum data;
  final GestureTapCallback onTap;
  const CctvSliverHeading({required this.data, required this.onTap});

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
                  Text("Perlu pengecekan : ${data.needCheck} unit"),
                  Text("Bermasalah: ${data.needToBeDone} unit"),
                ],
              ),
              Spacer(),
              CircleAvatar(
                maxRadius: 16,
                backgroundColor:
                    (data.needCheck != 0) ? Colors.red.shade300 : Colors.grey,
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
