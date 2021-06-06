import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/screens/search/computer_search_delegate.dart';

import '../../config/pallatte.dart';
import '../../providers/computers.dart';
import '../../shared/computer_item_widget.dart';
import '../../shared/empty_box.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';
import 'computer_with_incident_dialog.dart';

var refreshKeyComputerScreen = GlobalKey<RefreshIndicatorState>();

class ComputerScreen extends StatefulWidget {
  @override
  _ComputerScreenState createState() => _ComputerScreenState();
}

class _ComputerScreenState extends State<ComputerScreen> {
  late ComputerProvider _computerProvider;

  @override
  void initState() {
    _computerProvider = context.read<ComputerProvider>();
    super.initState();
  }

  @override
  void dispose() {
    _computerProvider.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Inventaris Computer"),
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.search,
              size: 28,
            ),
            onPressed: () async {
              final searchResult = await showSearch(
                context: context,
                delegate: ComputerSearchDelegate(),
              );
              // if (searchResult != null) {
              //   _computerProvider
              //     ..removeDetail()
              //     ..setComputerID(searchResult);
              //   await Navigator.pushNamed(
              //       context, RouteGenerator.computerDetail);
              // }
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
            // Navigator.pushNamed(context, RouteGenerator.computerAdd);
          },
          label: Text("Tambah Komputer")),
      body: ComputerRecyclerView(),
    );
  }
}

class ComputerRecyclerView extends StatefulWidget {
  @override
  _ComputerRecyclerViewState createState() => _ComputerRecyclerViewState();
}

class _ComputerRecyclerViewState extends State<ComputerRecyclerView> {
  void _showComputerWithIncident(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (context) => ComputerWithIncidentDialog(),
    );
  }

  Future<void> _loadComputer() {
    return Future.delayed(Duration.zero, () {
      context.read<ComputerProvider>().findComputer().onError((error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  @override
  void initState() {
    _loadComputer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ComputerProvider>(builder: (_, data, __) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: (data.computerList.length != 0)
                  ? buildListView(data)
                  : (data.state == ViewState.idle)
                      ? EmptyBox(loadTap: _loadComputer)
                      : Center()),
          (data.state == ViewState.busy)
              ? Center(child: CircularProgressIndicator())
              : Center(),
        ],
      );
    });
  }

  Widget buildListView(ComputerProvider data) {
    return RefreshIndicator(
      key: refreshKeyComputerScreen,
      onRefresh: _loadComputer,
      child: CustomScrollView(
        slivers: <Widget>[
          if (data.computerExtraList.length != 0)
            SliverToBoxAdapter(
                child: ComputerSliverHeading(
              totalIncident: data.computerExtraList.length,
              onTap: () => _showComputerWithIncident(context),
            )),
          // LIST CCTV INVENTORY
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return GestureDetector(
                  onTap: () {
                    // context.read<ComputerProvider>().removeDetail();
                    // context
                    //     .read<ComputerProvider>()
                    //     .setComputerID(data.computerList[index].id);
                    // Navigator.pushNamed(context, RouteGenerator.computerDetail);
                  },
                  child: ComputerListTile(data: data.computerList[index]));
            }, childCount: data.computerList.length),
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

class ComputerSliverHeading extends StatelessWidget {
  final int totalIncident;
  final GestureTapCallback onTap;
  const ComputerSliverHeading(
      {required this.totalIncident, required this.onTap});

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
